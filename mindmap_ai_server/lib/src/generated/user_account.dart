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

abstract class UserAccount
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
  UserAccount._({
    this.id,
    required this.name,
    required this.email,
    required this.passwordHash,
    required this.salt,
    this.avatarUrl,
    required this.createdAt,
    this.lastLoginAt,
  });

  factory UserAccount({
    int? id,
    required String name,
    required String email,
    required String passwordHash,
    required String salt,
    String? avatarUrl,
    required DateTime createdAt,
    DateTime? lastLoginAt,
  }) = _UserAccountImpl;

  factory UserAccount.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserAccount(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String,
      passwordHash: jsonSerialization['passwordHash'] as String,
      salt: jsonSerialization['salt'] as String,
      avatarUrl: jsonSerialization['avatarUrl'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      lastLoginAt: jsonSerialization['lastLoginAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastLoginAt'],
            ),
    );
  }

  static final t = UserAccountTable();

  static const db = UserAccountRepository._();

  @override
  int? id;

  String name;

  String email;

  String passwordHash;

  String salt;

  String? avatarUrl;

  DateTime createdAt;

  DateTime? lastLoginAt;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [UserAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  UserAccount copyWith({
    int? id,
    String? name,
    String? email,
    String? passwordHash,
    String? salt,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'UserAccount',
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'passwordHash': passwordHash,
      'salt': salt,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'createdAt': createdAt.toJson(),
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'UserAccount',
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'passwordHash': passwordHash,
      'salt': salt,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'createdAt': createdAt.toJson(),
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
    };
  }

  static UserAccountInclude include() {
    return UserAccountInclude._();
  }

  static UserAccountIncludeList includeList({
    _is.WhereExpressionBuilder<UserAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserAccountTable>? orderBy,
    _is.OrderByListBuilder<UserAccountTable>? orderByList,
    UserAccountInclude? include,
  }) {
    return UserAccountIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserAccount.t),
      orderByList: orderByList?.call(UserAccount.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UserAccountImpl extends UserAccount {
  _UserAccountImpl({
    int? id,
    required String name,
    required String email,
    required String passwordHash,
    required String salt,
    String? avatarUrl,
    required DateTime createdAt,
    DateTime? lastLoginAt,
  }) : super._(
         id: id,
         name: name,
         email: email,
         passwordHash: passwordHash,
         salt: salt,
         avatarUrl: avatarUrl,
         createdAt: createdAt,
         lastLoginAt: lastLoginAt,
       );

  /// Returns a shallow copy of this [UserAccount]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  UserAccount copyWith({
    Object? id = _Undefined,
    String? name,
    String? email,
    String? passwordHash,
    String? salt,
    Object? avatarUrl = _Undefined,
    DateTime? createdAt,
    Object? lastLoginAt = _Undefined,
  }) {
    return UserAccount(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      salt: salt ?? this.salt,
      avatarUrl: avatarUrl is String? ? avatarUrl : this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt is DateTime? ? lastLoginAt : this.lastLoginAt,
    );
  }
}

