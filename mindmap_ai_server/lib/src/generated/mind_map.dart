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
import 'package:serverpod/serverpod.dart' as _is;

abstract class MindMap
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  static final t = MindMapTable();

  static const db = MindMapRepository._();

  @override
  int? id;

  String title;

  String rootNodeJson;

  int? sourceNoteId;

  int? userId;

  DateTime createdAt;

  DateTime updatedAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [MindMap]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static MindMapInclude include() {
    return MindMapInclude._();
  }

  static MindMapIncludeList includeList({
    _is.WhereExpressionBuilder<MindMapTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MindMapTable>? orderBy,
    _is.OrderByListBuilder<MindMapTable>? orderByList,
    MindMapInclude? include,
  }) {
    return MindMapIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MindMap.t),
      orderByList: orderByList?.call(MindMap.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class MindMapUpdateTable extends _is.UpdateTable<MindMapTable> {
  MindMapUpdateTable(super.table);

  _is.ColumnValue<String, String> title(String value) => _is.ColumnValue(
    table.title,
    value,
  );

  _is.ColumnValue<String, String> rootNodeJson(String value) => _is.ColumnValue(
    table.rootNodeJson,
    value,
  );

  _is.ColumnValue<int, int> sourceNoteId(int? value) => _is.ColumnValue(
    table.sourceNoteId,
    value,
  );

  _is.ColumnValue<int, int> userId(int? value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );
}

class MindMapTable extends _is.Table<int?> {
  MindMapTable({super.tableRelation}) : super(tableName: 'mind_map') {
    updateTable = MindMapUpdateTable(this);
    title = _is.ColumnString(
      'title',
      this,
    );
    rootNodeJson = _is.ColumnString(
      'rootNodeJson',
      this,
    );
    sourceNoteId = _is.ColumnInt(
      'sourceNoteId',
      this,
    );
    userId = _is.ColumnInt(
      'userId',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
  }

  late final MindMapUpdateTable updateTable;

  late final _is.ColumnString title;

  late final _is.ColumnString rootNodeJson;

  late final _is.ColumnInt sourceNoteId;

  late final _is.ColumnInt userId;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  @override
  List<_is.Column> get columns => [
    id,
    title,
    rootNodeJson,
    sourceNoteId,
    userId,
    createdAt,
    updatedAt,
  ];
}

class MindMapInclude extends _is.IncludeObject {
  MindMapInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => MindMap.t;
}

class MindMapIncludeList extends _is.IncludeList {
  MindMapIncludeList._({
    _is.WhereExpressionBuilder<MindMapTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(MindMap.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => MindMap.t;
}

class MindMapRepository {
  const MindMapRepository._();

  /// Returns a list of [MindMap]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<MindMap>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MindMapTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MindMapTable>? orderBy,
    _is.OrderByListBuilder<MindMapTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<MindMap>(
      where: where?.call(MindMap.t),
      orderBy: orderBy?.call(MindMap.t),
      orderByList: orderByList?.call(MindMap.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [MindMap] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<MindMap?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MindMapTable>? where,
    int? offset,
    _is.OrderByBuilder<MindMapTable>? orderBy,
    _is.OrderByListBuilder<MindMapTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<MindMap>(
      where: where?.call(MindMap.t),
      orderBy: orderBy?.call(MindMap.t),
      orderByList: orderByList?.call(MindMap.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [MindMap] by its [id] or null if no such row exists.
  Future<MindMap?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<MindMap>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [MindMap]s in the list and returns the inserted rows.
  ///
  /// The returned [MindMap]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MindMap>> insert(
    _is.DatabaseSession session,
    List<MindMap> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<MindMap>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [MindMap] and returns the inserted row.
  ///
  /// The returned [MindMap] will have its `id` field set.
  Future<MindMap> insertRow(
    _is.DatabaseSession session,
    MindMap row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<MindMap>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [MindMap]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [MindMap]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MindMap>> upsert(
    _is.DatabaseSession session,
    List<MindMap> rows, {
    required _is.ColumnSelections<MindMapTable> conflictColumns,
    _is.ColumnSelections<MindMapTable>? updateColumns,
    _is.WhereExpressionBuilder<MindMapTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<MindMap>(
      rows,
      conflictColumns: conflictColumns(MindMap.t),
      updateColumns: updateColumns?.call(MindMap.t),
      updateWhere: updateWhere?.call(MindMap.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [MindMap] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [MindMap] will have its `id` field set.
  Future<MindMap?> upsertRow(
    _is.DatabaseSession session,
    MindMap row, {
    required _is.ColumnSelections<MindMapTable> conflictColumns,
    _is.ColumnSelections<MindMapTable>? updateColumns,
    _is.WhereExpressionBuilder<MindMapTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<MindMap>(
      row,
      conflictColumns: conflictColumns(MindMap.t),
      updateColumns: updateColumns?.call(MindMap.t),
      updateWhere: updateWhere?.call(MindMap.t),
      transaction: transaction,
    );
  }

  /// Updates all [MindMap]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MindMap>> update(
    _is.DatabaseSession session,
    List<MindMap> rows, {
    _is.ColumnSelections<MindMapTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<MindMap>(
      rows,
      columns: columns?.call(MindMap.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [MindMap]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<MindMap> updateRow(
    _is.DatabaseSession session,
    MindMap row, {
    _is.ColumnSelections<MindMapTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<MindMap>(
      row,
      columns: columns?.call(MindMap.t),
      transaction: transaction,
    );
  }

  /// Updates a single [MindMap] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<MindMap?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<MindMapUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<MindMap>(
      id,
      columnValues: columnValues(MindMap.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [MindMap]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MindMap>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<MindMapUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<MindMapTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<MindMapTable>? orderBy,
    _is.OrderByListBuilder<MindMapTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<MindMap>(
      columnValues: columnValues(MindMap.t.updateTable),
      where: where(MindMap.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(MindMap.t),
      orderByList: orderByList?.call(MindMap.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [MindMap]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MindMap>> delete(
    _is.DatabaseSession session,
    List<MindMap> rows, {
    _is.OrderByBuilder<MindMapTable>? orderBy,
    _is.OrderByListBuilder<MindMapTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<MindMap>(
      rows,
      orderBy: orderBy?.call(MindMap.t),
      orderByList: orderByList?.call(MindMap.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [MindMap].
  Future<MindMap> deleteRow(
    _is.DatabaseSession session,
    MindMap row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<MindMap>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<MindMap>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MindMapTable> where,
    _is.OrderByBuilder<MindMapTable>? orderBy,
    _is.OrderByListBuilder<MindMapTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<MindMap>(
      where: where(MindMap.t),
      orderBy: orderBy?.call(MindMap.t),
      orderByList: orderByList?.call(MindMap.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<MindMapTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<MindMap>(
      where: where?.call(MindMap.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [MindMap] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<MindMapTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<MindMap>(
      where: where(MindMap.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
