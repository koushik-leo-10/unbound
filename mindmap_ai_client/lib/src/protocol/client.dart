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
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:mindmap_ai_client/src/protocol/auth_response.dart' as _ihx9go0m;
import 'package:mindmap_ai_client/src/protocol/daily_suggestion.dart'
    as _iuf182mj;
import 'package:mindmap_ai_client/src/protocol/dashboard_stats.dart'
    as _ilwy2lrs;
import 'package:mindmap_ai_client/src/protocol/mind_map.dart' as _i0pswou3;
import 'package:mindmap_ai_client/src/protocol/note.dart' as _ig274zj0;
import 'package:mindmap_ai_client/src/protocol/reschedule_proposal.dart'
    as _icbusygb;
import 'package:mindmap_ai_client/src/protocol/summary_result.dart'
    as _ip74vbrs;
import 'package:mindmap_ai_client/src/protocol/task.dart' as _i5n1037d;
import 'package:mindmap_ai_client/src/protocol/task_priority.dart' as _ig5a9rfu;
import 'package:mindmap_ai_client/src/protocol/task_status.dart' as _i0fugra7;
import 'package:mindmap_ai_client/src/protocol/user_account.dart' as _iiv5ozhh;
import 'package:mindmap_ai_client/src/protocol/user_preferences.dart'
    as _imp6ktje;
