import '../generated/protocol.dart';

/// A free period proposed by the scheduler (both values are UTC).
class TimeSlot {
  const TimeSlot(this.start, this.end);
  final DateTime start;
  final DateTime end;
}

class _Interval {
  const _Interval(this.start, this.end);
  final DateTime start;
  final DateTime end;
}

/// Transparent, rule-based scheduler. No machine learning, no AI.
/// It only knows about tasks stored in Unbound - not an external calendar.
class Scheduler {
  static const Duration _step = Duration(minutes: 15);

  /// A pending task whose scheduled time has passed.
  static bool isOverdue(Task task, DateTime now) =>
      task.status == TaskStatus.pending &&
      task.dueAt != null &&
      task.dueAt!.isBefore(now);

  /// Overdue tasks, oldest first.
  static List<Task> overdueTasks(Iterable<Task> tasks, DateTime now) {
    final overdue = tasks.where((t) => isOverdue(t, now)).toList()
      ..sort((a, b) => a.dueAt!.compareTo(b.dueAt!));
    return overdue;
  }

  /// Pending tasks that currently occupy time in the future.
  static List<Task> activeScheduled(Iterable<Task> tasks, DateTime now) => tasks
      .where((t) =>
          t.status == TaskStatus.pending &&
          t.dueAt != null &&
          !t.dueAt!.isBefore(now))
      .toList();

  /// Finds the earliest slot inside working hours, not before [now],
  /// not overlapping another task. Returns null when nothing fits.
  static TimeSlot? findNextSlot({
    required Task task,
    required Iterable<Task> existing,
    required UserPreferences prefs,
    required DateTime now,
    int searchDays = 14,
  }) {
    final offset = Duration(minutes: prefs.timezoneOffsetMinutes);
    final duration = Duration(minutes: task.durationMinutes);
    final breakPad = Duration(minutes: prefs.breakMinutes);
    final nowUtc = now.toUtc();

    // All calculations use "local wall-clock time" stored in UTC DateTimes.
    final nowLocal = _ceil(nowUtc.add(offset));

    final busy = activeScheduled(existing, nowUtc)
        .where((t) => t.id != task.id)
        .map((t) {
          final start = t.dueAt!.toUtc().add(offset);
          final end = start.add(Duration(minutes: t.durationMinutes));
          return _Interval(start.subtract(breakPad), end.add(breakPad));
        })
        .toList()
      ..sort((a, b) => a.start.compareTo(b.start));

    for (var day = 0; day < searchDays; day++) {
      final midnight =
          DateTime.utc(nowLocal.year, nowLocal.month, nowLocal.day + day);
      final dayStart =
          midnight.add(Duration(minutes: prefs.workingDayStartMinutes));
      final dayEnd = midnight.add(Duration(minutes: prefs.workingDayEndMinutes));

      var cursor = dayStart.isBefore(nowLocal) ? nowLocal : dayStart;

      for (final block in busy) {
        if (!block.end.isAfter(cursor)) continue; // already in the past
        final candidateEnd = cursor.add(duration);
        if (!candidateEnd.isAfter(block.start) && !candidateEnd.isAfter(dayEnd)) {
          return _slot(cursor, duration, offset);
        }
        if (block.start.isAfter(dayEnd)) break; // nothing else matters today
        cursor = _ceil(block.end);
      }

      if (!cursor.add(duration).isAfter(dayEnd)) {
        return _slot(cursor, duration, offset);
      }
    }
    return null;
  }

  /// True when the proposed period overlaps another pending task.
  static bool hasConflict({
    required DateTime start,
    required int durationMinutes,
    required Iterable<Task> existing,
    int? excludeTaskId,
    int breakMinutes = 0,
  }) {
    final pad = Duration(minutes: breakMinutes);
    final newStart = start.toUtc();
    final newEnd = newStart.add(Duration(minutes: durationMinutes));

    for (final other in existing) {
      if (other.id == excludeTaskId ||
          other.status != TaskStatus.pending ||
          other.dueAt == null) {
        continue;
      }
      final otherStart = other.dueAt!.toUtc().subtract(pad);
      final otherEnd = other.dueAt!
          .toUtc()
          .add(Duration(minutes: other.durationMinutes))
          .add(pad);
      if (newStart.isBefore(otherEnd) && newEnd.isAfter(otherStart)) return true;
    }
    return false;
  }

  /// True when the whole period lies inside one day's working hours.
  static bool isWithinWorkingHours({
    required DateTime start,
    required int durationMinutes,
    required UserPreferences prefs,
  }) {
    final local = start.toUtc().add(Duration(minutes: prefs.timezoneOffsetMinutes));
    final startMinute = local.hour * 60 + local.minute;
    return startMinute >= prefs.workingDayStartMinutes &&
        startMinute + durationMinutes <= prefs.workingDayEndMinutes;
  }

  static TimeSlot _slot(DateTime localStart, Duration duration, Duration offset) {
    final start = localStart.subtract(offset);
    return TimeSlot(start, start.add(duration));
  }

  /// Rounds up to the next 15-minute boundary.
  static DateTime _ceil(DateTime time) {
    final stepMs = _step.inMilliseconds;
    final remainder = time.millisecondsSinceEpoch % stepMs;
    return remainder == 0 ? time : time.add(Duration(milliseconds: stepMs - remainder));
  }
}
