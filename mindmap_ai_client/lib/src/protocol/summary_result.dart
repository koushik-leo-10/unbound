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
import 'package:mindmap_ai_client/src/protocol/protocol.dart' as _iyh1nd5l;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'suggested_task.dart' as _iax64zjc;

abstract class SummaryResult
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SummaryResult._({
    required this.summary,
    required this.keyPoints,
    required this.actionItems,
    required this.suggestedTasks,
  });

  factory SummaryResult({
    required String summary,
    required List<String> keyPoints,
    required List<String> actionItems,
    required List<_iax64zjc.SuggestedTask> suggestedTasks,
  }) = _SummaryResultImpl;

  factory SummaryResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SummaryResult(
      summary: jsonSerialization['summary'] as String,
      keyPoints: _iyh1nd5l.Protocol().deserialize<List<String>>(
        jsonSerialization['keyPoints'],
      ),
      actionItems: _iyh1nd5l.Protocol().deserialize<List<String>>(
        jsonSerialization['actionItems'],
      ),
      suggestedTasks: _iyh1nd5l.Protocol()
          .deserialize<List<_iax64zjc.SuggestedTask>>(
            jsonSerialization['suggestedTasks'],
          ),
    );
  }

  String summary;

  List<String> keyPoints;

  List<String> actionItems;

  List<_iax64zjc.SuggestedTask> suggestedTasks;

  /// Returns a shallow copy of this [SummaryResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SummaryResult copyWith({
    String? summary,
    List<String>? keyPoints,
    List<String>? actionItems,
    List<_iax64zjc.SuggestedTask>? suggestedTasks,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SummaryResult',
      'summary': summary,
      'keyPoints': keyPoints.toJson(),
      'actionItems': actionItems.toJson(),
      'suggestedTasks': suggestedTasks.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SummaryResult',
      'summary': summary,
      'keyPoints': keyPoints.toJson(),
      'actionItems': actionItems.toJson(),
      'suggestedTasks': suggestedTasks.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SummaryResultImpl extends SummaryResult {
  _SummaryResultImpl({
    required String summary,
    required List<String> keyPoints,
    required List<String> actionItems,
    required List<_iax64zjc.SuggestedTask> suggestedTasks,
  }) : super._(
         summary: summary,
         keyPoints: keyPoints,
         actionItems: actionItems,
         suggestedTasks: suggestedTasks,
       );

  /// Returns a shallow copy of this [SummaryResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SummaryResult copyWith({
    String? summary,
    List<String>? keyPoints,
    List<String>? actionItems,
    List<_iax64zjc.SuggestedTask>? suggestedTasks,
  }) {
    return SummaryResult(
      summary: summary ?? this.summary,
      keyPoints: keyPoints ?? this.keyPoints.map((e0) => e0).toList(),
      actionItems: actionItems ?? this.actionItems.map((e0) => e0).toList(),
      suggestedTasks:
          suggestedTasks ??
          this.suggestedTasks.map((e0) => e0.copyWith()).toList(),
    );
  }
}
