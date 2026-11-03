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
import 'package:mindmap_ai_server/src/generated/task_priority.dart'
    as _iuqhm6ic;
import 'package:mindmap_ai_server/src/generated/task_status.dart' as _i8mr7o3q;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _iais;
import '../auth/email_idp_endpoint.dart' as _iuc1hd5t;
import '../auth/jwt_refresh_endpoint.dart' as _inwq3ztq;
import '../endpoints/ai_endpoint.dart' as _igsjf4zh;
import '../endpoints/mind_maps_endpoint.dart' as _i04nr2ff;
import '../endpoints/notes_endpoint.dart' as _i8cgu3er;
import '../endpoints/preferences_endpoint.dart' as _i43wviq4;
import '../endpoints/tasks_endpoint.dart' as _i736xm66;
import '../endpoints/user_endpoint.dart' as _iymy5306;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'emailIdp': _iuc1hd5t.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _inwq3ztq.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'ai': _igsjf4zh.AiEndpoint()
        ..initialize(
          server,
          'ai',
          null,
        ),
      'mindMaps': _i04nr2ff.MindMapsEndpoint()
        ..initialize(
          server,
          'mindMaps',
          null,
        ),
      'notes': _i8cgu3er.NotesEndpoint()
        ..initialize(
          server,
          'notes',
          null,
        ),
      'preferences': _i43wviq4.PreferencesEndpoint()
        ..initialize(
          server,
          'preferences',
          null,
        ),
      'tasks': _i736xm66.TasksEndpoint()
        ..initialize(
          server,
          'tasks',
          null,
        ),
      'user': _iymy5306.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
    };
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint).login(
                    session,
                    email: params['email'],
                    password: params['password'],
                  ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iuc1hd5t.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _is.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['jwtRefresh'] as _inwq3ztq.JwtRefreshEndpoint)
                      .refreshAccessToken(
                        session,
                        refreshToken: params['refreshToken'],
                      ),
        ),
      },
    );
    connectors['ai'] = _is.EndpointConnector(
      name: 'ai',
      endpoint: endpoints['ai']!,
      methodConnectors: {
        'summarizeText': _is.MethodConnector(
          name: 'summarizeText',
          params: {
            'text': _is.ParameterDescription(
              name: 'text',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['ai'] as _igsjf4zh.AiEndpoint).summarizeText(
                    session,
                    params['text'],
                  ),
        ),
        'generateMindMap': _is.MethodConnector(
          name: 'generateMindMap',
          params: {
            'text': _is.ParameterDescription(
              name: 'text',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['ai'] as _igsjf4zh.AiEndpoint).generateMindMap(
                    session,
                    params['text'],
                  ),
        ),
        'processVoiceCommand': _is.MethodConnector(
          name: 'processVoiceCommand',
          params: {
            'text': _is.ParameterDescription(
              name: 'text',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['ai'] as _igsjf4zh.AiEndpoint).processVoiceCommand(
                    session,
                    params['text'],
                  ),
        ),
        'getDailySuggestion': _is.MethodConnector(
          name: 'getDailySuggestion',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ai'] as _igsjf4zh.AiEndpoint)
                  .getDailySuggestion(session),
        ),
      },
    );
    connectors['mindMaps'] = _is.EndpointConnector(
      name: 'mindMaps',
      endpoint: endpoints['mindMaps']!,
      methodConnectors: {
        'createMindMap': _is.MethodConnector(
          name: 'createMindMap',
          params: {
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'rootNodeJson': _is.ParameterDescription(
              name: 'rootNodeJson',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'sourceNoteId': _is.ParameterDescription(
              name: 'sourceNoteId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['mindMaps'] as _i04nr2ff.MindMapsEndpoint)
                  .createMindMap(
                    session,
                    params['title'],
                    params['rootNodeJson'],
                    sourceNoteId: params['sourceNoteId'],
                    userId: params['userId'],
                  ),
        ),
        'getMindMaps': _is.MethodConnector(
          name: 'getMindMaps',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['mindMaps'] as _i04nr2ff.MindMapsEndpoint)
                  .getMindMaps(
                    session,
                    userId: params['userId'],
                  ),
        ),
        'getMindMap': _is.MethodConnector(
          name: 'getMindMap',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['mindMaps'] as _i04nr2ff.MindMapsEndpoint)
                  .getMindMap(
                    session,
                    params['id'],
                  ),
        ),
        'updateMindMap': _is.MethodConnector(
          name: 'updateMindMap',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'rootNodeJson': _is.ParameterDescription(
              name: 'rootNodeJson',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['mindMaps'] as _i04nr2ff.MindMapsEndpoint)
                  .updateMindMap(
                    session,
                    params['id'],
                    params['title'],
                    params['rootNodeJson'],
                  ),
        ),
        'deleteMindMap': _is.MethodConnector(
          name: 'deleteMindMap',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['mindMaps'] as _i04nr2ff.MindMapsEndpoint)
                  .deleteMindMap(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['notes'] = _is.EndpointConnector(
      name: 'notes',
      endpoint: endpoints['notes']!,
      methodConnectors: {
        'createNote': _is.MethodConnector(
          name: 'createNote',
          params: {
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'content': _is.ParameterDescription(
              name: 'content',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notes'] as _i8cgu3er.NotesEndpoint).createNote(
                    session,
                    params['title'],
                    params['content'],
                  ),
        ),
        'getNotes': _is.MethodConnector(
          name: 'getNotes',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['notes'] as _i8cgu3er.NotesEndpoint)
                  .getNotes(session),
        ),
        'updateNote': _is.MethodConnector(
          name: 'updateNote',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'content': _is.ParameterDescription(
              name: 'content',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'summary': _is.ParameterDescription(
              name: 'summary',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notes'] as _i8cgu3er.NotesEndpoint).updateNote(
                    session,
                    params['id'],
                    params['title'],
                    params['content'],
                    summary: params['summary'],
                  ),
        ),
        'deleteNote': _is.MethodConnector(
          name: 'deleteNote',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notes'] as _i8cgu3er.NotesEndpoint).deleteNote(
                    session,
                    params['id'],
                  ),
        ),
      },
    );
    connectors['preferences'] = _is.EndpointConnector(
      name: 'preferences',
      endpoint: endpoints['preferences']!,
      methodConnectors: {
        'getPreferences': _is.MethodConnector(
          name: 'getPreferences',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['preferences'] as _i43wviq4.PreferencesEndpoint)
                      .getPreferences(session),
        ),
        'savePreferences': _is.MethodConnector(
          name: 'savePreferences',
          params: {
            'workingDayStartMinutes': _is.ParameterDescription(
              name: 'workingDayStartMinutes',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'workingDayEndMinutes': _is.ParameterDescription(
              name: 'workingDayEndMinutes',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'breakMinutes': _is.ParameterDescription(
              name: 'breakMinutes',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'timezone': _is.ParameterDescription(
              name: 'timezone',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'timezoneOffsetMinutes': _is.ParameterDescription(
              name: 'timezoneOffsetMinutes',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['preferences'] as _i43wviq4.PreferencesEndpoint)
                      .savePreferences(
                        session,
                        params['workingDayStartMinutes'],
                        params['workingDayEndMinutes'],
                        params['breakMinutes'],
                        params['timezone'],
                        params['timezoneOffsetMinutes'],
                      ),
        ),
      },
    );
    connectors['tasks'] = _is.EndpointConnector(
      name: 'tasks',
      endpoint: endpoints['tasks']!,
      methodConnectors: {
        'createTask': _is.MethodConnector(
          name: 'createTask',
          params: {
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'priority': _is.ParameterDescription(
              name: 'priority',
              type: _is.getType<_iuqhm6ic.TaskPriority>(),
              nullable: false,
            ),
            'durationMinutes': _is.ParameterDescription(
              name: 'durationMinutes',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'dueAt': _is.ParameterDescription(
              name: 'dueAt',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'sourceNoteId': _is.ParameterDescription(
              name: 'sourceNoteId',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['tasks'] as _i736xm66.TasksEndpoint).createTask(
                    session,
                    params['title'],
                    params['priority'],
                    params['durationMinutes'],
                    dueAt: params['dueAt'],
                    sourceNoteId: params['sourceNoteId'],
                  ),
        ),
        'getTasks': _is.MethodConnector(
          name: 'getTasks',
          params: {
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<_i8mr7o3q.TaskStatus?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['tasks'] as _i736xm66.TasksEndpoint).getTasks(
                    session,
                    status: params['status'],
                  ),
        ),
        'getOverdueTasks': _is.MethodConnector(
          name: 'getOverdueTasks',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tasks'] as _i736xm66.TasksEndpoint)
                  .getOverdueTasks(session),
        ),
        'getPrioritizedTasks': _is.MethodConnector(
          name: 'getPrioritizedTasks',
          params: {
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tasks'] as _i736xm66.TasksEndpoint)
                  .getPrioritizedTasks(
                    session,
                    limit: params['limit'],
                  ),
        ),
        'updateTask': _is.MethodConnector(
          name: 'updateTask',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'title': _is.ParameterDescription(
              name: 'title',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'dueAt': _is.ParameterDescription(
              name: 'dueAt',
              type: _is.getType<DateTime?>(),
              nullable: true,
            ),
            'clearDueAt': _is.ParameterDescription(
              name: 'clearDueAt',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
            'priority': _is.ParameterDescription(
              name: 'priority',
              type: _is.getType<_iuqhm6ic.TaskPriority?>(),
              nullable: true,
            ),
            'status': _is.ParameterDescription(
              name: 'status',
              type: _is.getType<_i8mr7o3q.TaskStatus?>(),
              nullable: true,
            ),
            'durationMinutes': _is.ParameterDescription(
              name: 'durationMinutes',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['tasks'] as _i736xm66.TasksEndpoint).updateTask(
                    session,
                    params['id'],
                    title: params['title'],
                    dueAt: params['dueAt'],
                    clearDueAt: params['clearDueAt'],
                    priority: params['priority'],
                    status: params['status'],
                    durationMinutes: params['durationMinutes'],
                  ),
        ),
        'deleteTask': _is.MethodConnector(
          name: 'deleteTask',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['tasks'] as _i736xm66.TasksEndpoint).deleteTask(
                    session,
                    params['id'],
                  ),
        ),
        'suggestReschedule': _is.MethodConnector(
          name: 'suggestReschedule',
          params: {
            'taskId': _is.ParameterDescription(
              name: 'taskId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tasks'] as _i736xm66.TasksEndpoint)
                  .suggestReschedule(
                    session,
                    params['taskId'],
                  ),
        ),
        'rescheduleTask': _is.MethodConnector(
          name: 'rescheduleTask',
          params: {
            'taskId': _is.ParameterDescription(
              name: 'taskId',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'newStart': _is.ParameterDescription(
              name: 'newStart',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['tasks'] as _i736xm66.TasksEndpoint)
                  .rescheduleTask(
                    session,
                    params['taskId'],
                    params['newStart'],
                  ),
        ),
      },
    );
    connectors['user'] = _is.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'register': _is.MethodConnector(
          name: 'register',
          params: {
            'name': _is.ParameterDescription(
              name: 'name',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _iymy5306.UserEndpoint).register(
                session,
                params['name'],
                params['email'],
                params['password'],
              ),
        ),
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _iymy5306.UserEndpoint).login(
                session,
                params['email'],
                params['password'],
              ),
        ),
        'getDashboardStats': _is.MethodConnector(
          name: 'getDashboardStats',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _iymy5306.UserEndpoint)
                  .getDashboardStats(session),
        ),
        'getProfile': _is.MethodConnector(
          name: 'getProfile',
          params: {
            'userId': _is.ParameterDescription(
              name: 'userId',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _iymy5306.UserEndpoint).getProfile(
                    session,
                    params['userId'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()
      ..initializeEndpoints(server);
  }
}
