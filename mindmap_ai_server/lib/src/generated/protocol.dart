/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:mindmap_ai_server/src/generated/mind_map.dart' as _ib61u1pn;
import 'package:mindmap_ai_server/src/generated/note.dart' as _ikylulqd;
import 'package:mindmap_ai_server/src/generated/task.dart' as _io5q2kse;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import 'app_exception.dart' as _it4z223c;
import 'auth_response.dart' as _iuyz7l8a;
import 'daily_suggestion.dart' as _icdtdyaa;
import 'dashboard_stats.dart' as _iao0krc3;
import 'mind_map.dart' as _iwg2iq0b;
import 'note.dart' as _io8vvye9;
import 'reschedule_proposal.dart' as _i2jid892;
import 'suggested_task.dart' as _iax64zjc;
import 'summary_result.dart' as _igak1row;
import 'task.dart' as _iwn6t6fs;
import 'task_priority.dart' as _ifg2vma4;
import 'task_status.dart' as _ic097rko;
import 'user_account.dart' as _i4om8q6j;
import 'user_preferences.dart' as _irrugw8b;
import 'voice_command_result.dart' as _i8agdwny;
import 'voice_intent.dart' as _icipe65l;
export 'app_exception.dart';
export 'auth_response.dart';
export 'daily_suggestion.dart';
export 'dashboard_stats.dart';
export 'mind_map.dart';
export 'note.dart';
export 'reschedule_proposal.dart';
export 'suggested_task.dart';
export 'summary_result.dart';
export 'task.dart';
export 'task_priority.dart';
export 'task_status.dart';
export 'user_account.dart';
export 'user_preferences.dart';
export 'voice_command_result.dart';
export 'voice_intent.dart';

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'mind_map',
      dartName: 'MindMap',
      schema: 'public',
      module: 'mindmap_ai',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'rootNodeJson',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'sourceNoteId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'userId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'note',
      dartName: 'Note',
      schema: 'public',
      module: 'mindmap_ai',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'content',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'summary',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'task',
      dartName: 'Task',
      schema: 'public',
      module: 'mindmap_ai',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'dueAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'durationMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'priority',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TaskPriority',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TaskStatus',
        ),
        _isp.ColumnDefinition(
          name: 'sourceNoteId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'user_account',
      dartName: 'UserAccount',
      schema: 'public',
      module: 'mindmap_ai',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'passwordHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'salt',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'avatarUrl',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'lastLoginAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'user_account_email_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'user_preferences',
      dartName: 'UserPreferences',
      schema: 'public',
      module: 'mindmap_ai',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'workingDayStartMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'workingDayEndMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'breakMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'timezone',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'timezoneOffsetMinutes',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _it4z223c.AppException) {
      return _it4z223c.AppException.fromJson(data) as T;
    }
    if (t == _iuyz7l8a.AuthResponse) {
      return _iuyz7l8a.AuthResponse.fromJson(data) as T;
    }
    if (t == _icdtdyaa.DailySuggestion) {
      return _icdtdyaa.DailySuggestion.fromJson(data) as T;
    }
    if (t == _iao0krc3.DashboardStats) {
      return _iao0krc3.DashboardStats.fromJson(data) as T;
    }
    if (t == _iwg2iq0b.MindMap) {
      return _iwg2iq0b.MindMap.fromJson(data) as T;
    }
    if (t == _io8vvye9.Note) {
      return _io8vvye9.Note.fromJson(data) as T;
    }
    if (t == _i2jid892.RescheduleProposal) {
      return _i2jid892.RescheduleProposal.fromJson(data) as T;
    }
    if (t == _iax64zjc.SuggestedTask) {
      return _iax64zjc.SuggestedTask.fromJson(data) as T;
    }
    if (t == _igak1row.SummaryResult) {
      return _igak1row.SummaryResult.fromJson(data) as T;
    }
    if (t == _iwn6t6fs.Task) {
      return _iwn6t6fs.Task.fromJson(data) as T;
    }
    if (t == _ifg2vma4.TaskPriority) {
      return _ifg2vma4.TaskPriority.fromJson(data) as T;
    }
    if (t == _ic097rko.TaskStatus) {
      return _ic097rko.TaskStatus.fromJson(data) as T;
    }
    if (t == _i4om8q6j.UserAccount) {
      return _i4om8q6j.UserAccount.fromJson(data) as T;
    }
    if (t == _irrugw8b.UserPreferences) {
      return _irrugw8b.UserPreferences.fromJson(data) as T;
    }
    if (t == _i8agdwny.VoiceCommandResult) {
      return _i8agdwny.VoiceCommandResult.fromJson(data) as T;
    }
    if (t == _icipe65l.VoiceIntent) {
      return _icipe65l.VoiceIntent.fromJson(data) as T;
    }
    if (t == _is.getType<_it4z223c.AppException?>()) {
      return (data != null ? _it4z223c.AppException.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iuyz7l8a.AuthResponse?>()) {
      return (data != null ? _iuyz7l8a.AuthResponse.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_icdtdyaa.DailySuggestion?>()) {
      return (data != null ? _icdtdyaa.DailySuggestion.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iao0krc3.DashboardStats?>()) {
      return (data != null ? _iao0krc3.DashboardStats.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iwg2iq0b.MindMap?>()) {
      return (data != null ? _iwg2iq0b.MindMap.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_io8vvye9.Note?>()) {
      return (data != null ? _io8vvye9.Note.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2jid892.RescheduleProposal?>()) {
      return (data != null ? _i2jid892.RescheduleProposal.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iax64zjc.SuggestedTask?>()) {
      return (data != null ? _iax64zjc.SuggestedTask.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igak1row.SummaryResult?>()) {
      return (data != null ? _igak1row.SummaryResult.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iwn6t6fs.Task?>()) {
      return (data != null ? _iwn6t6fs.Task.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ifg2vma4.TaskPriority?>()) {
      return (data != null ? _ifg2vma4.TaskPriority.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ic097rko.TaskStatus?>()) {
      return (data != null ? _ic097rko.TaskStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4om8q6j.UserAccount?>()) {
      return (data != null ? _i4om8q6j.UserAccount.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_irrugw8b.UserPreferences?>()) {
      return (data != null ? _irrugw8b.UserPreferences.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i8agdwny.VoiceCommandResult?>()) {
      return (data != null ? _i8agdwny.VoiceCommandResult.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_icipe65l.VoiceIntent?>()) {
      return (data != null ? _icipe65l.VoiceIntent.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_iax64zjc.SuggestedTask>) {
      return (data as List)
              .map((e) => deserialize<_iax64zjc.SuggestedTask>(e))
              .toList()
          as T;
    }
    if (t == List<_ib61u1pn.MindMap>) {
      return (data as List)
              .map((e) => deserialize<_ib61u1pn.MindMap>(e))
              .toList()
          as T;
    }
    if (t == List<_ikylulqd.Note>) {
      return (data as List).map((e) => deserialize<_ikylulqd.Note>(e)).toList()
          as T;
    }
    if (t == List<_io5q2kse.Task>) {
      return (data as List).map((e) => deserialize<_io5q2kse.Task>(e)).toList()
          as T;
    }
    try {
      return _iais.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _it4z223c.AppException => 'AppException',
      _iuyz7l8a.AuthResponse => 'AuthResponse',
      _icdtdyaa.DailySuggestion => 'DailySuggestion',
      _iao0krc3.DashboardStats => 'DashboardStats',
      _iwg2iq0b.MindMap => 'MindMap',
      _io8vvye9.Note => 'Note',
      _i2jid892.RescheduleProposal => 'RescheduleProposal',
      _iax64zjc.SuggestedTask => 'SuggestedTask',
      _igak1row.SummaryResult => 'SummaryResult',
      _iwn6t6fs.Task => 'Task',
      _ifg2vma4.TaskPriority => 'TaskPriority',
      _ic097rko.TaskStatus => 'TaskStatus',
      _i4om8q6j.UserAccount => 'UserAccount',
      _irrugw8b.UserPreferences => 'UserPreferences',
      _i8agdwny.VoiceCommandResult => 'VoiceCommandResult',
      _icipe65l.VoiceIntent => 'VoiceIntent',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('mindmap_ai.', '');
    }

    switch (data) {
      case _it4z223c.AppException():
        return 'AppException';
      case _iuyz7l8a.AuthResponse():
        return 'AuthResponse';
      case _icdtdyaa.DailySuggestion():
        return 'DailySuggestion';
      case _iao0krc3.DashboardStats():
        return 'DashboardStats';
      case _iwg2iq0b.MindMap():
        return 'MindMap';
      case _io8vvye9.Note():
        return 'Note';
      case _i2jid892.RescheduleProposal():
        return 'RescheduleProposal';
      case _iax64zjc.SuggestedTask():
        return 'SuggestedTask';
      case _igak1row.SummaryResult():
        return 'SummaryResult';
      case _iwn6t6fs.Task():
        return 'Task';
      case _ifg2vma4.TaskPriority():
        return 'TaskPriority';
      case _ic097rko.TaskStatus():
        return 'TaskStatus';
      case _i4om8q6j.UserAccount():
        return 'UserAccount';
      case _irrugw8b.UserPreferences():
        return 'UserPreferences';
      case _i8agdwny.VoiceCommandResult():
        return 'VoiceCommandResult';
      case _icipe65l.VoiceIntent():
        return 'VoiceIntent';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AppException') {
      return deserialize<_it4z223c.AppException>(data['data']);
    }
    if (dataClassName == 'AuthResponse') {
      return deserialize<_iuyz7l8a.AuthResponse>(data['data']);
    }
    if (dataClassName == 'DailySuggestion') {
      return deserialize<_icdtdyaa.DailySuggestion>(data['data']);
    }
    if (dataClassName == 'DashboardStats') {
      return deserialize<_iao0krc3.DashboardStats>(data['data']);
    }
    if (dataClassName == 'MindMap') {
      return deserialize<_iwg2iq0b.MindMap>(data['data']);
    }
    if (dataClassName == 'Note') {
      return deserialize<_io8vvye9.Note>(data['data']);
    }
    if (dataClassName == 'RescheduleProposal') {
      return deserialize<_i2jid892.RescheduleProposal>(data['data']);
    }
    if (dataClassName == 'SuggestedTask') {
      return deserialize<_iax64zjc.SuggestedTask>(data['data']);
    }
    if (dataClassName == 'SummaryResult') {
      return deserialize<_igak1row.SummaryResult>(data['data']);
    }
    if (dataClassName == 'Task') {
      return deserialize<_iwn6t6fs.Task>(data['data']);
    }
    if (dataClassName == 'TaskPriority') {
      return deserialize<_ifg2vma4.TaskPriority>(data['data']);
    }
    if (dataClassName == 'TaskStatus') {
      return deserialize<_ic097rko.TaskStatus>(data['data']);
    }
    if (dataClassName == 'UserAccount') {
      return deserialize<_i4om8q6j.UserAccount>(data['data']);
    }
    if (dataClassName == 'UserPreferences') {
      return deserialize<_irrugw8b.UserPreferences>(data['data']);
    }
    if (dataClassName == 'VoiceCommandResult') {
      return deserialize<_i8agdwny.VoiceCommandResult>(data['data']);
    }
    if (dataClassName == 'VoiceIntent') {
      return deserialize<_icipe65l.VoiceIntent>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iais.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacs.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('mindmap_ai', this);
    _iacs.Protocol().registerHostProtocol('mindmap_ai', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _iwg2iq0b.MindMap:
        return _iwg2iq0b.MindMap.t;
      case _io8vvye9.Note:
        return _io8vvye9.Note.t;
      case _iwn6t6fs.Task:
        return _iwn6t6fs.Task.t;
      case _i4om8q6j.UserAccount:
        return _i4om8q6j.UserAccount.t;
      case _irrugw8b.UserPreferences:
        return _irrugw8b.UserPreferences.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'mindmap_ai';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
