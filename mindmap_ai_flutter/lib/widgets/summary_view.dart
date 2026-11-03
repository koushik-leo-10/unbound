import 'package:flutter/material.dart';
import 'package:mindmap_ai_client/mindmap_ai_client.dart';
import '../core/ui_helpers.dart';
import '../services/tts_service.dart';
import 'voice_explanation_player.dart';

/// Shows an AI summary with integrated Voice Explanation player
/// and allows the user to accept or dismiss each suggested task.
class SummaryView extends StatefulWidget {
  const SummaryView({
    super.key,
    required this.result,
    required this.onAcceptTask,
    this.sourceTitle,
  });

  final SummaryResult result;
  final Future<void> Function(SuggestedTask task) onAcceptTask;
  final String? sourceTitle;

  @override
  State<SummaryView> createState() => _SummaryViewState();
}

class _SummaryViewState extends State<SummaryView> {
  final Set<int> _handled = {}; // accepted or dismissed
  final Set<int> _saving = {};
  bool _showVoicePlayer = false;

  @override
  void dispose() {
    TtsService.instance.stop();
    super.dispose();
  }

  String get _spokenScript => TtsService.generateSpokenBriefing(
        summary: widget.result.summary,
        keyPoints: widget.result.keyPoints,
        actionItems: widget.result.actionItems,
        sourceTitle: widget.sourceTitle,
      );

  void _startVoiceExplanation() {
    setState(() => _showVoicePlayer = true);
    TtsService.instance.speak(_spokenScript);
  }

  Future<void> _accept(int index, SuggestedTask task) async {
    setState(() => _saving.add(index));
    try {
      await widget.onAcceptTask(task);
      if (mounted) setState(() => _handled.add(index));
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _saving.remove(index));
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Voice Player Banner when activated
        if (_showVoicePlayer) ...[
          VoiceExplanationPlayer(
            spokenText: _spokenScript,
            title: widget.sourceTitle != null
                ? 'Voice Briefing: ${widget.sourceTitle}'
                : 'AI Voice Briefing',
            onClose: () => setState(() => _showVoicePlayer = false),
          ),
          const SizedBox(height: 8),
        ],

        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Voice Option
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Summary', style: textTheme.titleMedium),
                    if (!_showVoicePlayer)
                      FilledButton.tonalIcon(
                        onPressed: _startVoiceExplanation,
                        icon: const Icon(Icons.record_voice_over_rounded, size: 18),
                        label: const Text('Explain with Voice'),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(result.summary, style: const TextStyle(height: 1.45)),

                if (result.keyPoints.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline_rounded,
                          size: 18, color: colorScheme.primary),
                      const SizedBox(width: 6),
                      Text('Key points', style: textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ...result.keyPoints.map(_bullet),
                ],

                if (result.actionItems.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.checklist_rounded,
                          size: 18, color: colorScheme.secondary),
                      const SizedBox(width: 6),
                      Text('Action items', style: textTheme.titleMedium),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ...result.actionItems.map(_bullet),
                ],

                if (result.suggestedTasks.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Icon(Icons.task_alt_rounded,
                          size: 18, color: colorScheme.tertiary),
                      const SizedBox(width: 6),
                      Text('Suggested tasks', style: textTheme.titleMedium),
                    ],
                  ),
                  for (var i = 0; i < result.suggestedTasks.length; i++)
                    _suggestionRow(i, result.suggestedTasks[i]),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _bullet(String text) => Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('\u2022 ', style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(child: Text(text, style: const TextStyle(height: 1.35))),
          ],
        ),
      );

  Widget _suggestionRow(int index, SuggestedTask task) {
    if (_handled.contains(index)) return const SizedBox.shrink();
    final saving = _saving.contains(index);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(task.title),
      subtitle: Text(
        '${formatDue(task.dueAt)} | ${priorityLabel(task.priority)} | ${task.durationMinutes} min',
      ),
      trailing: saving
          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Add to tasks',
                  icon: const Icon(Icons.check_circle_outline),
                  onPressed: () => _accept(index, task),
                ),
                IconButton(
                  tooltip: 'Dismiss',
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _handled.add(index)),
                ),
              ],
            ),
    );
  }
}
