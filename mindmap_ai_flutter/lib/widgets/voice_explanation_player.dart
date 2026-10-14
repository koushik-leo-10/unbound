import 'dart:math';
import 'package:flutter/material.dart';
import '../services/tts_service.dart';

/// An interactive, beautifully styled AI Voice Player featuring:
/// - 5 AI Voice Personas (3 Females: Aria, Serena, Nova; 2 Males: Marcus, Leo)
/// - Precision Speed Controls (0.25x, 0.5x, 1.0x, 1.25x, 1.5x, 2.0x)
/// - Equalizer audio waveform animation
/// - Full Play / Pause / Resume / Stop controls
/// - Instant voice auditioning on character select
/// - Expandable Spoken Script Viewer
class VoiceExplanationPlayer extends StatefulWidget {
  const VoiceExplanationPlayer({
    super.key,
    required this.spokenText,
    this.title = 'AI Voice Briefing',
    this.onClose,
  });

  final String spokenText;
  final String title;
  final VoidCallback? onClose;

  @override
  State<VoiceExplanationPlayer> createState() => _VoiceExplanationPlayerState();
}

class _VoiceExplanationPlayerState extends State<VoiceExplanationPlayer>
    with SingleTickerProviderStateMixin {
  final TtsService _tts = TtsService.instance;
  late AnimationController _animController;
  bool _showTranscript = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _tts.addListener(_onTtsChange);
    _tts.ensureVoicesLoaded();
  }

  void _onTtsChange() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tts.removeListener(_onTtsChange);
    _animController.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_tts.isPlaying) {
      _tts.pause();
    } else if (_tts.isPaused) {
      _tts.resume();
    } else {
      _tts.speak(widget.spokenText);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPlaying = _tts.isPlaying;
    final isPaused = _tts.isPaused;
    final activePersona = _tts.currentPersona;
    final assignedVoice = _tts.getAssignedVoiceName(activePersona);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            colorScheme.primaryContainer.withValues(alpha: 0.85),
            colorScheme.surfaceContainerHighest.withValues(alpha: 0.95),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isPlaying
              ? colorScheme.primary.withValues(alpha: 0.6)
              : colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: isPlaying ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isPlaying
                ? colorScheme.primary.withValues(alpha: 0.18)
                : Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar: Active Avatar, Title, Status & Close
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: activePersona.gender == VoiceGender.female
                        ? Colors.pink.shade600
                        : Colors.indigo.shade600,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying
                        ? Icons.graphic_eq_rounded
                        : activePersona.gender == VoiceGender.female
                            ? Icons.face_3_rounded
                            : Icons.face_6_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        isPlaying
                            ? '${activePersona.name} is explaining...'
                            : isPaused
                                ? 'Paused (${activePersona.name})'
                                : '${activePersona.name} (${activePersona.role}) · $assignedVoice',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: isPlaying
                              ? colorScheme.primary
                              : colorScheme.onSurfaceVariant,
                          fontWeight: isPlaying ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.onClose != null)
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    tooltip: 'Close voice player',
                    onPressed: () {
                      _tts.stop();
                      widget.onClose?.call();
                    },
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // 5 Voice Personas Selection Bar (3 Females, 2 Males)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select AI Voice Character (Tap to audition)',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  activePersona.gender == VoiceGender.female ? 'Female Voice' : 'Male Voice',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: activePersona.gender == VoiceGender.female
                        ? Colors.pink.shade700
                        : Colors.indigo.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: TtsService.personas.map((persona) {
                  final isSelected = persona.id == activePersona.id;
                  final isFemale = persona.gender == VoiceGender.female;
                  final accentColor = isFemale ? Colors.pink : Colors.indigo;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          _tts.setPersona(persona, playSample: !_tts.isPlaying);
                        }
                      },
                      avatar: Icon(
                        isFemale ? Icons.woman_rounded : Icons.man_rounded,
                        size: 18,
                        color: isSelected
                            ? Colors.white
                            : accentColor.shade400,
                      ),
                      label: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                persona.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : null,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isFemale ? '[F]' : '[M]',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? Colors.white70
                                      : accentColor.shade400,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            persona.role,
                            style: TextStyle(
                              fontSize: 10,
                              color: isSelected ? Colors.white70 : colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                      selectedColor: accentColor.shade600,
                      backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.6),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 12),

            // Animated Waveform
            if (isPlaying) ...[
              _buildWaveform(activePersona.gender == VoiceGender.female
                  ? Colors.pink.shade400
                  : colorScheme.primary),
              const SizedBox(height: 12),
            ],

            // Player Controls & Speed Selector Row
            Row(
              children: [
                // Play / Pause Button
                FilledButton.icon(
                  onPressed: _togglePlayPause,
                  icon: Icon(
                    isPlaying
                        ? Icons.pause_rounded
                        : isPaused
                            ? Icons.play_arrow_rounded
                            : Icons.volume_up_rounded,
                    size: 20,
                  ),
                  label: Text(
                    isPlaying
                        ? 'Pause'
                        : isPaused
                            ? 'Resume'
                            : 'Listen',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                // Stop Button
                if (isPlaying || isPaused)
                  OutlinedButton.icon(
                    onPressed: () => _tts.stop(),
                    icon: const Icon(Icons.stop_rounded, size: 18),
                    label: const Text('Stop'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),

                const Spacer(),

                // Speed Selector Pill (0.25x, 0.5x, 1.0x, 1.25x, 1.5x, 2.0x)
                _buildSpeedSelector(context),
              ],
            ),

            if (_tts.errorMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                'Note: ${_tts.errorMessage}',
                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.error),
              ),
            ],

            // Transcript Accordion Toggle
            const SizedBox(height: 10),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () => setState(() => _showTranscript = !_showTranscript),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _showTranscript
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _showTranscript ? 'Hide Spoken Script' : 'View Spoken Script',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_showTranscript) ...[
              const SizedBox(height: 6),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.surface.withValues(alpha: 0.7),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                ),
                child: SelectableText(
                  widget.spokenText,
                  style: theme.textTheme.bodySmall?.copyWith(
                    height: 1.5,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedSelector(BuildContext context) {
    final theme = Theme.of(context);
    final currentSpeed = _tts.currentSpeed;

    return PopupMenuButton<double>(
      tooltip: 'Playback speed (0.25x to 2.0x)',
      initialValue: currentSpeed,
      onSelected: (speed) => _tts.setSpeed(speed),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.speed_rounded, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              '${currentSpeed.toStringAsFixed(currentSpeed == currentSpeed.roundToDouble() ? 1 : 2)}x',
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 2),
            Icon(Icons.arrow_drop_down_rounded, size: 16, color: theme.colorScheme.onSurfaceVariant),
          ],
        ),
      ),
      itemBuilder: (context) => TtsService.availableSpeeds.map((speed) {
        final isSlower = speed < 1.0;
        final isFaster = speed > 1.0;
        final label = '${speed.toStringAsFixed(speed == speed.roundToDouble() ? 1 : 2)}x';
        final tag = isSlower
            ? ' (Slower)'
            : isFaster
                ? ' (Faster)'
                : ' (Normal)';

        return PopupMenuItem<double>(
          value: speed,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label + tag,
                style: TextStyle(
                  fontWeight: speed == currentSpeed ? FontWeight.bold : FontWeight.normal,
                  color: speed == currentSpeed ? theme.colorScheme.primary : null,
                ),
              ),
              if (speed == currentSpeed)
                Icon(Icons.check_rounded, size: 16, color: theme.colorScheme.primary),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildWaveform(Color color) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(18, (index) {
            final t = (_animController.value * 2 * pi) + (index * 0.4);
            final height = 8 + (sin(t).abs() * 18);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 3.5,
              height: height,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.6 + (sin(t).abs() * 0.4)),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        );
      },
    );
  }
}
