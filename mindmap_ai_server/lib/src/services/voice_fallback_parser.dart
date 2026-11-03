import '../generated/protocol.dart';
import 'validators.dart';

/// Simple rule-based interpretation of a spoken sentence.
/// Used when the LLM is unavailable (no key, timeout, rate limit).
class VoiceFallbackParser {
  static final RegExp _taskPrefix = RegExp(
    r'^(?:please\s+)?(?:add (?:a )?task|create (?:a )?task|new task|task|to-?do|remind me to|remind me)\b[:,]?\s*',
    caseSensitive: false,
  );
  static final RegExp _notePrefix = RegExp(
    r'^(?:please\s+)?(?:save (?:a )?note|take (?:a )?note|new note|note)\b[:,]?\s*',
    caseSensitive: false,
  );

  static VoiceCommandResult parse(String text) {
    final clean = text.trim();
    if (_taskPrefix.hasMatch(clean)) {
      final title = clean.replaceFirst(_taskPrefix, '').trim();
      return _result(VoiceIntent.task, title.isEmpty ? clean : title, clean);
    }
    final noteBody = clean.replaceFirst(_notePrefix, '').trim();
    return _result(VoiceIntent.note, noteBody.isEmpty ? clean : noteBody, clean);
  }

  static VoiceCommandResult _result(VoiceIntent intent, String title, String content) {
    final short = title.length > 80 ? title.substring(0, 80) : title;
    return VoiceCommandResult(
      intent: intent,
      title: short.length > Validators.maxTitleLength
          ? short.substring(0, Validators.maxTitleLength)
          : short,
      content: content,
      dueAt: null,
      priority: TaskPriority.medium,
      durationMinutes: 60,
    );
  }
}
