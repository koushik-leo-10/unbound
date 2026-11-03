import '../generated/protocol.dart';

/// Input validation shared by all endpoints.
class Validators {
  static const int maxTitleLength = 200;
  static const int maxTextLength = 30000;

  /// Trims [value] and ensures it is not empty or longer than [max].
  static String requireText(String? value, {required String field, int max = maxTextLength}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      throw AppException(message: '$field cannot be empty.');
    }
    if (text.length > max) {
      throw AppException(message: '$field is too long (maximum $max characters).');
    }
    return text;
  }

  /// Keeps a task duration between 5 minutes and 8 hours.
  static int duration(int minutes) => minutes.clamp(5, 480).toInt();

  /// Normalises a due date to UTC and rejects absurd values.
  static DateTime? dueDate(DateTime? value) {
    if (value == null) return null;
    final utc = value.toUtc();
    if (!isReasonableDate(utc)) {
      throw AppException(message: 'That date is not valid.');
    }
    return utc;
  }

  /// Accepts dates from one year ago up to five years ahead.
  static bool isReasonableDate(DateTime date) {
    final now = DateTime.now().toUtc();
    return date.isAfter(now.subtract(const Duration(days: 365))) &&
        date.isBefore(now.add(const Duration(days: 365 * 5)));
  }
}
