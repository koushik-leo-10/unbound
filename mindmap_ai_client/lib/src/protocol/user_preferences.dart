/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class UserPreferences
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  UserPreferences._({
    this.id,
    required this.workingDayStartMinutes,
    required this.workingDayEndMinutes,
    required this.breakMinutes,
    required this.timezone,
    required this.timezoneOffsetMinutes,
  });

  factory UserPreferences({
    int? id,
    required int workingDayStartMinutes,
    required int workingDayEndMinutes,
    required int breakMinutes,
    required String timezone,
    required int timezoneOffsetMinutes,
  }) = _UserPreferencesImpl;

  factory UserPreferences.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserPreferences(
      id: jsonSerialization['id'] as int?,
      workingDayStartMinutes:
          jsonSerialization['workingDayStartMinutes'] as int,
      workingDayEndMinutes: jsonSerialization['workingDayEndMinutes'] as int,
      breakMinutes: jsonSerialization['breakMinutes'] as int,
      timezone: jsonSerialization['timezone'] as String,
      timezoneOffsetMinutes: jsonSerialization['timezoneOffsetMinutes'] as int,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  int workingDayStartMinutes;

  int workingDayEndMinutes;

  int breakMinutes;

  String timezone;

  int timezoneOffsetMinutes;

  /// Returns a shallow copy of this [UserPreferences]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  UserPreferences copyWith({
    int? id,
    int? workingDayStartMinutes,
    int? workingDayEndMinutes,
    int? breakMinutes,
    String? timezone,
    int? timezoneOffsetMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserPreferences',
      if (id != null) 'id': id,
      'workingDayStartMinutes': workingDayStartMinutes,
      'workingDayEndMinutes': workingDayEndMinutes,
      'breakMinutes': breakMinutes,
      'timezone': timezone,
      'timezoneOffsetMinutes': timezoneOffsetMinutes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserPreferences',
      if (id != null) 'id': id,
      'workingDayStartMinutes': workingDayStartMinutes,
      'workingDayEndMinutes': workingDayEndMinutes,
      'breakMinutes': breakMinutes,
      'timezone': timezone,
      'timezoneOffsetMinutes': timezoneOffsetMinutes,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserPreferencesImpl extends UserPreferences {
  _UserPreferencesImpl({
    int? id,
    required int workingDayStartMinutes,
    required int workingDayEndMinutes,
    required int breakMinutes,
    required String timezone,
    required int timezoneOffsetMinutes,
  }) : super._(
         id: id,
         workingDayStartMinutes: workingDayStartMinutes,
         workingDayEndMinutes: workingDayEndMinutes,
         breakMinutes: breakMinutes,
         timezone: timezone,
         timezoneOffsetMinutes: timezoneOffsetMinutes,
       );

  /// Returns a shallow copy of this [UserPreferences]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  UserPreferences copyWith({
    Object? id = _Undefined,
    int? workingDayStartMinutes,
    int? workingDayEndMinutes,
    int? breakMinutes,
    String? timezone,
    int? timezoneOffsetMinutes,
  }) {
    return UserPreferences(
      id: id is int? ? id : this.id,
      workingDayStartMinutes:
          workingDayStartMinutes ?? this.workingDayStartMinutes,
      workingDayEndMinutes: workingDayEndMinutes ?? this.workingDayEndMinutes,
      breakMinutes: breakMinutes ?? this.breakMinutes,
      timezone: timezone ?? this.timezone,
      timezoneOffsetMinutes:
          timezoneOffsetMinutes ?? this.timezoneOffsetMinutes,
    );
  }
}
