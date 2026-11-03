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

abstract class DashboardStats
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DashboardStats._({
    required this.totalNotes,
    required this.pendingTasks,
    required this.completedTasks,
    required this.overdueTasks,
    required this.totalTasks,
    required this.notesWithSummaries,
  });

  factory DashboardStats({
    required int totalNotes,
    required int pendingTasks,
    required int completedTasks,
    required int overdueTasks,
    required int totalTasks,
    required int notesWithSummaries,
  }) = _DashboardStatsImpl;

  factory DashboardStats.fromJson(Map<String, dynamic> jsonSerialization) {
    return DashboardStats(
      totalNotes: jsonSerialization['totalNotes'] as int,
      pendingTasks: jsonSerialization['pendingTasks'] as int,
      completedTasks: jsonSerialization['completedTasks'] as int,
      overdueTasks: jsonSerialization['overdueTasks'] as int,
      totalTasks: jsonSerialization['totalTasks'] as int,
      notesWithSummaries: jsonSerialization['notesWithSummaries'] as int,
    );
  }

  int totalNotes;

  int pendingTasks;

  int completedTasks;

  int overdueTasks;

  int totalTasks;

  int notesWithSummaries;

  /// Returns a shallow copy of this [DashboardStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DashboardStats copyWith({
    int? totalNotes,
    int? pendingTasks,
    int? completedTasks,
    int? overdueTasks,
    int? totalTasks,
    int? notesWithSummaries,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DashboardStats',
      'totalNotes': totalNotes,
      'pendingTasks': pendingTasks,
      'completedTasks': completedTasks,
      'overdueTasks': overdueTasks,
      'totalTasks': totalTasks,
      'notesWithSummaries': notesWithSummaries,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DashboardStats',
      'totalNotes': totalNotes,
      'pendingTasks': pendingTasks,
      'completedTasks': completedTasks,
      'overdueTasks': overdueTasks,
      'totalTasks': totalTasks,
      'notesWithSummaries': notesWithSummaries,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DashboardStatsImpl extends DashboardStats {
  _DashboardStatsImpl({
    required int totalNotes,
    required int pendingTasks,
    required int completedTasks,
    required int overdueTasks,
    required int totalTasks,
    required int notesWithSummaries,
  }) : super._(
         totalNotes: totalNotes,
         pendingTasks: pendingTasks,
         completedTasks: completedTasks,
         overdueTasks: overdueTasks,
         totalTasks: totalTasks,
         notesWithSummaries: notesWithSummaries,
       );

  /// Returns a shallow copy of this [DashboardStats]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DashboardStats copyWith({
    int? totalNotes,
    int? pendingTasks,
    int? completedTasks,
    int? overdueTasks,
    int? totalTasks,
    int? notesWithSummaries,
  }) {
    return DashboardStats(
      totalNotes: totalNotes ?? this.totalNotes,
      pendingTasks: pendingTasks ?? this.pendingTasks,
      completedTasks: completedTasks ?? this.completedTasks,
      overdueTasks: overdueTasks ?? this.overdueTasks,
      totalTasks: totalTasks ?? this.totalTasks,
      notesWithSummaries: notesWithSummaries ?? this.notesWithSummaries,
    );
  }
}
