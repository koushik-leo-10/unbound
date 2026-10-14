import 'package:flutter/material.dart';
import 'package:mindmap_ai_client/mindmap_ai_client.dart';
import '../core/api.dart';
import '../core/ui_helpers.dart';
import '../services/speech_service.dart';
import '../theme.dart';
import '../widgets/workspace_header.dart';

/// What the user is about to save. Nothing is stored until they confirm.
class _Draft {
  _Draft({
    required this.intent,
    required this.title,
    required this.content,
    this.dueAt,
    this.priority = TaskPriority.medium,
    this.durationMinutes = 60,
  });

  VoiceIntent intent; // note or task
  String title;
  String content;
  DateTime? dueAt;
  TaskPriority priority;
  int durationMinutes;
}

/// Screen 5 - Voice Assistant: speak, review the text, choose Note or Task,
/// confirm, then save.
class VoiceScreen extends StatefulWidget {
  const VoiceScreen({super.key});

  @override
  State<VoiceScreen> createState() => _VoiceScreenState();
}

class _VoiceScreenState extends State<VoiceScreen> {
  final _speech = SpeechService();
  final _text = TextEditingController();
  final _title = TextEditingController();
  bool _listening = false;
  bool _busy = false;
  _Draft? _draft;

  @override
  void dispose() {
    _speech.dispose();
    _text.dispose();
    _title.dispose();
    super.dispose();
  }

  Future<void> _toggleMic() async {
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }
    final ready = await _speech.init(
      onStatus: (status) {
        if ((status == 'done' || status == 'notListening') && mounted) {
          setState(() => _listening = false);
        }
      },
      onError: (message) {
        if (mounted) {
          setState(() => _listening = false);
          showMessage(context, 'Speech recognition error: $message');
        }
      },
    );
    if (!ready) {
      if (mounted) {
        showMessage(context, 'Speech recognition is not available or permission was denied.');
      }
      return;
    }
    setState(() {
      _listening = true;
      _draft = null;
    });
    await _speech.start(onResult: (text, isFinal) {
      if (mounted) setState(() => _text.text = text);
    });
  }

  void _setDraft(_Draft draft) {
    _title.text = draft.title;
    setState(() => _draft = draft);
  }

  String get _spoken => _text.text.trim();

  /// Quick manual choice: no AI call needed.
  void _manualDraft(VoiceIntent intent) {
    if (_spoken.isEmpty) {
      showMessage(context, 'Say something first.');
      return;
    }
    final short = _spoken.length > 80 ? _spoken.substring(0, 80) : _spoken;
    _setDraft(_Draft(intent: intent, title: short, content: _spoken));
  }

  /// Let the AI decide note vs task and extract title and deadline.
  Future<void> _aiDraft() async {
    if (_spoken.isEmpty) {
      showMessage(context, 'Say something first.');
      return;
    }
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final r = await client.ai.processVoiceCommand(_spoken);
      _setDraft(_Draft(
        intent: r.intent == VoiceIntent.task ? VoiceIntent.task : VoiceIntent.note,
        title: r.title,
        content: r.content,
        dueAt: r.dueAt,
        priority: r.priority,
        durationMinutes: r.durationMinutes,
      ));
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirm() async {
    final draft = _draft;
    if (draft == null || _busy) return;
    setState(() => _busy = true);
    try {
      final title = _title.text.trim();
      if (draft.intent == VoiceIntent.task) {
        await client.tasks.createTask(
          title,
          draft.priority,
          draft.durationMinutes,
          dueAt: draft.dueAt,
        );
      } else {
        await client.notes.createNote(title, draft.content);
      }
      if (!mounted) return;
      showMessage(context, draft.intent == VoiceIntent.task ? 'Task created.' : 'Note saved.');
      setState(() {
        _draft = null;
        _text.clear();
      });
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: const WorkspaceHeader(
        title: 'Voice capture',
        subtitle: 'Speak a thought, save it as a note or task',
        icon: Icons.graphic_eq_rounded,
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
            children: [
          Card(
            color: UnboundTheme.forestDeep,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 22),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_listening ? 'Listening now' : 'Capture a thought',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        const Text('Speak naturally. You can edit everything before it is saved.',
                            style: TextStyle(color: Color(0xFFD1DED5), height: 1.45)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton.filled(
                    iconSize: 27,
                    padding: const EdgeInsets.all(19),
                    style: IconButton.styleFrom(
                      backgroundColor: _listening ? scheme.error : UnboundTheme.clay,
                      foregroundColor: Colors.white,
                    ),
                    tooltip: _listening ? 'Stop listening' : 'Start listening',
                    icon: Icon(_listening ? Icons.stop_rounded : Icons.mic_rounded),
                    onPressed: _busy ? null : _toggleMic,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _text,
            minLines: 3,
            maxLines: 8,
            decoration: const InputDecoration(
              labelText: 'Recognised text (you can edit it)',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: _busy ? null : () => _manualDraft(VoiceIntent.note),
                icon: const Icon(Icons.note_add_outlined),
                label: const Text('Save as note'),
              ),
              OutlinedButton.icon(
                onPressed: _busy ? null : () => _manualDraft(VoiceIntent.task),
                icon: const Icon(Icons.add_task),
                label: const Text('Create task'),
              ),
              FilledButton.icon(
                onPressed: _busy ? null : _aiDraft,
                icon: const Icon(Icons.auto_awesome),
                label: const Text('Understand with AI'),
              ),
            ],
          ),
          if (_draft != null) ...[
            const SizedBox(height: 16),
            _confirmCard(_draft!),
          ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _confirmCard(_Draft draft) {
    final isTask = draft.intent == VoiceIntent.task;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Confirm before saving', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<VoiceIntent>(
              segments: const [
                ButtonSegment(
                    value: VoiceIntent.note,
                    label: Text('Note'),
                    icon: Icon(Icons.note_alt_outlined)),
                ButtonSegment(
                    value: VoiceIntent.task, label: Text('Task'), icon: Icon(Icons.checklist)),
              ],
              selected: {draft.intent},
              onSelectionChanged: (s) => setState(() => draft.intent = s.first),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            if (isTask) ...[
              const SizedBox(height: 12),
              SegmentedButton<TaskPriority>(
                segments: [
                  for (final p in TaskPriority.values)
                    ButtonSegment(value: p, label: Text(priorityLabel(p))),
                ],
                selected: {draft.priority},
                onSelectionChanged: (s) => setState(() => draft.priority = s.first),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.event),
                      label: Text(formatDue(draft.dueAt)),
                      onPressed: () async {
                        final picked = await pickDateTime(context, initial: draft.dueAt);
                        if (picked != null) setState(() => draft.dueAt = picked);
                      },
                    ),
                  ),
                  if (draft.dueAt != null)
                    IconButton(
                      tooltip: 'Clear deadline',
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => draft.dueAt = null),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _busy ? null : () => setState(() => _draft = null),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _busy ? null : _confirm,
                  child: Text(isTask ? 'Create task' : 'Save note'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
