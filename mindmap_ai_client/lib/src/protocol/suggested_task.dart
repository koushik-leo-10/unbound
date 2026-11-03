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

abstract class SuggestedTask
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SuggestedTask._({
    required this.title,
    this.dueAt,
    required this.priority,
    required this.durationMinutes,
  });

  factory SuggestedTask({
    required String title,
    DateTime? dueAt,
    required _ifg2vma4.TaskPriority priority,
    required int durationMinutes,
  }) = _SuggestedTaskImpl;

  factory SuggestedTask.fromJson(Map<String, dynamic> jsonSerialization) {
    return SuggestedTask(
      title: jsonSerialization['title'] as String,
      dueAt: jsonSerialization['dueAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      priority: _ifg2vma4.TaskPriority.fromJson(
        (jsonSerialization['priority'] as String),
      ),
      durationMinutes: jsonSerialization['durationMinutes'] as int,
    );
  }

  String title;

  DateTime? dueAt;

  _ifg2vma4.TaskPriority priority;

  int durationMinutes;

  /// Returns a shallow copy of this [SuggestedTask]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SuggestedTask copyWith({
    String? title,
    DateTime? dueAt,
    _ifg2vma4.TaskPriority? priority,
    int? durationMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SuggestedTask',
      'title': title,
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      'priority': priority.toJson(),
      'durationMinutes': durationMinutes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SuggestedTask',
      'title': title,
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      'priority': priority.toJson(),
      'durationMinutes': durationMinutes,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SuggestedTaskImpl extends SuggestedTask {
  _SuggestedTaskImpl({
    required String title,
    DateTime? dueAt,
    required _ifg2vma4.TaskPriority priority,
    required int durationMinutes,
  }) : super._(
         title: title,
         dueAt: dueAt,
         priority: priority,
         durationMinutes: durationMinutes,
       );

  /// Returns a shallow copy of this [SuggestedTask]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SuggestedTask copyWith({
    String? title,
    Object? dueAt = _Undefined,
    _ifg2vma4.TaskPriority? priority,
    int? durationMinutes,
  }) {
    return SuggestedTask(
      title: title ?? this.title,
      dueAt: dueAt is DateTime? ? dueAt : this.dueAt,
      priority: priority ?? this.priority,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}
