import 'package:flutter/material.dart';
import 'package:mindmap_ai_client/mindmap_ai_client.dart';
import '../core/ui_helpers.dart';

/// Values collected by [TaskFormDialog].
typedef NewTask = ({
  String title,
  TaskPriority priority,
  int durationMinutes,
  DateTime? dueAt,
});

class TaskFormDialog extends StatefulWidget {
  const TaskFormDialog({super.key});

  /// Shows the dialog; resolves to null when cancelled.
  static Future<NewTask?> show(BuildContext context) =>
      showDialog<NewTask>(context: context, builder: (_) => const TaskFormDialog());

  @override
  State<TaskFormDialog> createState() => _TaskFormDialogState();
}

class _TaskFormDialogState extends State<TaskFormDialog> {
  static const _durations = [15, 30, 45, 60, 90, 120];

  final _title = TextEditingController();
  TaskPriority _priority = TaskPriority.medium;
  int _duration = 60;
  DateTime? _dueAt;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _submit() {
    final title = _title.text.trim();
    if (title.isEmpty) {
      setState(() => _error = 'Please enter a title.');
      return;
    }
    Navigator.pop<NewTask>(context, (
      title: title,
      priority: _priority,
      durationMinutes: _duration,
      dueAt: _dueAt,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New task'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _title,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(labelText: 'Title', errorText: _error),
            ),
            const SizedBox(height: 16),
            const Text('Priority'),
            const SizedBox(height: 6),
            SegmentedButton<TaskPriority>(
              segments: [
                for (final p in TaskPriority.values)
                  ButtonSegment(value: p, label: Text(priorityLabel(p))),
              ],
              selected: {_priority},
              onSelectionChanged: (s) => setState(() => _priority = s.first),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<int>(
              initialValue: _duration,
              decoration: const InputDecoration(labelText: 'Duration'),
              items: [
                for (final m in _durations)
                  DropdownMenuItem(value: m, child: Text('$m minutes')),
              ],
              onChanged: (v) => setState(() => _duration = v ?? 60),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.event),
              label: Text(_dueAt == null ? 'Set date and time' : formatDue(_dueAt)),
              onPressed: () async {
                final picked = await pickDateTime(context, initial: _dueAt);
                if (picked != null) setState(() => _dueAt = picked);
              },
            ),
            if (_dueAt != null)
              TextButton(
                onPressed: () => setState(() => _dueAt = null),
                child: const Text('Clear deadline'),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: _submit, child: const Text('Add task')),
      ],
    );
  }
}
