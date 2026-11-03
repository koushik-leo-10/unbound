import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/preferences_service.dart';
import '../services/prioritizer.dart';
import '../services/scheduler.dart';
import '../services/validators.dart';

/// tasks.createTask / getTasks / updateTask / deleteTask / rescheduleTask ...
class TasksEndpoint extends Endpoint {
  Future<Task> createTask(
    Session session,
    String title,
    TaskPriority priority,
    int durationMinutes, {
    DateTime? dueAt,
    int? sourceNoteId,
  }) async {
    final cleanTitle =
        Validators.requireText(title, field: 'Title', max: Validators.maxTitleLength);
    final cleanDue = Validators.dueDate(dueAt);

    if (sourceNoteId != null && await Note.db.findById(session, sourceNoteId) == null) {
      throw AppException(message: 'The source note no longer exists.');
    }

    // Duplicate-submission guard: same title and time while still pending.
    final pending = await _pending(session);
    final duplicate = pending
        .where((t) =>
            t.title.toLowerCase() == cleanTitle.toLowerCase() &&
            _sameInstant(t.dueAt, cleanDue))
        .firstOrNull;
    if (duplicate != null) return duplicate;

    return Task.db.insertRow(
      session,
      Task(
        title: cleanTitle,
        dueAt: cleanDue,
        durationMinutes: Validators.duration(durationMinutes),
        priority: priority,
        status: TaskStatus.pending,
        sourceNoteId: sourceNoteId,
        createdAt: DateTime.now().toUtc(),
      ),
    );
  }

  /// All tasks, or only those with [status]. Soonest deadline first.
  Future<List<Task>> getTasks(Session session, {TaskStatus? status}) async {
    final tasks = status == null
        ? await Task.db.find(session)
        : await Task.db.find(session, where: (t) => t.status.equals(status));
    return _sortByDue(tasks);
  }

  Future<List<Task>> getOverdueTasks(Session session) async {
    final pending = await _pending(session);
    return Scheduler.overdueTasks(pending, DateTime.now().toUtc());
  }

  /// Rule-based ranking of pending tasks (overdue and urgent first).
  Future<List<Task>> getPrioritizedTasks(Session session, {int limit = 5}) async {
    final pending = await _pending(session);
    return Prioritizer.rank(pending, DateTime.now().toUtc())
        .take(limit.clamp(1, 20).toInt())
        .toList();
  }

  Future<Task> updateTask(
    Session session,
    int id, {
    String? title,
    DateTime? dueAt,
    bool? clearDueAt,
    TaskPriority? priority,
    TaskStatus? status,
    int? durationMinutes,
  }) async {
    final task = await _require(session, id);
    if (title != null) {
      task.title = Validators.requireText(title, field: 'Title', max: Validators.maxTitleLength);
    }
    if (clearDueAt == true) {
      task.dueAt = null;
    } else if (dueAt != null) {
      task.dueAt = Validators.dueDate(dueAt);
    }
    if (priority != null) task.priority = priority;
    if (status != null) task.status = status;
    if (durationMinutes != null) task.durationMinutes = Validators.duration(durationMinutes);
    return Task.db.updateRow(session, task);
  }

  Future<void> deleteTask(Session session, int id) async {
    await Task.db.deleteWhere(session, where: (t) => t.id.equals(id));
  }

  /// Step 1 of rescheduling: PROPOSE a slot. Nothing is saved.
  /// Returns null when no free slot exists in the next two weeks.
  Future<RescheduleProposal?> suggestReschedule(Session session, int taskId) async {
    final task = await _requirePending(session, taskId);
    final prefs = await PreferencesService.load(session);
    final pending = await _pending(session);
    final slot = Scheduler.findNextSlot(
      task: task,
      existing: pending,
      prefs: prefs,
      now: DateTime.now().toUtc(),
    );
    if (slot == null) return null;
    return RescheduleProposal(
      task: task,
      proposedStart: slot.start,
      proposedEnd: slot.end,
    );
  }

  /// Step 2: the user accepted. The server re-checks everything before saving.
  Future<Task> rescheduleTask(Session session, int taskId, DateTime newStart) async {
    final task = await _requirePending(session, taskId);
    final start = newStart.toUtc();
    final now = DateTime.now().toUtc();
    if (start.isBefore(now)) {
      throw AppException(message: 'The new time must be in the future.');
    }
    final prefs = await PreferencesService.load(session);
    if (!Scheduler.isWithinWorkingHours(
      start: start,
      durationMinutes: task.durationMinutes,
      prefs: prefs,
    )) {
      throw AppException(message: 'That time is outside your working hours.');
    }
    final active = Scheduler.activeScheduled(await _pending(session), now);
    if (Scheduler.hasConflict(
      start: start,
      durationMinutes: task.durationMinutes,
      existing: active,
      excludeTaskId: task.id,
      breakMinutes: prefs.breakMinutes,
    )) {
      throw AppException(message: 'That time overlaps another task.');
    }
    task.dueAt = start;
    return Task.db.updateRow(session, task);
  }

  // ---- helpers -----------------------------------------------------------

  Future<List<Task>> _pending(Session session) =>
      Task.db.find(session, where: (t) => t.status.equals(TaskStatus.pending));

  Future<Task> _require(Session session, int id) async {
    final task = await Task.db.findById(session, id);
    if (task == null) throw AppException(message: 'Task not found.');
    return task;
  }

  Future<Task> _requirePending(Session session, int id) async {
    final task = await _require(session, id);
    if (task.status != TaskStatus.pending) {
      throw AppException(message: 'Only pending tasks can be rescheduled.');
    }
    return task;
  }

  static bool _sameInstant(DateTime? a, DateTime? b) {
    if (a == null || b == null) return a == null && b == null;
    return a.isAtSameMomentAs(b);
  }

  static List<Task> _sortByDue(List<Task> tasks) {
    return tasks
      ..sort((a, b) {
        if (a.dueAt == null && b.dueAt == null) return 0;
        if (a.dueAt == null) return 1; // no deadline goes last
        if (b.dueAt == null) return -1;
        return a.dueAt!.compareTo(b.dueAt!);
      });
  }
}
