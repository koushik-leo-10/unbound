import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

enum TtsStatus { stopped, playing, paused }

enum VoiceGender { female, male }

/// Definition of an AI voice character with distinct tone, persona, and voice mapping.
class VoicePersona {
  final String id;
  final String name;
  final VoiceGender gender;
  final String role;
  final double pitch;
  final double rateModifier;
  final String greeting;

  const VoicePersona({
    required this.id,
    required this.name,
    required this.gender,
    required this.role,
    required this.pitch,
    this.rateModifier = 1.0,
    required this.greeting,
  });
}

/// Text-to-speech service with 5 distinct AI voice personas (3 females, 2 males)
/// and configurable speeds (0.25x, 0.5x, 1.0x, 1.25x, 1.5x, 2.0x).
class TtsService extends ChangeNotifier {
  TtsService._internal() {
    _initTts();
  }

  static final TtsService instance = TtsService._internal();

  // 5 AI Voice Personas: 3 Females and 2 Males
  static const List<VoicePersona> personas = [
    VoicePersona(
      id: 'aria',
      name: 'Aria',
      gender: VoiceGender.female,
      role: 'Clear & Executive',
      pitch: 1.15,
      rateModifier: 1.0,
      greeting: "Hello, I'm Aria, your executive AI briefing assistant.",
    ),
    VoicePersona(
      id: 'serena',
      name: 'Serena',
      gender: VoiceGender.female,
      role: 'Calm & Soothing',
      pitch: 0.92,
      rateModifier: 0.90,
      greeting: "Hi, I'm Serena. Let's take our time and review your summary.",
    ),
    VoicePersona(
      id: 'nova',
      name: 'Nova',
      gender: VoiceGender.female,
      role: 'Dynamic & Upbeat',
      pitch: 1.32,
      rateModifier: 1.10,
      greeting: "Hey there! I'm Nova, ready with your fast-paced briefing!",
    ),
    VoicePersona(
      id: 'marcus',
      name: 'Marcus',
      gender: VoiceGender.male,
      role: 'Deep & Authoritative',
      pitch: 0.72,
      rateModifier: 0.95,
      greeting: "Greetings. I'm Marcus. Here is your structured debriefing.",
    ),
    VoicePersona(
      id: 'leo',
      name: 'Leo',
      gender: VoiceGender.male,
      role: 'Warm & Conversational',
      pitch: 1.08,
      rateModifier: 1.05,
      greeting: "Hey! Leo here. Let's walk through what this document says.",
    ),
  ];

  // Available speed options
  static const List<double> availableSpeeds = [0.25, 0.5, 1.0, 1.25, 1.5, 2.0];

  final FlutterTts _tts = FlutterTts();
  TtsStatus _status = TtsStatus.stopped;
  String _currentText = '';
  double _currentSpeed = 1.0; // Multiplier: 0.25, 0.5, 1.0, 1.25, 1.5, 2.0
  VoicePersona _currentPersona = personas[0]; // Default: Aria
  List<Map<String, String>> _systemVoices = [];
  String? _errorMessage;
  bool _isLoadingVoices = false;

  TtsStatus get status => _status;
  bool get isPlaying => _status == TtsStatus.playing;
  bool get isPaused => _status == TtsStatus.paused;
  bool get isStopped => _status == TtsStatus.stopped;
  String get currentText => _currentText;
  double get currentSpeed => _currentSpeed;
  VoicePersona get currentPersona => _currentPersona;
  List<Map<String, String>> get systemVoices => _systemVoices;
  String? get errorMessage => _errorMessage;

  /// Effective speech rate for the underlying TTS engine (0.05 to 1.0)
  double get _effectiveRate {
    final base = 0.5 * _currentSpeed * _currentPersona.rateModifier;
    return base.clamp(0.05, 1.0);
  }

  void _initTts() {
    try {
      _tts.setStartHandler(() {
        _status = TtsStatus.playing;
        _errorMessage = null;
        notifyListeners();
      });

      _tts.setCompletionHandler(() {
        _status = TtsStatus.stopped;
        notifyListeners();
      });

      _tts.setCancelHandler(() {
        _status = TtsStatus.stopped;
        notifyListeners();
      });

      _tts.setPauseHandler(() {
        _status = TtsStatus.paused;
        notifyListeners();
      });

      _tts.setContinueHandler(() {
        _status = TtsStatus.playing;
        notifyListeners();
      });

      _tts.setErrorHandler((dynamic msg) {
        _status = TtsStatus.stopped;
        _errorMessage = msg?.toString() ?? 'Speech synthesis error';
        notifyListeners();
      });

      _tts.setVolume(1.0);

      // Asynchronously fetch voices, polling until browser voices ready
      ensureVoicesLoaded();
    } catch (e) {
      debugPrint('Failed to initialize FlutterTts: $e');
    }
  }

