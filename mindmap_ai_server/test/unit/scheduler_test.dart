import 'package:mindmap_ai_server/src/generated/protocol.dart';
import 'package:mindmap_ai_server/src/services/scheduler.dart';
import 'package:test/test.dart';

UserPreferences prefs({int breakMinutes = 0, int offset = 0}) => UserPreferences(
      workingDayStartMinutes: 9 * 60,
      workingDayEndMinutes: 18 * 60,
      breakMinutes: breakMinutes,
      timezone: 'UTC',
      timezoneOffsetMinutes: offset,
    );

Task task({int? id, DateTime? at, int minutes = 60, TaskStatus status = TaskStatus.pending}) =>
    Task(
      id: id,
      title: 'Task $id',
      dueAt: at,
      durationMinutes: minutes,
      priority: TaskPriority.medium,
      status: status,
      createdAt: DateTime.utc(2026, 10, 1),
    );

void main() {
  // Sunday 11 Oct 2026, 17:30 UTC.
  final now = DateTime.utc(2026, 10, 11, 17, 30);

  group('overdue detection', () {
    test('only pending tasks in the past are overdue', () {
      final overdue = task(id: 1, at: DateTime.utc(2026, 10, 11, 16));
      final future = task(id: 2, at: DateTime.utc(2026, 10, 12, 10));
      final done = task(id: 3, at: DateTime.utc(2026, 10, 11, 9), status: TaskStatus.completed);
      final noDate = task(id: 4);
      final result = Scheduler.overdueTasks([overdue, future, done, noDate], now);
      expect(result.map((t) => t.id), [1]);
    });
  });

  group('findNextSlot', () {
    final missed = task(id: 1, at: DateTime.utc(2026, 10, 11, 16));

    test('moves to the next working morning when today has no room', () {
      final slot = Scheduler.findNextSlot(
          task: missed, existing: [missed], prefs: prefs(), now: now);
      expect(slot!.start, DateTime.utc(2026, 10, 12, 9));
      expect(slot.end, DateTime.utc(2026, 10, 12, 10));
    });

    test('skips an occupied slot', () {
      final busy = task(id: 2, at: DateTime.utc(2026, 10, 12, 9));
      final slot = Scheduler.findNextSlot(
          task: missed, existing: [missed, busy], prefs: prefs(), now: now);
      expect(slot!.start, DateTime.utc(2026, 10, 12, 10));
    });

    test('keeps the configured break after another task', () {
      final busy = task(id: 2, at: DateTime.utc(2026, 10, 12, 9));
      final slot = Scheduler.findNextSlot(
          task: missed, existing: [missed, busy], prefs: prefs(breakMinutes: 15), now: now);
      expect(slot!.start, DateTime.utc(2026, 10, 12, 10, 15));
    });

    test('respects the user time zone (IST, UTC+5:30)', () {
      final slot = Scheduler.findNextSlot(
          task: missed, existing: [missed], prefs: prefs(offset: 330), now: now);
      expect(slot!.start, DateTime.utc(2026, 10, 12, 3, 30));
    });

    test('returns null when the task can never fit', () {
      final tooLong = task(id: 5, minutes: 600);
      final slot = Scheduler.findNextSlot(
          task: tooLong, existing: [tooLong], prefs: prefs(), now: now);
      expect(slot, isNull);
    });
  });

  group('conflict and working-hour checks', () {
    final existing = [task(id: 2, at: DateTime.utc(2026, 10, 12, 10))];

    test('detects overlap', () {
      expect(
          Scheduler.hasConflict(
              start: DateTime.utc(2026, 10, 12, 10, 30), durationMinutes: 60, existing: existing),
          isTrue);
    });

    test('allows back-to-back tasks without a break', () {
      expect(
          Scheduler.hasConflict(
              start: DateTime.utc(2026, 10, 12, 11), durationMinutes: 60, existing: existing),
          isFalse);
    });

    test('rejects times outside working hours', () {
      expect(
          Scheduler.isWithinWorkingHours(
              start: DateTime.utc(2026, 10, 12, 17, 30), durationMinutes: 60, prefs: prefs()),
          isFalse);
      expect(
          Scheduler.isWithinWorkingHours(
              start: DateTime.utc(2026, 10, 12, 9), durationMinutes: 60, prefs: prefs()),
          isTrue);
    });
  });
}
