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

abstract class UserPreferences
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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

  static final t = UserPreferencesTable();

  static const db = UserPreferencesRepository._();

  @override
  int? id;

  int workingDayStartMinutes;

  int workingDayEndMinutes;

  int breakMinutes;

  String timezone;

  int timezoneOffsetMinutes;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserPreferences]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
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

  static UserPreferencesInclude include() {
    return UserPreferencesInclude._();
  }

  static UserPreferencesIncludeList includeList({
    _is.WhereExpressionBuilder<UserPreferencesTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserPreferencesTable>? orderBy,
    _is.OrderByListBuilder<UserPreferencesTable>? orderByList,
    UserPreferencesInclude? include,
  }) {
    return UserPreferencesIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserPreferences.t),
      orderByList: orderByList?.call(UserPreferences.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
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
  @_is.useResult
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

class UserPreferencesUpdateTable extends _is.UpdateTable<UserPreferencesTable> {
  UserPreferencesUpdateTable(super.table);

  _is.ColumnValue<int, int> workingDayStartMinutes(int value) =>
      _is.ColumnValue(
        table.workingDayStartMinutes,
        value,
      );

  _is.ColumnValue<int, int> workingDayEndMinutes(int value) => _is.ColumnValue(
    table.workingDayEndMinutes,
    value,
  );

  _is.ColumnValue<int, int> breakMinutes(int value) => _is.ColumnValue(
    table.breakMinutes,
    value,
  );

  _is.ColumnValue<String, String> timezone(String value) => _is.ColumnValue(
    table.timezone,
    value,
  );

  _is.ColumnValue<int, int> timezoneOffsetMinutes(int value) => _is.ColumnValue(
    table.timezoneOffsetMinutes,
    value,
  );
}

class UserPreferencesTable extends _is.Table<int?> {
  UserPreferencesTable({super.tableRelation})
    : super(tableName: 'user_preferences') {
    updateTable = UserPreferencesUpdateTable(this);
    workingDayStartMinutes = _is.ColumnInt(
      'workingDayStartMinutes',
      this,
    );
    workingDayEndMinutes = _is.ColumnInt(
      'workingDayEndMinutes',
      this,
    );
    breakMinutes = _is.ColumnInt(
      'breakMinutes',
      this,
    );
    timezone = _is.ColumnString(
      'timezone',
      this,
    );
    timezoneOffsetMinutes = _is.ColumnInt(
      'timezoneOffsetMinutes',
      this,
    );
  }

  late final UserPreferencesUpdateTable updateTable;

  late final _is.ColumnInt workingDayStartMinutes;

  late final _is.ColumnInt workingDayEndMinutes;

  late final _is.ColumnInt breakMinutes;

  late final _is.ColumnString timezone;

  late final _is.ColumnInt timezoneOffsetMinutes;

  @override
  List<_is.Column> get columns => [
    id,
    workingDayStartMinutes,
    workingDayEndMinutes,
    breakMinutes,
    timezone,
    timezoneOffsetMinutes,
  ];
}

class UserPreferencesInclude extends _is.IncludeObject {
  UserPreferencesInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UserPreferences.t;
}

class UserPreferencesIncludeList extends _is.IncludeList {
  UserPreferencesIncludeList._({
    _is.WhereExpressionBuilder<UserPreferencesTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserPreferences.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UserPreferences.t;
}

class UserPreferencesRepository {
  const UserPreferencesRepository._();

  /// Returns a list of [UserPreferences]s matching the given query parameters.
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
  Future<List<UserPreferences>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserPreferencesTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserPreferencesTable>? orderBy,
    _is.OrderByListBuilder<UserPreferencesTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserPreferences>(
      where: where?.call(UserPreferences.t),
      orderBy: orderBy?.call(UserPreferences.t),
      orderByList: orderByList?.call(UserPreferences.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserPreferences] matching the given query parameters.
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
  Future<UserPreferences?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserPreferencesTable>? where,
    int? offset,
    _is.OrderByBuilder<UserPreferencesTable>? orderBy,
    _is.OrderByListBuilder<UserPreferencesTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserPreferences>(
      where: where?.call(UserPreferences.t),
      orderBy: orderBy?.call(UserPreferences.t),
      orderByList: orderByList?.call(UserPreferences.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserPreferences] by its [id] or null if no such row exists.
  Future<UserPreferences?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserPreferences>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserPreferences]s in the list and returns the inserted rows.
  ///
  /// The returned [UserPreferences]s will have their `id` fields set.
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
  Future<List<UserPreferences>> insert(
    _is.DatabaseSession session,
    List<UserPreferences> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UserPreferences>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UserPreferences] and returns the inserted row.
  ///
  /// The returned [UserPreferences] will have its `id` field set.
  Future<UserPreferences> insertRow(
    _is.DatabaseSession session,
    UserPreferences row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserPreferences>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UserPreferences]s in the list and returns the resulting rows.
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
  /// The returned [UserPreferences]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserPreferences>> upsert(
    _is.DatabaseSession session,
    List<UserPreferences> rows, {
    required _is.ColumnSelections<UserPreferencesTable> conflictColumns,
    _is.ColumnSelections<UserPreferencesTable>? updateColumns,
    _is.WhereExpressionBuilder<UserPreferencesTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UserPreferences>(
      rows,
      conflictColumns: conflictColumns(UserPreferences.t),
      updateColumns: updateColumns?.call(UserPreferences.t),
      updateWhere: updateWhere?.call(UserPreferences.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UserPreferences] and returns the resulting row.
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
  /// The returned [UserPreferences] will have its `id` field set.
  Future<UserPreferences?> upsertRow(
    _is.DatabaseSession session,
    UserPreferences row, {
    required _is.ColumnSelections<UserPreferencesTable> conflictColumns,
    _is.ColumnSelections<UserPreferencesTable>? updateColumns,
    _is.WhereExpressionBuilder<UserPreferencesTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UserPreferences>(
      row,
      conflictColumns: conflictColumns(UserPreferences.t),
      updateColumns: updateColumns?.call(UserPreferences.t),
      updateWhere: updateWhere?.call(UserPreferences.t),
      transaction: transaction,
    );
  }

  /// Updates all [UserPreferences]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserPreferences>> update(
    _is.DatabaseSession session,
    List<UserPreferences> rows, {
    _is.ColumnSelections<UserPreferencesTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UserPreferences>(
      rows,
      columns: columns?.call(UserPreferences.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UserPreferences]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserPreferences> updateRow(
    _is.DatabaseSession session,
    UserPreferences row, {
    _is.ColumnSelections<UserPreferencesTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserPreferences>(
      row,
      columns: columns?.call(UserPreferences.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserPreferences] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserPreferences?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UserPreferencesUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UserPreferences>(
      id,
      columnValues: columnValues(UserPreferences.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserPreferences]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserPreferences>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UserPreferencesUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<UserPreferencesTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserPreferencesTable>? orderBy,
    _is.OrderByListBuilder<UserPreferencesTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UserPreferences>(
      columnValues: columnValues(UserPreferences.t.updateTable),
      where: where(UserPreferences.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserPreferences.t),
      orderByList: orderByList?.call(UserPreferences.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UserPreferences]s in the list and returns the deleted rows.
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
  Future<List<UserPreferences>> delete(
    _is.DatabaseSession session,
    List<UserPreferences> rows, {
    _is.OrderByBuilder<UserPreferencesTable>? orderBy,
    _is.OrderByListBuilder<UserPreferencesTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UserPreferences>(
      rows,
      orderBy: orderBy?.call(UserPreferences.t),
      orderByList: orderByList?.call(UserPreferences.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UserPreferences].
  Future<UserPreferences> deleteRow(
    _is.DatabaseSession session,
    UserPreferences row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserPreferences>(
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
  Future<List<UserPreferences>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserPreferencesTable> where,
    _is.OrderByBuilder<UserPreferencesTable>? orderBy,
    _is.OrderByListBuilder<UserPreferencesTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UserPreferences>(
      where: where(UserPreferences.t),
      orderBy: orderBy?.call(UserPreferences.t),
      orderByList: orderByList?.call(UserPreferences.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserPreferencesTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UserPreferences>(
      where: where?.call(UserPreferences.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserPreferences] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserPreferencesTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserPreferences>(
      where: where(UserPreferences.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
