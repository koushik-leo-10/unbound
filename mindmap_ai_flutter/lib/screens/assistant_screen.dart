import 'package:flutter/material.dart';
import 'package:mindmap_ai_client/mindmap_ai_client.dart';
import '../core/api.dart';
import '../core/ui_helpers.dart';
import '../services/speech_service.dart';
import '../theme.dart';
import '../widgets/workspace_header.dart';

/// Natural language task helper. Changes are always presented for review first.
class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});
  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final _input = TextEditingController();
  final _speech = SpeechService();
  final _messages = <_Message>[
    _Message('Hi! I can create tasks from a sentence, suggest a new time for a task, or help plan your day. I’ll show you any change before it is saved.', false),
  ];
  bool _busy = false;
  bool _listening = false;
  @override
  void dispose() { _input.dispose(); _speech.dispose(); super.dispose(); }

  void _say(String text, {Widget? action}) => setState(() => _messages.add(_Message(text, false, action: action)));
  Future<void> _send([String? suggested]) async {
    final text = (suggested ?? _input.text).trim();
    if (text.isEmpty || _busy) return;
    _input.clear();
    setState(() { _messages.add(_Message(text, true)); _busy = true; });
    try {
      final lower = text.toLowerCase();
      if (RegExp(r'\b(reschedule|postpone|move|push back|change the time)\b').hasMatch(lower)) {
        await _handleMove(text);
      } else if (RegExp(r'\b(plan my day|what should i do|prioriti[sz]e|what next|daily plan)\b').hasMatch(lower)) {
        await _handlePlan();
      } else if (RegExp(r'\b(task|schedule|remind me|reminder|to do|todo|note)\b').hasMatch(lower)) {
        await _handleDraft(text);
      } else {
        _say('Try “Schedule a 30 minute study session tomorrow at 10” or “Reschedule my project review”. I can also make a note or plan your day.');
      }
    } catch (e) { if (mounted) _say(friendlyError(e)); }
    finally { if (mounted) setState(() => _busy = false); }
  }

  Future<void> _handleDraft(String text) async {
    final draft = await client.ai.processVoiceCommand(text);
    final isTask = draft.intent == VoiceIntent.task || RegExp(r'\b(task|schedule|remind|todo)\b', caseSensitive: false).hasMatch(text);
    final title = draft.title.trim().isEmpty ? text : draft.title;
    _say(isTask
      ? 'I understood this as a task. Review it, then choose Create task to save.'
      : 'I understood this as a note. Review it, then choose Save note.',
      action: _DraftCard(title: title, content: draft.content, task: isTask, dueAt: draft.dueAt,
        priority: draft.priority, duration: draft.durationMinutes,
        onCreate: (t, date, priority, duration) async {
          if (isTask) { await client.tasks.createTask(t, priority, duration, dueAt: date); }
          else { await client.notes.createNote(t, draft.content); }
          if (mounted) _say(isTask ? 'Task created: $t' : 'Note saved: $t');
        }));
  }

  Future<void> _handleMove(String text) async {
    final tasks = await client.tasks.getTasks(status: TaskStatus.pending);
    final terms = text.toLowerCase().split(RegExp(r'[^a-z0-9]+')).where((s) => s.length > 2 && !{'reschedule','postpone','move','push','back','change','time','please','task','my','the','for'}.contains(s)).toList();
    final ranked = tasks.map((task) => (task, terms.where((w) => task.title.toLowerCase().contains(w)).length))
      .where((entry) => entry.$2 > 0).toList()..sort((a,b) => b.$2.compareTo(a.$2));
    if (ranked.isEmpty) {
      _say(tasks.isEmpty ? 'There are no pending tasks to reschedule.' : 'Which task should I move? Choose one below.', action: tasks.isEmpty ? null : _TaskChoices(tasks: tasks, onPick: _proposeMove));
      return;
    }
    await _proposeMove(ranked.first.$1);
  }

  Future<void> _proposeMove(Task task) async {
    try {
      final proposal = await client.tasks.suggestReschedule(task.id!);
      if (!mounted) return;
      if (proposal == null) { _say('I couldn’t find a free time in the next 14 days for “${task.title}”.'); return; }
      _say('Here is a suggested time for “${task.title}”. It checks your saved working hours and Unbound tasks.',
        action: _MoveCard(task: task, start: proposal.proposedStart, end: proposal.proposedEnd,
          onAccept: () async {
            await client.tasks.rescheduleTask(task.id!, proposal.proposedStart);
            if (mounted) _say('Rescheduled “${task.title}” to ${formatSlot(proposal.proposedStart, proposal.proposedEnd)}.');
          }));
    } catch (e) { if (mounted) _say(friendlyError(e)); }
  }

  Future<void> _handlePlan() async {
    final suggestion = await client.ai.getDailySuggestion();
    final tasks = await client.tasks.getPrioritizedTasks(limit: 5);
    final rows = tasks.map((t) => '• ${t.title} (${priorityLabel(t.priority)})').join('\n');
    _say('${suggestion.message}${rows.isEmpty ? '' : '\n\nYour priority tasks:\n$rows'}');
  }

  Future<void> _mic() async {
    if (_listening) { await _speech.stop(); if (mounted) setState(() => _listening = false); return; }
    final ready = await _speech.init(onStatus: (s) { if ((s == 'done' || s == 'notListening') && mounted) setState(() => _listening = false); }, onError: (e) { if (mounted) { setState(() => _listening = false); showMessage(context, e); } });
    if (!ready) { if (mounted) showMessage(context, 'Speech recognition is unavailable.'); return; }
    setState(() => _listening = true);
    await _speech.start(onResult: (text, isFinal) { if (mounted) { setState(() => _input.text = text); if (isFinal) _send(); } });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const WorkspaceHeader(title: 'AI assistant', subtitle: 'Plan, schedule, and adjust your work', icon: Icons.smart_toy_rounded),
    body: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 900), child: Column(children: [
      Expanded(child: ListView.builder(padding: const EdgeInsets.fromLTRB(18, 20, 18, 12), itemCount: _messages.length + (_busy ? 1 : 0), itemBuilder: (context, i) {
        if (i == _messages.length) return const Padding(padding: EdgeInsets.all(12), child: Align(alignment: Alignment.centerLeft, child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))));
        final m = _messages[i];
        return Align(alignment: m.user ? Alignment.centerRight : Alignment.centerLeft, child: Container(
          constraints: const BoxConstraints(maxWidth: 680), margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(15), decoration: BoxDecoration(color: m.user ? UnboundTheme.forestDeep : Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(18)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(m.text, style: TextStyle(color: m.user ? Colors.white : null, height: 1.45)), if (m.action != null) ...[const SizedBox(height: 12), m.action!]])));
      })),
      if (_messages.length == 1) SingleChildScrollView(scrollDirection: Axis.horizontal, padding: const EdgeInsets.symmetric(horizontal: 16), child: Row(children: [
        _PromptChip(label: 'Plan my day', onTap: () => _send('Plan my day')),
        _PromptChip(label: 'Schedule a task', onTap: () => _input.text = 'Schedule a task '),
        _PromptChip(label: 'Reschedule a task', onTap: () => _input.text = 'Reschedule '),
      ])),
      Padding(padding: const EdgeInsets.fromLTRB(16, 10, 16, 18), child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
        IconButton(tooltip: _listening ? 'Stop listening' : 'Speak', onPressed: _busy ? null : _mic, icon: Icon(_listening ? Icons.stop_circle_outlined : Icons.mic_none_rounded)),
        Expanded(child: TextField(controller: _input, enabled: !_busy, minLines: 1, maxLines: 4, onSubmitted: (_) => _send(), decoration: const InputDecoration(hintText: 'Ask me to schedule, reschedule, or plan…', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12)))),
        const SizedBox(width: 8), IconButton.filled(onPressed: _busy ? null : () => _send(), icon: const Icon(Icons.arrow_upward_rounded)),
      ])),
    ]))),
  );
}

