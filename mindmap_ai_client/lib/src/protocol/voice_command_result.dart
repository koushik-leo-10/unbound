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
import 'voice_intent.dart' as _icipe65l;

abstract class VoiceCommandResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  VoiceCommandResult._({
    required this.intent,
    required this.title,
    required this.content,
    this.dueAt,
    required this.priority,
    required this.durationMinutes,
  });

  factory VoiceCommandResult({
    required _icipe65l.VoiceIntent intent,
    required String title,
    required String content,
    DateTime? dueAt,
    required _ifg2vma4.TaskPriority priority,
    required int durationMinutes,
  }) = _VoiceCommandResultImpl;

  factory VoiceCommandResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return VoiceCommandResult(
      intent: _icipe65l.VoiceIntent.fromJson(
        (jsonSerialization['intent'] as String),
      ),
      title: jsonSerialization['title'] as String,
      content: jsonSerialization['content'] as String,
      dueAt: jsonSerialization['dueAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['dueAt']),
      priority: _ifg2vma4.TaskPriority.fromJson(
        (jsonSerialization['priority'] as String),
      ),
      durationMinutes: jsonSerialization['durationMinutes'] as int,
    );
  }

  _icipe65l.VoiceIntent intent;

  String title;

  String content;

  DateTime? dueAt;

  _ifg2vma4.TaskPriority priority;

  int durationMinutes;

  /// Returns a shallow copy of this [VoiceCommandResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  VoiceCommandResult copyWith({
    _icipe65l.VoiceIntent? intent,
    String? title,
    String? content,
    DateTime? dueAt,
    _ifg2vma4.TaskPriority? priority,
    int? durationMinutes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VoiceCommandResult',
      'intent': intent.toJson(),
      'title': title,
      'content': content,
      if (dueAt != null) 'dueAt': dueAt?.toJson(),
      'priority': priority.toJson(),
      'durationMinutes': durationMinutes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VoiceCommandResult',
      'intent': intent.toJson(),
      'title': title,
      'content': content,
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

class _VoiceCommandResultImpl extends VoiceCommandResult {
  _VoiceCommandResultImpl({
    required _icipe65l.VoiceIntent intent,
    required String title,
    required String content,
    DateTime? dueAt,
    required _ifg2vma4.TaskPriority priority,
    required int durationMinutes,
  }) : super._(
         intent: intent,
         title: title,
         content: content,
         dueAt: dueAt,
         priority: priority,
         durationMinutes: durationMinutes,
       );

  /// Returns a shallow copy of this [VoiceCommandResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  VoiceCommandResult copyWith({
    _icipe65l.VoiceIntent? intent,
    String? title,
    String? content,
    Object? dueAt = _Undefined,
    _ifg2vma4.TaskPriority? priority,
    int? durationMinutes,
  }) {
    return VoiceCommandResult(
      intent: intent ?? this.intent,
      title: title ?? this.title,
      content: content ?? this.content,
      dueAt: dueAt is DateTime? ? dueAt : this.dueAt,
      priority: priority ?? this.priority,
      durationMinutes: durationMinutes ?? this.durationMinutes,
    );
  }
}
