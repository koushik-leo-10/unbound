import 'dart:convert';
import '../generated/protocol.dart';
import 'validators.dart';

/// Validates and converts raw LLM JSON into typed models.
class AiParsers {
  static String mindMap(Map<String, dynamic> json, {required String originalText}) {
    if (json.containsKey('label') && json['label'] is String) {
      return jsonEncode(json);
    }
    return mindMapFallback(originalText);
  }

  static String mindMapFallback(String text) {
    final clean = text.trim();
    final lines = clean
        .split(RegExp(r'[\r\n]+'))
        .map((l) => l.replaceAll(RegExp(r'^[*\-#0-9.]+\s*'), '').trim())
        .where((l) => l.isNotEmpty)
        .toList();

    final rootLabel = lines.isNotEmpty && lines[0].length < 60
        ? lines[0]
        : (clean.length > 30 ? '${clean.substring(0, 30)}...' : clean);
    final remaining = lines.length > 1 ? lines.sublist(1) : <String>[];

    final branchColors = ['#4F46E5', '#06B6D4', '#10B981', '#F59E0B', '#EC4899', '#8B5CF6'];
    final branches = <Map<String, dynamic>>[];

    if (remaining.isNotEmpty) {
      final chunkSize = (remaining.length / 3).ceil().clamp(1, 4);
      for (var i = 0; i < remaining.length && branches.length < 5; i += chunkSize) {
        final branchLabel = remaining[i];
        final subItems = remaining.skip(i + 1).take(chunkSize - 1).map((s) => {
          'id': 'sub-${branches.length}-${s.hashCode}',
          'label': s.length > 40 ? '${s.substring(0, 40)}...' : s,
          'color': branchColors[branches.length % branchColors.length],
          'children': [],
        }).toList();

        branches.add({
          'id': 'b-${branches.length}',
          'label': branchLabel.length > 40 ? '${branchLabel.substring(0, 40)}...' : branchLabel,
          'color': branchColors[branches.length % branchColors.length],
          'children': subItems,
        });
      }
    } else {
      final defaults = [
        {'label': 'Key Concepts', 'sub': ['Overview', 'Core Definitions']},
        {'label': 'Action Steps', 'sub': ['Phase 1 Implementation', 'Review & Testing']},
        {'label': 'Resources & Tools', 'sub': ['Documentation', 'Key Dependencies']},
      ];
      for (var i = 0; i < defaults.length; i++) {
        final d = defaults[i];
        branches.add({
          'id': 'b-$i',
          'label': d['label'] as String,
          'color': branchColors[i % branchColors.length],
          'children': (d['sub'] as List<String>).map((s) => {
            'id': 'sub-$i-${s.hashCode}',
            'label': s,
            'color': branchColors[i % branchColors.length],
            'children': [],
          }).toList(),
        });
      }
    }

    return jsonEncode({
      'id': 'root',
      'label': rootLabel.isEmpty ? 'Mind Map' : rootLabel,
      'color': '#4F46E5',
      'children': branches,
    });
  }
  static SummaryResult summary(Map<String, dynamic> json) {
    final summary = _string(json['summary']);
    if (summary.isEmpty) {
      throw AppException(message: 'The AI could not find anything to summarise.');
    }
    return SummaryResult(
      summary: _clip(summary, 1500),
      keyPoints: _stringList(json['keyPoints']),
      actionItems: _stringList(json['actionItems']),
      suggestedTasks: _suggestedTasks(json['suggestedTasks']),
    );
  }

  static VoiceCommandResult voiceCommand(
    Map<String, dynamic> json, {
    required String originalText,
  }) {
    final intent = VoiceIntent.values.asNameMap()[_string(json['intent']).toLowerCase()] ??
        VoiceIntent.unknown;
    final title = _string(json['title']);
    final content = _string(json['content']);
    return VoiceCommandResult(
      intent: intent,
      title: _clip(title.isEmpty ? originalText : title, Validators.maxTitleLength),
      content: content.isEmpty ? originalText : content,
      dueAt: _date(json['dueAt']),
      priority: _priority(json['priority']),
      durationMinutes: _duration(json['durationMinutes']),
    );
  }

  static String suggestion(Map<String, dynamic> json) {
    final message = _string(json['message']);
    if (message.isEmpty) {
      throw AppException(message: 'The AI returned an empty suggestion.');
    }
    return _clip(message, 300);
  }

  // ---- helpers -----------------------------------------------------------

  static List<SuggestedTask> _suggestedTasks(Object? value) {
    if (value is! List) return [];
    final tasks = <SuggestedTask>[];
    for (final item in value.take(15)) {
      if (item is! Map<String, dynamic>) continue;
      final title = _string(item['title']);
      if (title.isEmpty) continue;
      tasks.add(SuggestedTask(
        title: _clip(title, Validators.maxTitleLength),
        dueAt: _date(item['dueAt']),
        priority: _priority(item['priority']),
        durationMinutes: _duration(item['durationMinutes']),
      ));
    }
    return tasks;
  }

  static String _string(Object? value) => value is String ? value.trim() : '';

  static String _clip(String text, int max) =>
      text.length <= max ? text : text.substring(0, max);

  static List<String> _stringList(Object? value) {
    if (value is! List) return [];
    return value.map(_string).where((s) => s.isNotEmpty).take(20).toList();
  }

  /// Unparseable or unreasonable dates become null (never guessed).
  static DateTime? _date(Object? value) {
    if (value is! String) return null;
    final parsed = DateTime.tryParse(value);
    if (parsed == null) return null;
    final utc = parsed.isUtc
        ? parsed
        : DateTime.utc(parsed.year, parsed.month, parsed.day, parsed.hour, parsed.minute, parsed.second);
    return Validators.isReasonableDate(utc) ? utc : null;
  }

  static TaskPriority _priority(Object? value) =>
      TaskPriority.values.asNameMap()[_string(value).toLowerCase()] ?? TaskPriority.medium;

  static int _duration(Object? value) =>
      value is num ? Validators.duration(value.round()) : 60;
}
