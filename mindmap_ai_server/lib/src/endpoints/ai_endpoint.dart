import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/ai_parsers.dart';
import '../services/llm_client.dart';
import '../services/preferences_service.dart';
import '../services/prioritizer.dart';
import '../services/prompts.dart';
import '../services/suggestion_service.dart';
import '../services/validators.dart';
import '../services/voice_fallback_parser.dart';

import '../services/summary_fallback_parser.dart';

/// ai.summarizeText / processVoiceCommand / getDailySuggestion
///
/// The AI only INTERPRETS. Nothing here writes tasks or notes.
/// When the LLM is unavailable (no key, quota exhausted, network error),
/// all methods fall back to smart rule-based offline parsers automatically.
class AiEndpoint extends Endpoint {
  // Tiny cache so the home screen does not call the LLM on every refresh.
  static String? _lastFacts;
  static DailySuggestion? _lastSuggestion;

  Future<SummaryResult> summarizeText(Session session, String text) async {
    final clean = Validators.requireText(text, field: 'Text');
    final prefs = await PreferencesService.load(session);
    try {
      final json = await LlmClient(session).completeJson(
        system: Prompts.summarize(
          now: DateTime.now().toUtc(),
          offsetMinutes: prefs.timezoneOffsetMinutes,
        ),
        user: clean.length > 12000 ? clean.substring(0, 12000) : clean,
      );
      return AiParsers.summary(json);
    } on LlmException catch (e) {
      // LLM unavailable or quota exceeded — use offline extractive summarizer
      session.log(
        'summarizeText: LLM unavailable (${e.message}), using offline fallback.',
        level: LogLevel.warning,
      );
      return SummaryFallbackParser.parse(clean);
    } catch (e, stack) {
      session.log('summarizeText: unexpected error: $e',
          level: LogLevel.error, stackTrace: stack);
      return SummaryFallbackParser.parse(clean);
    }
  }

  Future<String> generateMindMap(Session session, String text) async {
    final clean = Validators.requireText(text, field: 'Topic or content');
    try {
      final json = await LlmClient(session).completeJson(
        system: Prompts.mindMap,
        user: clean,
      );
      return AiParsers.mindMap(json, originalText: clean);
    } on LlmException catch (e) {
      session.log(
        'generateMindMap: LLM unavailable (${e.message}), using offline fallback.',
        level: LogLevel.warning,
      );
      return AiParsers.mindMapFallback(clean);
    } catch (e, stack) {
      session.log('generateMindMap: unexpected error: $e',
          level: LogLevel.error, stackTrace: stack);
      return AiParsers.mindMapFallback(clean);
    }
  }

  Future<VoiceCommandResult> processVoiceCommand(Session session, String text) async {
    final clean = Validators.requireText(text, field: 'Spoken text', max: 2000);
    final prefs = await PreferencesService.load(session);
    try {
      final json = await LlmClient(session).completeJson(
        system: Prompts.voiceCommand(
          now: DateTime.now().toUtc(),
          offsetMinutes: prefs.timezoneOffsetMinutes,
        ),
        user: clean,
      );
      return AiParsers.voiceCommand(json, originalText: clean);
    } on LlmException catch (e) {
      session.log(
        'processVoiceCommand: LLM unavailable (${e.message}), using rule-based fallback.',
        level: LogLevel.warning,
      );
      return VoiceFallbackParser.parse(clean);
    } catch (e, stack) {
      session.log('processVoiceCommand: unexpected error: $e',
          level: LogLevel.error, stackTrace: stack);
      return VoiceFallbackParser.parse(clean);
    }
  }

  Future<DailySuggestion> getDailySuggestion(Session session) async {
    final now = DateTime.now().toUtc();
    final prefs = await PreferencesService.load(session);
    final pending = await Task.db.find(
      session,
      where: (t) => t.status.equals(TaskStatus.pending),
    );
    final ranked = Prioritizer.rank(pending, now);
    final offset = prefs.timezoneOffsetMinutes;

    final fallback = DailySuggestion(
      message: SuggestionService.ruleBased(ranked, now, offset),
      generatedByAi: false,
    );
    if (ranked.isEmpty) return fallback;

    final facts = SuggestionService.facts(ranked.take(8), now, offset);
    if (facts == _lastFacts && _lastSuggestion != null) return _lastSuggestion!;

    try {
      final json = await LlmClient(session).completeJson(
        system: Prompts.dailySuggestion,
        user: facts,
      );
      final suggestion = DailySuggestion(
        message: AiParsers.suggestion(json),
        generatedByAi: true,
      );
      _lastFacts = facts;
      _lastSuggestion = suggestion;
      return suggestion;
    } on LlmException catch (e) {
      session.log(
        'getDailySuggestion: LLM unavailable (${e.message}), using rule-based fallback.',
        level: LogLevel.warning,
      );
      return fallback;
    } catch (e, stack) {
      session.log('getDailySuggestion: unexpected error: $e',
          level: LogLevel.error, stackTrace: stack);
      return fallback;
    }
  }
}
