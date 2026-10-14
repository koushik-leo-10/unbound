import 'package:flutter/material.dart';
import 'package:mindmap_ai_client/mindmap_ai_client.dart';
import '../core/api.dart';
import '../core/ui_helpers.dart';
import '../widgets/state_views.dart';
import '../widgets/task_form_dialog.dart';
import '../widgets/workspace_header.dart';

/// Screen 3 - Tasks: pending/completed, complete action, deadline, rescheduling.
class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  bool _loading = true;
  String? _error;
  List<Task> _tasks = [];
  TaskStatus _filter = TaskStatus.pending;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final tasks = await client.tasks.getTasks(status: _filter);
      if (mounted) setState(() => _tasks = tasks);
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  /// Runs a server call, then refreshes; errors become snack bars.
  Future<void> _guard(Future<void> Function() action) async {
    try {
      await action();
      await _load();
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    }
  }

  Future<void> _create() async {
    final form = await TaskFormDialog.show(context);
    if (form == null) return;
    await _guard(() => client.tasks.createTask(
          form.title,
          form.priority,
          form.durationMinutes,
          dueAt: form.dueAt,
        ));
  }

  Future<void> _toggle(Task task) => _guard(() => client.tasks.updateTask(
        task.id!,
        status: task.status == TaskStatus.pending ? TaskStatus.completed : TaskStatus.pending,
      ));

  Future<void> _changeDeadline(Task task) async {
    final picked = await pickDateTime(context, initial: task.dueAt);
    if (picked == null) return;
    await _guard(() => client.tasks.updateTask(task.id!, dueAt: picked));
  }

  /// Step 1: ask the server for a conflict-checked slot. Step 2: user accepts.
  Future<void> _suggestReschedule(Task task) async {
    try {
      final proposal = await client.tasks.suggestReschedule(task.id!);
      if (!mounted) return;
      if (proposal == null) {
        showMessage(context, 'No free slot in the next 14 days. Try widening your working hours.');
        return;
      }
      final accepted = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Suggested new time'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(task.title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 12),
              Text('Missed: ${formatDue(task.dueAt)}'),
              const SizedBox(height: 4),
              Text('Suggested: ${formatSlot(proposal.proposedStart, proposal.proposedEnd)}'),
              const SizedBox(height: 12),
              Text(
                'Checked against your working hours and the other tasks saved in '
                'Unbound. It does not read your external calendar.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Reject')),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Accept')),
          ],
        ),
      );
      if (accepted != true) return;
      await _guard(() => client.tasks.rescheduleTask(task.id!, proposal.proposedStart));
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WorkspaceHeader(
        title: 'Tasks & schedule',
        subtitle: 'Plan a day that feels doable',
        icon: Icons.task_alt_rounded,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _create,
        icon: const Icon(Icons.add),
        label: const Text('New task'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1040),
          child: Column(
            children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: SegmentedButton<TaskStatus>(
              segments: const [
                ButtonSegment(
                    value: TaskStatus.pending,
                    label: Text('Pending'),
                    icon: Icon(Icons.pending_actions)),
                ButtonSegment(
                    value: TaskStatus.completed,
                    label: Text('Completed'),
                    icon: Icon(Icons.task_alt)),
              ],
              selected: {_filter},
              onSelectionChanged: (s) {
                setState(() => _filter = s.first);
                _load();
              },
            ),
          ),
          Expanded(
            child: _loading
                ? const LoadingView()
                : _error != null
                    ? ErrorView(message: _error!, onRetry: _load)
                    : _tasks.isEmpty
                        ? EmptyView(
                            icon: Icons.checklist,
                            message: _filter == TaskStatus.pending
                                ? 'No pending tasks.'
                                : 'No completed tasks yet.',
                          )
                        : RefreshIndicator(
                            onRefresh: _load,
                            child: ListView.builder(
                              padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
                              itemCount: _tasks.length,
                              itemBuilder: (context, i) => _tile(_tasks[i]),
                            ),
                          ),
          ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _tile(Task task) {
    final overdue = isOverdue(task);
    final scheme = Theme.of(context).colorScheme;
    final done = task.status == TaskStatus.completed;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Column(
        children: [
          ListTile(
            leading: Checkbox(value: done, onChanged: (_) => _toggle(task)),
            title: Text(
              task.title,
              style: TextStyle(decoration: done ? TextDecoration.lineThrough : null),
            ),
            subtitle: Wrap(
              spacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(formatDue(task.dueAt),
                    style: TextStyle(color: overdue ? scheme.error : null)),
                Chip(
                  label: Text(priorityLabel(task.priority)),
                  visualDensity: VisualDensity.compact,
                  side: BorderSide(color: priorityColor(task.priority)),
                ),
                Text('${task.durationMinutes} min'),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'deadline') _changeDeadline(task);
                if (value == 'delete') _guard(() => client.tasks.deleteTask(task.id!));
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'deadline', child: Text('Change deadline')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ),
          if (overdue)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.tonalIcon(
                  icon: const Icon(Icons.event_repeat),
                  label: const Text('Suggest new time'),
                  onPressed: () => _suggestReschedule(task),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