import 'package:mindmap_ai_client/src/protocol/voice_command_result.dart'
    as _i349fdo8;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_isc.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _iacc.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// If [refreshToken] is omitted, cookie-mode web clients fall back to the
  /// configured HttpOnly refresh cookie. When neither source is present this
  /// throws [RefreshTokenNotFoundException], the same public "no usable refresh
  /// credential" exception used for unknown refresh tokens.
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'jwtRefresh',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// ai.summarizeText / processVoiceCommand / getDailySuggestion
///
/// The AI only INTERPRETS. Nothing here writes tasks or notes.
/// {@category Endpoint}
class EndpointAi extends _isc.EndpointRef {
  EndpointAi(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'ai';

  _ida.Future<_ip74vbrs.SummaryResult> summarizeText(String text) =>
      caller.callServerEndpoint<_ip74vbrs.SummaryResult>(
        'ai',
        'summarizeText',
        {'text': text},
      );

  _ida.Future<String> generateMindMap(String text) =>
      caller.callServerEndpoint<String>(
        'ai',
        'generateMindMap',
        {'text': text},
      );

  _ida.Future<_i349fdo8.VoiceCommandResult> processVoiceCommand(String text) =>
      caller.callServerEndpoint<_i349fdo8.VoiceCommandResult>(
        'ai',
        'processVoiceCommand',
        {'text': text},
      );

  _ida.Future<_iuf182mj.DailySuggestion> getDailySuggestion() =>
      caller.callServerEndpoint<_iuf182mj.DailySuggestion>(
        'ai',
        'getDailySuggestion',
        {},
      );
}

/// CRUD operations for saving and managing visual mind maps in PostgreSQL.
/// {@category Endpoint}
class EndpointMindMaps extends _isc.EndpointRef {
  EndpointMindMaps(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'mindMaps';

  _ida.Future<_i0pswou3.MindMap> createMindMap(
    String title,
    String rootNodeJson, {
    int? sourceNoteId,
    int? userId,
  }) => caller.callServerEndpoint<_i0pswou3.MindMap>(
    'mindMaps',
    'createMindMap',
    {
      'title': title,
      'rootNodeJson': rootNodeJson,
      'sourceNoteId': sourceNoteId,
      'userId': userId,
    },
  );

  _ida.Future<List<_i0pswou3.MindMap>> getMindMaps({int? userId}) =>
      caller.callServerEndpoint<List<_i0pswou3.MindMap>>(
        'mindMaps',
        'getMindMaps',
        {'userId': userId},
      );

  _ida.Future<_i0pswou3.MindMap?> getMindMap(int id) =>
      caller.callServerEndpoint<_i0pswou3.MindMap?>(
        'mindMaps',
        'getMindMap',
        {'id': id},
      );

  _ida.Future<_i0pswou3.MindMap> updateMindMap(
    int id,
    String title,
    String rootNodeJson,
  ) => caller.callServerEndpoint<_i0pswou3.MindMap>(
    'mindMaps',
    'updateMindMap',
    {
      'id': id,
      'title': title,
      'rootNodeJson': rootNodeJson,
    },
  );

  _ida.Future<void> deleteMindMap(int id) => caller.callServerEndpoint<void>(
    'mindMaps',
    'deleteMindMap',
    {'id': id},
  );
}

/// notes.createNote / getNotes / updateNote / deleteNote
///
/// Demo build: a single demo user, no authentication.
/// {@category Endpoint}
class EndpointNotes extends _isc.EndpointRef {
  EndpointNotes(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notes';

  _ida.Future<_ig274zj0.Note> createNote(
    String title,
    String content,
  ) => caller.callServerEndpoint<_ig274zj0.Note>(
    'notes',
    'createNote',
    {
      'title': title,
      'content': content,
    },
  );

  /// Newest first.
  _ida.Future<List<_ig274zj0.Note>> getNotes() =>
      caller.callServerEndpoint<List<_ig274zj0.Note>>(
        'notes',
        'getNotes',
        {},
      );

  _ida.Future<_ig274zj0.Note> updateNote(
    int id,
    String title,
    String content, {
    String? summary,
  }) => caller.callServerEndpoint<_ig274zj0.Note>(
    'notes',
    'updateNote',
    {
      'id': id,
      'title': title,
      'content': content,
      'summary': summary,
    },
  );

  /// Deletes the note; tasks created from it are kept but detached.
  _ida.Future<void> deleteNote(int id) => caller.callServerEndpoint<void>(
    'notes',
    'deleteNote',
    {'id': id},
  );
}

/// Working hours, break length and time zone used by the scheduler.
/// {@category Endpoint}
class EndpointPreferences extends _isc.EndpointRef {
  EndpointPreferences(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'preferences';

  _ida.Future<_imp6ktje.UserPreferences> getPreferences() =>
      caller.callServerEndpoint<_imp6ktje.UserPreferences>(
        'preferences',
        'getPreferences',
        {},
      );

  _ida.Future<_imp6ktje.UserPreferences> savePreferences(
    int workingDayStartMinutes,
    int workingDayEndMinutes,
    int breakMinutes,
    String timezone,
    int timezoneOffsetMinutes,
  ) => caller.callServerEndpoint<_imp6ktje.UserPreferences>(
    'preferences',
    'savePreferences',
    {
      'workingDayStartMinutes': workingDayStartMinutes,
      'workingDayEndMinutes': workingDayEndMinutes,
      'breakMinutes': breakMinutes,
      'timezone': timezone,
      'timezoneOffsetMinutes': timezoneOffsetMinutes,
    },
  );
}

/// tasks.createTask / getTasks / updateTask / deleteTask / rescheduleTask ...
/// {@category Endpoint}
class EndpointTasks extends _isc.EndpointRef {
  EndpointTasks(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'tasks';

  _ida.Future<_i5n1037d.Task> createTask(
    String title,
    _ig5a9rfu.TaskPriority priority,
    int durationMinutes, {
    DateTime? dueAt,
    int? sourceNoteId,
  }) => caller.callServerEndpoint<_i5n1037d.Task>(
    'tasks',
    'createTask',
    {
      'title': title,
      'priority': priority,
      'durationMinutes': durationMinutes,
      'dueAt': dueAt,
      'sourceNoteId': sourceNoteId,
    },
  );

  /// All tasks, or only those with [status]. Soonest deadline first.
  _ida.Future<List<_i5n1037d.Task>> getTasks({_i0fugra7.TaskStatus? status}) =>
      caller.callServerEndpoint<List<_i5n1037d.Task>>(
        'tasks',
        'getTasks',
        {'status': status},
      );

  _ida.Future<List<_i5n1037d.Task>> getOverdueTasks() =>
      caller.callServerEndpoint<List<_i5n1037d.Task>>(
        'tasks',
        'getOverdueTasks',
        {},
      );

  /// Rule-based ranking of pending tasks (overdue and urgent first).
  _ida.Future<List<_i5n1037d.Task>> getPrioritizedTasks({required int limit}) =>
      caller.callServerEndpoint<List<_i5n1037d.Task>>(
        'tasks',
        'getPrioritizedTasks',
        {'limit': limit},
      );

  _ida.Future<_i5n1037d.Task> updateTask(
    int id, {
    String? title,
    DateTime? dueAt,
    bool? clearDueAt,
    _ig5a9rfu.TaskPriority? priority,
    _i0fugra7.TaskStatus? status,
    int? durationMinutes,
  }) => caller.callServerEndpoint<_i5n1037d.Task>(
    'tasks',
    'updateTask',
    {
      'id': id,
      'title': title,
      'dueAt': dueAt,
      'clearDueAt': clearDueAt,
      'priority': priority,
      'status': status,
      'durationMinutes': durationMinutes,
    },
  );

  _ida.Future<void> deleteTask(int id) => caller.callServerEndpoint<void>(
    'tasks',
    'deleteTask',
    {'id': id},
  );

  /// Step 1 of rescheduling: PROPOSE a slot. Nothing is saved.
  /// Returns null when no free slot exists in the next two weeks.
  _ida.Future<_icbusygb.RescheduleProposal?> suggestReschedule(int taskId) =>
      caller.callServerEndpoint<_icbusygb.RescheduleProposal?>(
        'tasks',
        'suggestReschedule',
        {'taskId': taskId},
      );

  /// Step 2: the user accepted. The server re-checks everything before saving.
  _ida.Future<_i5n1037d.Task> rescheduleTask(
    int taskId,
    DateTime newStart,
  ) => caller.callServerEndpoint<_i5n1037d.Task>(
    'tasks',
    'rescheduleTask',
    {
      'taskId': taskId,
      'newStart': newStart,
    },
  );
}

/// Handles user authentication, registration, session checks, and dashboard metrics.
/// {@category Endpoint}
class EndpointUser extends _isc.EndpointRef {
  EndpointUser(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  /// Registers a new user account with hashed password stored in PostgreSQL.
  _ida.Future<_ihx9go0m.AuthResponse> register(
    String name,
    String email,
    String password,
  ) => caller.callServerEndpoint<_ihx9go0m.AuthResponse>(
    'user',
    'register',
    {
      'name': name,
      'email': email,
      'password': password,
    },
  );

  /// Authenticates an existing user against database credentials.
  _ida.Future<_ihx9go0m.AuthResponse> login(
    String email,
    String password,
  ) => caller.callServerEndpoint<_ihx9go0m.AuthResponse>(
    'user',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Returns aggregated statistics for the interactive dashboard.
  _ida.Future<_ilwy2lrs.DashboardStats> getDashboardStats() =>
      caller.callServerEndpoint<_ilwy2lrs.DashboardStats>(
        'user',
        'getDashboardStats',
        {},
      );

  /// Retrieves user profile by ID.
  _ida.Future<_iiv5ozhh.UserAccount?> getProfile(int userId) =>
      caller.callServerEndpoint<_iiv5ozhh.UserAccount?>(
        'user',
        'getProfile',
        {'userId': userId},
      );
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    ai = EndpointAi(this);
    mindMaps = EndpointMindMaps(this);
    notes = EndpointNotes(this);
    preferences = EndpointPreferences(this);
    tasks = EndpointTasks(this);
    user = EndpointUser(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointAi ai;

  late final EndpointMindMaps mindMaps;

  late final EndpointNotes notes;

  late final EndpointPreferences preferences;

  late final EndpointTasks tasks;

  late final EndpointUser user;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'ai': ai,
    'mindMaps': mindMaps,
    'notes': notes,
    'preferences': preferences,
    'tasks': tasks,
    'user': user,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
