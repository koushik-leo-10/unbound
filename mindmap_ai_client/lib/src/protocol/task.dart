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
import 'task_priority.dart' as _ifg2vma4;
import 'task_status.dart' as _ic097rko;

abstract class Task
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Task._({
    this.id,
    required this.title,
    this.dueAt,
    required this.durationMinutes,
    required this.priority,
    required this.status,
    this.sourceNoteId,
    required this.createdAt,
  });

  factory Task({
    int? id,
    required String title,
    DateTime? dueAt,
    required int durationMinutes,
    required _ifg2vma4.TaskPriority priority,
    required _ic097rko.TaskStatus status,
    int? sourceNoteId,
    required DateTime createdAt,
  }) = _TaskImpl;

  factory Task.fromJson(Map<String, dynamic> jsonSerialization) {
    return Task(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      dueAt: jsonSerialization['dueAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      durationMinutes: jsonSerialization['durationMinutes'] as int,
      priority: _ifg2vma4.TaskPriority.fromJson(
        (jsonSerialization['priority'] as String),
      ),
      status: _ic097rko.TaskStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      sourceNoteId: jsonSerialization['sourceNoteId'] as int?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  DateTime? dueAt;

  int durationMinutes;

  _ifg2vma4.TaskPriority priority;

  _ic097rko.TaskStatus status;

  int? sourceNoteId;

  DateTime createdAt;

  /// Returns a shallow copy of this [Task]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Task copyWith({
    int? id,
    String? title,
    DateTime? dueAt,
    int? durationMinutes,
    _ifg2vma4.TaskPriority? priority,
    _ic097rko.TaskStatus? status,
    int? sourceNoteId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Task',
      if (id != null) 'id': id,
      'title': title,
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      'durationMinutes': durationMinutes,
      'priority': priority.toJson(),
      'status': status.toJson(),
      if (sourceNoteId != null) 'sourceNoteId': sourceNoteId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Task',
      if (id != null) 'id': id,
      'title': title,
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      'durationMinutes': durationMinutes,
      'priority': priority.toJson(),
      'status': status.toJson(),
      if (sourceNoteId != null) 'sourceNoteId': sourceNoteId,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TaskImpl extends Task {
  _TaskImpl({
    int? id,
    required String title,
    DateTime? dueAt,
    required int durationMinutes,
    required _ifg2vma4.TaskPriority priority,
    required _ic097rko.TaskStatus status,
    int? sourceNoteId,
    required DateTime createdAt,
  }) : super._(
         id: id,
         title: title,
         dueAt: dueAt,
         durationMinutes: durationMinutes,
         priority: priority,
         status: status,
         sourceNoteId: sourceNoteId,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Task]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Task copyWith({
    Object? id = _Undefined,
    String? title,
    Object? dueAt = _Undefined,
    int? durationMinutes,
    _ifg2vma4.TaskPriority? priority,
    _ic097rko.TaskStatus? status,
    Object? sourceNoteId = _Undefined,
    DateTime? createdAt,
  }) {
    return Task(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      dueAt: dueAt is DateTime? ? dueAt : this.dueAt,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      sourceNoteId: sourceNoteId is int? ? sourceNoteId : this.sourceNoteId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
