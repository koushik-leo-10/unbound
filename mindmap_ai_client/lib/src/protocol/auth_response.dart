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
import 'user_account.dart' as _i4om8q6j;

abstract class AuthResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AuthResponse._({
    required this.success,
    this.message,
    this.token,
    this.user,
  });

  factory AuthResponse({
    required bool success,
    String? message,
    String? token,
    _i4om8q6j.UserAccount? user,
  }) = _AuthResponseImpl;

  factory AuthResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return AuthResponse(
      success: _isc.BoolJsonExtension.fromJson(jsonSerialization['success']),
      message: jsonSerialization['message'] as String?,
      token: jsonSerialization['token'] as String?,
      user: jsonSerialization['user'] == null
          ? null
          : _iyh1nd5l.Protocol().deserialize<_i4om8q6j.UserAccount>(
              jsonSerialization['user'],
            ),
    );
  }

  bool success;

  String? message;

  String? token;

  _i4om8q6j.UserAccount? user;

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AuthResponse copyWith({
    bool? success,
    String? message,
    String? token,
    _i4om8q6j.UserAccount? user,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuthResponse',
      'success': success,
      if (message != null) 'message': message,
      if (token != null) 'token': token,
      if (user != null) 'user': user?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AuthResponse',
      'success': success,
      if (message != null) 'message': message,
      if (token != null) 'token': token,
      if (user != null) 'user': user?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AuthResponseImpl extends AuthResponse {
  _AuthResponseImpl({
    required bool success,
    String? message,
    String? token,
    _i4om8q6j.UserAccount? user,
  }) : super._(
         success: success,
         message: message,
         token: token,
         user: user,
       );

  /// Returns a shallow copy of this [AuthResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AuthResponse copyWith({
    bool? success,
    Object? message = _Undefined,
    Object? token = _Undefined,
    Object? user = _Undefined,
  }) {
    return AuthResponse(
      success: success ?? this.success,
      message: message is String? ? message : this.message,
      token: token is String? ? token : this.token,
      user: user is _i4om8q6j.UserAccount? ? user : this.user?.copyWith(),
    );
  }
}