class UserAccountUpdateTable extends _is.UpdateTable<UserAccountTable> {
  UserAccountUpdateTable(super.table);

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> email(String value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> passwordHash(String value) => _is.ColumnValue(
    table.passwordHash,
    value,
  );

  _is.ColumnValue<String, String> salt(String value) => _is.ColumnValue(
    table.salt,
    value,
  );

  _is.ColumnValue<String, String> avatarUrl(String? value) => _is.ColumnValue(
    table.avatarUrl,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastLoginAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastLoginAt,
        value,
      );
}

class UserAccountTable extends _is.Table<int?> {
  UserAccountTable({super.tableRelation}) : super(tableName: 'user_account') {
    updateTable = UserAccountUpdateTable(this);
    name = _is.ColumnString(
      'name',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    passwordHash = _is.ColumnString(
      'passwordHash',
      this,
    );
    salt = _is.ColumnString(
      'salt',
      this,
    );
    avatarUrl = _is.ColumnString(
      'avatarUrl',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    lastLoginAt = _is.ColumnDateTime(
      'lastLoginAt',
      this,
    );
  }

  late final UserAccountUpdateTable updateTable;

  late final _is.ColumnString name;

  late final _is.ColumnString email;

  late final _is.ColumnString passwordHash;

  late final _is.ColumnString salt;

  late final _is.ColumnString avatarUrl;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime lastLoginAt;

  @override
  List<_is.Column> get columns => [
    id,
    name,
    email,
    passwordHash,
    salt,
    avatarUrl,
    createdAt,
    lastLoginAt,
  ];
}

class UserAccountInclude extends _is.IncludeObject {
  UserAccountInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => UserAccount.t;
}

class UserAccountIncludeList extends _is.IncludeList {
  UserAccountIncludeList._({
    _is.WhereExpressionBuilder<UserAccountTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(UserAccount.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => UserAccount.t;
}

class UserAccountRepository {
  const UserAccountRepository._();

  /// Returns a list of [UserAccount]s matching the given query parameters.
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
  Future<List<UserAccount>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserAccountTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserAccountTable>? orderBy,
    _is.OrderByListBuilder<UserAccountTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<UserAccount>(
      where: where?.call(UserAccount.t),
      orderBy: orderBy?.call(UserAccount.t),
      orderByList: orderByList?.call(UserAccount.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [UserAccount] matching the given query parameters.
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
  Future<UserAccount?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserAccountTable>? where,
    int? offset,
    _is.OrderByBuilder<UserAccountTable>? orderBy,
    _is.OrderByListBuilder<UserAccountTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<UserAccount>(
      where: where?.call(UserAccount.t),
      orderBy: orderBy?.call(UserAccount.t),
      orderByList: orderByList?.call(UserAccount.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [UserAccount] by its [id] or null if no such row exists.
  Future<UserAccount?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<UserAccount>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [UserAccount]s in the list and returns the inserted rows.
  ///
  /// The returned [UserAccount]s will have their `id` fields set.
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
  Future<List<UserAccount>> insert(
    _is.DatabaseSession session,
    List<UserAccount> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<UserAccount>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [UserAccount] and returns the inserted row.
  ///
  /// The returned [UserAccount] will have its `id` field set.
  Future<UserAccount> insertRow(
    _is.DatabaseSession session,
    UserAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<UserAccount>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [UserAccount]s in the list and returns the resulting rows.
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
  /// The returned [UserAccount]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserAccount>> upsert(
    _is.DatabaseSession session,
    List<UserAccount> rows, {
    required _is.ColumnSelections<UserAccountTable> conflictColumns,
    _is.ColumnSelections<UserAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<UserAccountTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<UserAccount>(
      rows,
      conflictColumns: conflictColumns(UserAccount.t),
      updateColumns: updateColumns?.call(UserAccount.t),
      updateWhere: updateWhere?.call(UserAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [UserAccount] and returns the resulting row.
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
  /// The returned [UserAccount] will have its `id` field set.
  Future<UserAccount?> upsertRow(
    _is.DatabaseSession session,
    UserAccount row, {
    required _is.ColumnSelections<UserAccountTable> conflictColumns,
    _is.ColumnSelections<UserAccountTable>? updateColumns,
    _is.WhereExpressionBuilder<UserAccountTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<UserAccount>(
      row,
      conflictColumns: conflictColumns(UserAccount.t),
      updateColumns: updateColumns?.call(UserAccount.t),
      updateWhere: updateWhere?.call(UserAccount.t),
      transaction: transaction,
    );
  }

  /// Updates all [UserAccount]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserAccount>> update(
    _is.DatabaseSession session,
    List<UserAccount> rows, {
    _is.ColumnSelections<UserAccountTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<UserAccount>(
      rows,
      columns: columns?.call(UserAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [UserAccount]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<UserAccount> updateRow(
    _is.DatabaseSession session,
    UserAccount row, {
    _is.ColumnSelections<UserAccountTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<UserAccount>(
      row,
      columns: columns?.call(UserAccount.t),
      transaction: transaction,
    );
  }

  /// Updates a single [UserAccount] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<UserAccount?> updateById(
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<UserAccountUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<UserAccount>(
      id,
      columnValues: columnValues(UserAccount.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [UserAccount]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<UserAccount>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<UserAccountUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<UserAccountTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<UserAccountTable>? orderBy,
    _is.OrderByListBuilder<UserAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<UserAccount>(
      columnValues: columnValues(UserAccount.t.updateTable),
      where: where(UserAccount.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(UserAccount.t),
      orderByList: orderByList?.call(UserAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [UserAccount]s in the list and returns the deleted rows.
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
  Future<List<UserAccount>> delete(
    _is.DatabaseSession session,
    List<UserAccount> rows, {
    _is.OrderByBuilder<UserAccountTable>? orderBy,
    _is.OrderByListBuilder<UserAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<UserAccount>(
      rows,
      orderBy: orderBy?.call(UserAccount.t),
      orderByList: orderByList?.call(UserAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [UserAccount].
  Future<UserAccount> deleteRow(
    _is.DatabaseSession session,
    UserAccount row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<UserAccount>(
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
  Future<List<UserAccount>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserAccountTable> where,
    _is.OrderByBuilder<UserAccountTable>? orderBy,
    _is.OrderByListBuilder<UserAccountTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<UserAccount>(
      where: where(UserAccount.t),
      orderBy: orderBy?.call(UserAccount.t),
      orderByList: orderByList?.call(UserAccount.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<UserAccountTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<UserAccount>(
      where: where?.call(UserAccount.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [UserAccount] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<UserAccountTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<UserAccount>(
      where: where(UserAccount.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
