import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindmap_ai_client/mindmap_ai_client.dart';

/// Converts any error into a message that is safe to show to the user.
String friendlyError(Object error) {
  if (error is AppException) return error.message;
  if (error is FormatException) return error.message;
  return 'Something went wrong. Check your connection and try again.';
}

void showMessage(BuildContext context, String text) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(text)));
}

String formatDue(DateTime? due) =>
    due == null ? 'No deadline' : DateFormat('EEE d MMM, h:mm a').format(due.toLocal());

String formatSlot(DateTime start, DateTime end) {
  final day = DateFormat('EEEE d MMM').format(start.toLocal());
  final from = DateFormat('h:mm a').format(start.toLocal());
  final to = DateFormat('h:mm a').format(end.toLocal());
  return '$day, $from - $to';
}

String priorityLabel(TaskPriority priority) => switch (priority) {
      TaskPriority.high => 'High',
      TaskPriority.medium => 'Medium',
      TaskPriority.low => 'Low',
    };

Color priorityColor(TaskPriority priority) => switch (priority) {
      TaskPriority.high => Colors.red.shade400,
      TaskPriority.medium => Colors.orange.shade400,
      TaskPriority.low => Colors.green.shade400,
    };

bool isOverdue(Task task) =>
    task.status == TaskStatus.pending &&
    task.dueAt != null &&
    task.dueAt!.isBefore(DateTime.now());

/// Date picker followed by a time picker. Returns null if cancelled.
Future<DateTime?> pickDateTime(BuildContext context, {DateTime? initial}) async {
  final base = (initial ?? DateTime.now().add(const Duration(hours: 1))).toLocal();
  final date = await showDatePicker(
    context: context,
    initialDate: base,
    firstDate: DateTime.now().subtract(const Duration(days: 365)),
    lastDate: DateTime.now().add(const Duration(days: 365 * 3)),
  );
  if (date == null || !context.mounted) return null;
  final time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(base),
  );
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}
