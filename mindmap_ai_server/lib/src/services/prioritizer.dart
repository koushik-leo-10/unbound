import '../generated/protocol.dart';

/// Rule-based task prioritisation.
class Prioritizer {
  static int score(Task task, DateTime now) {
    var score = switch (task.priority) {
      TaskPriority.high => 30,
      TaskPriority.medium => 20,
      TaskPriority.low => 10,
    };
    final due = task.dueAt;
    if (due != null) {
      final hours = due.difference(now).inHours;
      if (due.isBefore(now)) {
        score += 100; // overdue always wins
      } else if (hours <= 24) {
        score += 40;
      } else if (hours <= 48) {
        score += 25;
      } else if (hours <= 168) {
        score += 10;
      }
    }
    return score;
  }

  /// Pending tasks, most important first.
  static List<Task> rank(Iterable<Task> tasks, DateTime now) {
    final pending = tasks.where((t) => t.status == TaskStatus.pending).toList();
    pending.sort((a, b) {
      final byScore = score(b, now).compareTo(score(a, now));
      if (byScore != 0) return byScore;
      if (a.dueAt == null && b.dueAt == null) return 0;
      if (a.dueAt == null) return 1;
      if (b.dueAt == null) return -1;
      return a.dueAt!.compareTo(b.dueAt!);
    });
    return pending;
  }
}
