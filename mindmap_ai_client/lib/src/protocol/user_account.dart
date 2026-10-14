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

abstract class UserAccount
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      lastLoginAt: jsonSerialization['lastLoginAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastLoginAt'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String email;

  String passwordHash;

  String salt;

  String? avatarUrl;

  DateTime createdAt;

  DateTime? lastLoginAt;

  /// Returns a shallow copy of this [UserAccount]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
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
