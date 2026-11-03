import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

/// Internal exception thrown by [LlmClient] when the AI service fails.
/// Unlike [AppException], this is a plain Dart exception that CAN be caught
/// inside Serverpod endpoint methods before the framework intercepts it.
class LlmException implements Exception {
  const LlmException(this.message);
  final String message;

  @override
  String toString() => 'LlmException: $message';
}

/// Thin wrapper around an OpenAI or Gemini chat-completions API.
/// Reads openAiApiKey or geminiApiKey from config/passwords.yaml.
class LlmClient {
  LlmClient(this._session);

  final Session _session;

  static const String _openaiEndpoint = 'https://api.openai.com/v1/chat/completions';
  static const String _openaiModel = 'gpt-4o-mini';
  static const Duration _timeout = Duration(seconds: 30);

  String? get _openAiKey => _session.passwords['openAiApiKey'];
  String? get _geminiKey => _session.passwords['geminiApiKey'];

  /// Sends [system] + [user] prompts and returns the parsed JSON object.
  /// Throws [LlmException] on any failure — use this in endpoints with
  /// `on LlmException catch(e) { ... }` so the fallback logic can run.
  Future<Map<String, dynamic>> completeJson({
    required String system,
    required String user,
  }) async {
    // 1. Try OpenAI if configured
    final openAiKey = _openAiKey;
    if (openAiKey != null && openAiKey.isNotEmpty && openAiKey != 'PASTE_YOUR_KEY_HERE') {
      try {
        return await _callOpenAi(openAiKey, system: system, user: user);
      } on LlmException catch (e) {
        _session.log('OpenAI failed: ${e.message}, checking Gemini fallback...',
            level: LogLevel.warning);
        // Fall through to Gemini only if Gemini key exists
        final geminiKey = _geminiKey;
        if (geminiKey == null || geminiKey.isEmpty) rethrow;
      }
    }

    // 2. Try Gemini if configured
    final geminiKey = _geminiKey;
    if (geminiKey != null && geminiKey.isNotEmpty) {
      return await _callGemini(geminiKey, system: system, user: user);
    }

    throw const LlmException(
      'No AI key configured. Please add openAiApiKey or geminiApiKey to config/passwords.yaml.',
    );
  }

  Future<Map<String, dynamic>> _callOpenAi(
    String apiKey, {
    required String system,
    required String user,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse(_openaiEndpoint),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
            },
            body: jsonEncode({
              'model': _openaiModel,
              'temperature': 0.2,
              'response_format': {'type': 'json_object'},
              'messages': [
                {'role': 'system', 'content': system},
                {'role': 'user', 'content': user},
              ],
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 429) {
        _session.log('OpenAI 429 – quota/rate limit hit: ${response.body}',
            level: LogLevel.warning);
        throw const LlmException('OpenAI quota or rate limit reached (429).');
      }

      if (response.statusCode != 200) {
        _session.log(
          'OpenAI error ${response.statusCode}: ${response.body}',
          level: LogLevel.error,
        );
        throw LlmException('OpenAI returned HTTP ${response.statusCode}.');
      }

      final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final content = body['choices'][0]['message']['content'] as String;
      final parsed = jsonDecode(content);
      if (parsed is! Map<String, dynamic>) {
        throw const LlmException('OpenAI response was not a JSON object.');
      }
      return parsed;
    } on LlmException {
      rethrow;
    } on TimeoutException {
      throw const LlmException('OpenAI timed out after 30 seconds.');
    } on FormatException catch (e) {
      _session.log('OpenAI JSON parse error: $e', level: LogLevel.error);
      throw const LlmException('OpenAI returned unreadable JSON.');
    } catch (e, stack) {
      _session.log('OpenAI request crashed: $e', level: LogLevel.error, stackTrace: stack);
      throw LlmException('OpenAI network error: $e');
    }
  }

  Future<Map<String, dynamic>> _callGemini(
    String apiKey, {
    required String system,
    required String user,
  }) async {
    try {
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey',
      );
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'contents': [
                {
                  'role': 'user',
                  'parts': [
                    {'text': '$system\n\nUser Data:\n$user'},
                  ],
                },
              ],
              'generationConfig': {
                'responseMimeType': 'application/json',
                'temperature': 0.2,
              },
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 429) {
        _session.log('Gemini 429 – rate limit: ${response.body}', level: LogLevel.warning);
        throw const LlmException('Gemini rate limit reached (429).');
      }

      if (response.statusCode != 200) {
        _session.log('Gemini error ${response.statusCode}: ${response.body}',
            level: LogLevel.error);
        throw LlmException('Gemini returned HTTP ${response.statusCode}.');
      }

      final body = jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      final text = body['candidates'][0]['content']['parts'][0]['text'] as String;
      final parsed = jsonDecode(text);
      if (parsed is! Map<String, dynamic>) {
        throw const LlmException('Gemini output was not a JSON object.');
      }
      return parsed;
    } on LlmException {
      rethrow;
    } on TimeoutException {
      throw const LlmException('Gemini timed out after 30 seconds.');
    } catch (e, stack) {
      _session.log('Gemini request failed: $e', level: LogLevel.error, stackTrace: stack);
      throw LlmException('Gemini network error: $e');
    }
  }
}
