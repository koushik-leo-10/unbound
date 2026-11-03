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

abstract class DailySuggestion
    implements _is.SerializableModel, _is.ProtocolSerialization {
  DailySuggestion._({
    required this.message,
    required this.generatedByAi,
  });

  factory DailySuggestion({
    required String message,
    required bool generatedByAi,
  }) = _DailySuggestionImpl;

  factory DailySuggestion.fromJson(Map<String, dynamic> jsonSerialization) {
    return DailySuggestion(
      message: jsonSerialization['message'] as String,
      generatedByAi: _is.BoolJsonExtension.fromJson(
        jsonSerialization['generatedByAi'],
      ),
    );
  }

  String message;

  bool generatedByAi;

  /// Returns a shallow copy of this [DailySuggestion]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DailySuggestion copyWith({
    String? message,
    bool? generatedByAi,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DailySuggestion',
      'message': message,
      'generatedByAi': generatedByAi,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DailySuggestion',
      'message': message,
      'generatedByAi': generatedByAi,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _DailySuggestionImpl extends DailySuggestion {
  _DailySuggestionImpl({
    required String message,
    required bool generatedByAi,
  }) : super._(
         message: message,
         generatedByAi: generatedByAi,
       );

  /// Returns a shallow copy of this [DailySuggestion]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DailySuggestion copyWith({
    String? message,
    bool? generatedByAi,
  }) {
    return DailySuggestion(
      message: message ?? this.message,
      generatedByAi: generatedByAi ?? this.generatedByAi,
    );
  }
}
