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

abstract class MindMap
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MindMap._({
    this.id,
    required this.title,
    required this.rootNodeJson,
    this.sourceNoteId,
    this.userId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MindMap({
    int? id,
    required String title,
    required String rootNodeJson,
    int? sourceNoteId,
    int? userId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MindMapImpl;

  factory MindMap.fromJson(Map<String, dynamic> jsonSerialization) {
    return MindMap(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      rootNodeJson: jsonSerialization['rootNodeJson'] as String,
      sourceNoteId: jsonSerialization['sourceNoteId'] as int?,
      userId: jsonSerialization['userId'] as int?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  String rootNodeJson;

  int? sourceNoteId;

  int? userId;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [MindMap]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MindMap copyWith({
    int? id,
    String? title,
    String? rootNodeJson,
    int? sourceNoteId,
    int? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MindMap',
      if (id != null) 'id': id,
      'title': title,
      'rootNodeJson': rootNodeJson,
      if (sourceNoteId != null) 'sourceNoteId': sourceNoteId,
      if (userId != null) 'userId': userId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MindMap',
      if (id != null) 'id': id,
      'title': title,
      'rootNodeJson': rootNodeJson,
      if (sourceNoteId != null) 'sourceNoteId': sourceNoteId,
      if (userId != null) 'userId': userId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MindMapImpl extends MindMap {
  _MindMapImpl({
    int? id,
    required String title,
    required String rootNodeJson,
    int? sourceNoteId,
    int? userId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         title: title,
         rootNodeJson: rootNodeJson,
         sourceNoteId: sourceNoteId,
         userId: userId,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [MindMap]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MindMap copyWith({
    Object? id = _Undefined,
    String? title,
    String? rootNodeJson,
    Object? sourceNoteId = _Undefined,
    Object? userId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MindMap(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      rootNodeJson: rootNodeJson ?? this.rootNodeJson,
      sourceNoteId: sourceNoteId is int? ? sourceNoteId : this.sourceNoteId,
      userId: userId is int? ? userId : this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
