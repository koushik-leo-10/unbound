import 'package:speech_to_text/speech_to_text.dart';

/// Small wrapper around the speech_to_text package.
class SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _ready = false;

  bool get isListening => _speech.isListening;

  /// Asks for microphone permission and prepares recognition.
  Future<bool> init({
    void Function(String status)? onStatus,
    void Function(String error)? onError,
  }) async {
    _ready = await _speech.initialize(
      onStatus: onStatus,
      onError: (error) => onError?.call(error.errorMsg),
    );
    return _ready;
  }

  /// [onResult] receives partial text while speaking and the final text last.
  Future<void> start({
    required void Function(String text, bool isFinal) onResult,
  }) async {
    if (!_ready) return;
    await _speech.listen(
      onResult: (result) => onResult(result.recognizedWords, result.finalResult),
      listenOptions: SpeechListenOptions(
        listenFor: const Duration(minutes: 2),
        pauseFor: const Duration(seconds: 5),
      ),
    );
  }

  Future<void> stop() => _speech.stop();

  Future<void> dispose() => _speech.cancel();
}
