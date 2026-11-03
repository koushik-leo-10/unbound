import '../generated/protocol.dart';

/// Builds the facts sent to the LLM and the rule-based fallback message
/// for the "What should I do next?" card.
class SuggestionService {
  /// Human-readable due label in the user's local calendar.
  static String dueLabel(DateTime? due, DateTime now, int offsetMinutes) {
    if (due == null) return 'no deadline';
    if (due.isBefore(now)) {
      final days = now.difference(due).inDays;
      return days == 0 ? 'overdue' : 'overdue by $days day(s)';
    }
    final offset = Duration(minutes: offsetMinutes);
    final dueLocal = due.toUtc().add(offset);
    final nowLocal = now.toUtc().add(offset);
    final days = DateTime.utc(dueLocal.year, dueLocal.month, dueLocal.day)
        .difference(DateTime.utc(nowLocal.year, nowLocal.month, nowLocal.day))
        .inDays;
    return switch (days) {
      0 => 'today',
      1 => 'tomorrow',
      _ => 'in $days days',
    };
  }

  /// One line per task; this is the ONLY data the LLM may use.
  static String facts(Iterable<Task> tasks, DateTime now, int offsetMinutes) {
    return tasks
        .map((t) =>
            '- ${t.title} | priority ${t.priority.name} | due '
            '${dueLabel(t.dueAt, now, offsetMinutes)} | ${t.durationMinutes} min')
        .join('\n');
  }

  /// Deterministic recommendation used when the AI is unavailable.
  static String ruleBased(List<Task> ranked, DateTime now, int offsetMinutes) {
    if (ranked.isEmpty) {
      return 'You are all caught up. Capture a note or add a task to plan your next steps.';
    }
    final overdue = ranked.where((t) => t.dueAt != null && t.dueAt!.isBefore(now)).toList();
    if (overdue.isNotEmpty) {
      final extra = overdue.length > 1 ? ' (${overdue.length} tasks are overdue)' : '';
      return 'Start with "${overdue.first.title}"$extra, then reschedule the rest.';
    }
    final next = ranked.first;
    final label = dueLabel(next.dueAt, now, offsetMinutes);
    final minutes = next.durationMinutes < 45 ? next.durationMinutes : 45;
    if (next.dueAt != null && (label == 'today' || label == 'tomorrow')) {
      return '"${next.title}" is due $label. Spend $minutes minutes on it today.';
    }
    return 'Next up: "${next.title}". A focused 25-minute session today keeps you ahead.';
  }
}