  /// Polls for available browser/OS voices until available
  Future<void> ensureVoicesLoaded() async {
    if (_systemVoices.isNotEmpty || _isLoadingVoices) return;
    _isLoadingVoices = true;

    for (int i = 0; i < 10; i++) {
      try {
        final voices = await _tts.getVoices;
        if (voices is List && voices.isNotEmpty) {
          _systemVoices = voices.map((v) {
            final map = v as Map;
            return {
              'name': (map['name'] ?? '').toString(),
              'locale': (map['locale'] ?? '').toString(),
            };
          }).toList();
          debugPrint('TtsService: Loaded ${_systemVoices.length} voices.');
          _isLoadingVoices = false;
          notifyListeners();
          return;
        }
      } catch (e) {
        debugPrint('Error polling voices: $e');
      }
      await Future.delayed(const Duration(milliseconds: 250));
    }
    _isLoadingVoices = false;
  }

  /// Returns the name of the system voice mapped to a persona
  String getAssignedVoiceName(VoicePersona persona) {
    final voice = _findBestVoiceForPersona(persona);
    return voice?['name'] ?? (persona.gender == VoiceGender.female ? 'Female Voice' : 'Male Voice');
  }

  /// Selects a persona and applies its voice and pitch profile.
  Future<void> setPersona(VoicePersona persona, {bool playSample = false}) async {
    _currentPersona = persona;
    await _applyVoiceAndPitch();
    notifyListeners();

    if (isPlaying && _currentText.isNotEmpty) {
      await speak(_currentText);
    } else if (playSample) {
      await speak(persona.greeting);
    }
  }

  /// Sets playback speed multiplier (0.25x, 0.5x, 1.0x, 1.25x, 1.5x, 2.0x).
  Future<void> setSpeed(double speedMultiplier) async {
    _currentSpeed = speedMultiplier;
    try {
      await _tts.setSpeechRate(_effectiveRate);
    } catch (_) {}
    notifyListeners();

    if (isPlaying && _currentText.isNotEmpty) {
      await speak(_currentText);
    }
  }

  Future<void> _applyVoiceAndPitch() async {
    try {
      if (_systemVoices.isEmpty) {
        await ensureVoicesLoaded();
      }

      final chosenVoice = _findBestVoiceForPersona(_currentPersona);
      if (chosenVoice != null) {
        await _tts.setVoice({
          'name': chosenVoice['name']!,
          'locale': chosenVoice['locale']!,
        });
        debugPrint('Applied voice: ${chosenVoice["name"]} for ${_currentPersona.name}');
      }

      await _tts.setPitch(_currentPersona.pitch);
      await _tts.setSpeechRate(_effectiveRate);
    } catch (e) {
      debugPrint('Error applying voice parameters: $e');
    }
  }

  Map<String, String>? _findBestVoiceForPersona(VoicePersona persona) {
    if (_systemVoices.isEmpty) return null;

    final isFemaleTarget = persona.gender == VoiceGender.female;

    // Filter English voices
    final englishVoices = _systemVoices.where((v) {
      final locale = (v['locale'] ?? '').toLowerCase();
      final name = (v['name'] ?? '').toLowerCase();
      return locale.startsWith('en') ||
          name.contains('english') ||
          name.contains('us') ||
          name.contains('uk');
    }).toList();

    final pool = englishVoices.isNotEmpty ? englishVoices : _systemVoices;

    final femaleVoices = pool.where((v) => _isFemaleVoiceName(v['name'] ?? '')).toList();
    final maleVoices = pool.where((v) => _isMaleVoiceName(v['name'] ?? '')).toList();

    if (isFemaleTarget) {
      // 3 females: Aria (index 0), Serena (index 1), Nova (index 2)
      if (femaleVoices.isNotEmpty) {
        if (persona.id == 'aria') {
          return femaleVoices[0];
        } else if (persona.id == 'serena') {
          return femaleVoices.length > 1 ? femaleVoices[1] : femaleVoices[0];
        } else if (persona.id == 'nova') {
          return femaleVoices.length > 2 ? femaleVoices[2] : femaleVoices.last;
        }
        return femaleVoices[0];
      }
      // If no explicit female name match, choose any voice not matching male keywords
      final nonMale = pool.where((v) => !_isMaleVoiceName(v['name'] ?? '')).toList();
      if (nonMale.isNotEmpty) return nonMale.first;
      return pool.first;
    } else {
      // 2 males: Marcus (index 0), Leo (index 1)
      if (maleVoices.isNotEmpty) {
        if (persona.id == 'marcus') {
          return maleVoices[0];
        } else if (persona.id == 'leo') {
          return maleVoices.length > 1 ? maleVoices[1] : maleVoices[0];
        }
        return maleVoices[0];
      }
      // If no explicit male name match, choose any voice not matching female keywords
      final nonFemale = pool.where((v) => !_isFemaleVoiceName(v['name'] ?? '')).toList();
      if (nonFemale.isNotEmpty) return nonFemale.first;
      return pool.first;
    }
  }

