import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class PreferencesService {
  static const int defaultStartMinutes = 9 * 60;
  static const int defaultEndMinutes = 18 * 60;
  static const int defaultBreakMinutes = 10;

  /// Returns the demo user's preferences, creating defaults on first access.
  static Future<UserPreferences> load(Session session) async {
    final existing = await UserPreferences.db.find(session, limit: 1);
    if (existing.isNotEmpty) return existing.first;
    return UserPreferences.db.insertRow(
      session,
      UserPreferences(
        workingDayStartMinutes: defaultStartMinutes,
        workingDayEndMinutes: defaultEndMinutes,
        breakMinutes: defaultBreakMinutes,
        timezone: 'UTC',
        timezoneOffsetMinutes: 0,
      ),
    );
  }
}
