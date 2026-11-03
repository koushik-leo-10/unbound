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
import 'package:mindmap_ai_server/src/generated/protocol.dart' as _ioa30tgl;
import 'package:serverpod/serverpod.dart' as _is;
import 'task.dart' as _iwn6t6fs;

abstract class RescheduleProposal
    implements _is.SerializableModel, _is.ProtocolSerialization {
  RescheduleProposal._({
    required this.task,
    required this.proposedStart,
    required this.proposedEnd,
  });

  factory RescheduleProposal({
    required _iwn6t6fs.Task task,
    required DateTime proposedStart,
    required DateTime proposedEnd,
  }) = _RescheduleProposalImpl;

  factory RescheduleProposal.fromJson(Map<String, dynamic> jsonSerialization) {
    return RescheduleProposal(
      task: _ioa30tgl.Protocol().deserialize<_iwn6t6fs.Task>(
        jsonSerialization['task'],
      ),
      proposedStart: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['proposedStart'],
      ),
      proposedEnd: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['proposedEnd'],
      ),
    );
  }

  _iwn6t6fs.Task task;

  DateTime proposedStart;

  DateTime proposedEnd;

  /// Returns a shallow copy of this [RescheduleProposal]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  RescheduleProposal copyWith({
    _iwn6t6fs.Task? task,
    DateTime? proposedStart,
    DateTime? proposedEnd,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RescheduleProposal',
      'task': task.toJson(),
      'proposedStart': proposedStart.toJson(),
      'proposedEnd': proposedEnd.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'RescheduleProposal',
      'task': task.toJsonForProtocol(),
      'proposedStart': proposedStart.toJson(),
      'proposedEnd': proposedEnd.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _RescheduleProposalImpl extends RescheduleProposal {
  _RescheduleProposalImpl({
    required _iwn6t6fs.Task task,
    required DateTime proposedStart,
    required DateTime proposedEnd,
  }) : super._(
         task: task,
         proposedStart: proposedStart,
         proposedEnd: proposedEnd,
       );

  /// Returns a shallow copy of this [RescheduleProposal]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  RescheduleProposal copyWith({
    _iwn6t6fs.Task? task,
    DateTime? proposedStart,
    DateTime? proposedEnd,
  }) {
    return RescheduleProposal(
      task: task ?? this.task.copyWith(),
      proposedStart: proposedStart ?? this.proposedStart,
      proposedEnd: proposedEnd ?? this.proposedEnd,
    );
  }
}