class _Message { _Message(this.text, this.user, {this.action}); final String text; final bool user; final Widget? action; }

class _PromptChip extends StatelessWidget {
  const _PromptChip({required this.label, required this.onTap}); final String label; final VoidCallback onTap;
  @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(right: 8, bottom: 8), child: ActionChip(label: Text(label), onPressed: onTap));
}

class _DraftCard extends StatefulWidget {
  const _DraftCard({required this.title, required this.content, required this.task, required this.dueAt, required this.priority, required this.duration, required this.onCreate});
  final String title, content; final bool task; final DateTime? dueAt; final TaskPriority priority; final int duration; final Future<void> Function(String, DateTime?, TaskPriority, int) onCreate;
  @override State<_DraftCard> createState() => _DraftCardState();
}
class _DraftCardState extends State<_DraftCard> {
  late final _title = TextEditingController(text: widget.title); late DateTime? _due = widget.dueAt; late TaskPriority _priority = widget.priority; bool _busy = false;
  @override void dispose() { _title.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Card(color: Theme.of(context).colorScheme.surface, child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title', isDense: true)),
    if (widget.task) ...[
      const SizedBox(height: 10), Wrap(spacing: 8, children: [for (final p in TaskPriority.values) ChoiceChip(label: Text(priorityLabel(p)), selected: _priority == p, onSelected: (_) => setState(() => _priority = p))]),
      TextButton.icon(onPressed: () async { final d = await pickDateTime(context, initial: _due); if (d != null) setState(() => _due = d); }, icon: const Icon(Icons.schedule), label: Text(formatDue(_due))),
    ],
    Align(alignment: Alignment.centerRight, child: FilledButton.icon(onPressed: _busy ? null : () async { setState(() => _busy = true); try { await widget.onCreate(_title.text.trim(), _due, _priority, widget.duration); } catch (e) { if (context.mounted) showMessage(context, friendlyError(e)); } finally { if (mounted) setState(() => _busy = false); } }, icon: Icon(widget.task ? Icons.add_task : Icons.save_outlined), label: Text(widget.task ? 'Create task' : 'Save note'))),
  ])));
}

class _MoveCard extends StatefulWidget { const _MoveCard({required this.task, required this.start, required this.end, required this.onAccept}); final Task task; final DateTime start, end; final Future<void> Function() onAccept; @override State<_MoveCard> createState() => _MoveCardState(); }
class _MoveCardState extends State<_MoveCard> { bool _busy = false; @override Widget build(BuildContext context) => Card(color: Theme.of(context).colorScheme.surface, child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(widget.task.title, style: Theme.of(context).textTheme.titleSmall), const SizedBox(height: 5), Text('${formatDue(widget.task.dueAt)}  →  ${formatSlot(widget.start, widget.end)}'), const SizedBox(height: 10), Align(alignment: Alignment.centerRight, child: FilledButton(onPressed: _busy ? null : () async { setState(() => _busy = true); try { await widget.onAccept(); } catch (e) { if (context.mounted) showMessage(context, friendlyError(e)); } finally { if (mounted) setState(() => _busy = false); } }, child: const Text('Accept new time')))]))); }

class _TaskChoices extends StatelessWidget { const _TaskChoices({required this.tasks, required this.onPick}); final List<Task> tasks; final Future<void> Function(Task) onPick; @override Widget build(BuildContext context) => Wrap(spacing: 8, children: [for (final task in tasks.take(8)) ActionChip(label: Text(task.title), onPressed: () => onPick(task))]); }
