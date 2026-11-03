import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/preferences_service.dart';

/// Working hours, break length and time zone used by the scheduler.
class PreferencesEndpoint extends Endpoint {
  Future<UserPreferences> getPreferences(Session session) =>
      PreferencesService.load(session);

  Future<UserPreferences> savePreferences(
    Session session,
    int workingDayStartMinutes,
    int workingDayEndMinutes,
    int breakMinutes,
    String timezone,
    int timezoneOffsetMinutes,
  ) async {
    if (workingDayStartMinutes < 0 ||
        workingDayEndMinutes > 24 * 60 ||
        workingDayEndMinutes - workingDayStartMinutes < 60) {
      throw AppException(
          message: 'Working hours must span at least one hour within a single day.');
    }
    if (breakMinutes < 0 || breakMinutes > 120) {
      throw AppException(message: 'Break length must be between 0 and 120 minutes.');
    }
    if (timezoneOffsetMinutes < -12 * 60 || timezoneOffsetMinutes > 14 * 60) {
      throw AppException(message: 'Invalid time zone offset.');
    }
    final prefs = await PreferencesService.load(session);
    prefs.workingDayStartMinutes = workingDayStartMinutes;
    prefs.workingDayEndMinutes = workingDayEndMinutes;
    prefs.breakMinutes = breakMinutes;
    prefs.timezone = timezone.trim().isEmpty ? 'UTC' : timezone.trim();
    prefs.timezoneOffsetMinutes = timezoneOffsetMinutes;
    return UserPreferences.db.updateRow(session, prefs);
  }
}