  static bool _isFemaleVoiceName(String name) {
    final lower = name.toLowerCase();
    return lower.contains('zira') ||
        lower.contains('google us english') ||
        lower.contains('female') ||
        lower.contains('woman') ||
        lower.contains('aria') ||
        lower.contains('jenny') ||
        lower.contains('samantha') ||
        lower.contains('victoria') ||
        lower.contains('karen') ||
        lower.contains('susan') ||
        lower.contains('hazel') ||
        lower.contains('cora') ||
        lower.contains('ava') ||
        lower.contains('heather') ||
        lower.contains('linda') ||
        lower.contains('stephanie');
  }

  static bool _isMaleVoiceName(String name) {
    final lower = name.toLowerCase();
    return lower.contains('david') ||
        lower.contains('mark') ||
        lower.contains('guy') ||
        lower.contains('male') ||
        lower.contains('man') ||
        lower.contains('george') ||
        lower.contains('daniel') ||
        lower.contains('alex') ||
        lower.contains('richard') ||
        lower.contains('james') ||
        lower.contains('tom') ||
        lower.contains('fred');
  }

  /// Converts bulleted summaries into a fluent, conversational audio narrative.
  static String generateSpokenBriefing({
    required String summary,
    List<String> keyPoints = const [],
    List<String> actionItems = const [],
    String? sourceTitle,
  }) {
    final buffer = StringBuffer();

    // Intro greeting
    if (sourceTitle != null && sourceTitle.trim().isNotEmpty) {
      buffer.writeln('Here is your AI briefing for $sourceTitle.');
    } else {
      buffer.writeln('Here is your AI summary briefing.');
    }

    // Core summary
    final cleanSummary = summary.replaceAll(RegExp(r'[\r\n]+'), ' ').trim();
    if (cleanSummary.isNotEmpty) {
      buffer.writeln(cleanSummary);
    }

    // Key points
    final cleanPoints = keyPoints.where((p) => p.trim().isNotEmpty).toList();
    if (cleanPoints.isNotEmpty) {
      buffer.writeln('Key highlights include the following.');
      for (var i = 0; i < cleanPoints.length; i++) {
        final point = cleanPoints[i].replaceAll(RegExp(r'^[\-\*\•\d\.\s]+'), '').trim();
        buffer.writeln('Point ${i + 1}: $point.');
      }
    }

    // Action items
    final cleanActions = actionItems.where((a) => a.trim().isNotEmpty).toList();
    if (cleanActions.isNotEmpty) {
      buffer.writeln('Recommended action items.');
      for (var i = 0; i < cleanActions.length; i++) {
        final action = cleanActions[i].replaceAll(RegExp(r'^[\-\*\•\d\.\s]+'), '').trim();
        buffer.writeln('Action ${i + 1}: $action.');
      }
    }

    // Outro
    buffer.writeln('That concludes your executive summary.');

    return buffer.toString();
  }

  /// Speaks the provided text aloud using current persona and speed.
  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;

    try {
      if (_status == TtsStatus.playing) {
        await _tts.stop();
      }

      _currentText = text;
      _status = TtsStatus.playing;
      _errorMessage = null;
      notifyListeners();

      await _applyVoiceAndPitch();
      await _tts.speak(text);
    } catch (e) {
      _status = TtsStatus.stopped;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Pauses current speech.
  Future<void> pause() async {
    try {
      await _tts.pause();
      _status = TtsStatus.paused;
      notifyListeners();
    } catch (e) {
      await stop();
    }
  }

  /// Resumes from pause.
  Future<void> resume() async {
    if (_status == TtsStatus.paused && _currentText.isNotEmpty) {
      try {
        await _tts.speak(_currentText);
        _status = TtsStatus.playing;
        notifyListeners();
      } catch (e) {
        await speak(_currentText);
      }
    }
  }

  /// Stops speech completely.
  Future<void> stop() async {
    try {
      await _tts.stop();
    } catch (_) {}
    _status = TtsStatus.stopped;
    notifyListeners();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
