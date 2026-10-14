import 'package:flutter/material.dart';
import 'package:mindmap_ai_client/mindmap_ai_client.dart';
import '../core/api.dart';
import '../core/ui_helpers.dart';
import '../services/document_picker.dart';
import '../widgets/state_views.dart';
import '../widgets/summary_view.dart';
import '../widgets/workspace_header.dart';
import 'notes_screen.dart';

/// Screen 4 - AI Insights: summarise pasted text or a PDF, review extracted
/// action items, see recommended priorities and saved summaries.
class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  final _text = TextEditingController();
  bool _loading = true;
  bool _busy = false;
  String? _error;
  String? _sourceName;
  SummaryResult? _result;
  List<Task> _priorities = [];
  List<Note> _summarised = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final (priorities, notes) =
          await (client.tasks.getPrioritizedTasks(limit: 3), client.notes.getNotes()).wait;
      if (!mounted) return;
      setState(() {
        _priorities = priorities;
        _summarised = notes.where((n) => n.summary?.isNotEmpty == true).take(5).toList();
      });
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickPdf() => _run(() async {
        final document = await DocumentPicker.pickPdf();
        if (document == null) return;
        _text.text = document.text;
        setState(() => _sourceName = document.name);
      });

  Future<void> _summarise() => _run(() async {
        final result = await client.ai.summarizeText(_text.text);
        if (mounted) setState(() => _result = result);
      });

  Future<void> _saveAsNote() => _run(() async {
        final title = _sourceName ?? 'Summary ${formatDue(DateTime.now())}';
        final note = await client.notes.createNote(title, _text.text);
        await client.notes.updateNote(note.id!, note.title, note.content,
            summary: _result?.summary);
        if (mounted) showMessage(context, 'Saved to Notes.');
        await _load();
      });

  Future<void> _acceptTask(SuggestedTask task) async {
    await client.tasks.createTask(
      task.title,
      task.priority,
      task.durationMinutes,
      dueAt: task.dueAt,
    );
    if (mounted) {
      showMessage(context, 'Task added.');
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: const WorkspaceHeader(
        title: 'AI insights',
        subtitle: 'Turn long documents into clear next steps',
        icon: Icons.auto_awesome_rounded,
      ),
      body: _loading
          ? const LoadingView()
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1080),
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                      children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    Text('Summarize a document', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _text,
                      minLines: 4,
                      maxLines: 10,
                      decoration: InputDecoration(
                        labelText: _sourceName == null
                            ? 'Paste a transcript or document text'
                            : 'Text from $_sourceName',
                        alignLabelWithHint: true,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        OutlinedButton.icon(
                          onPressed: _busy ? null : _pickPdf,
                          icon: const Icon(Icons.picture_as_pdf_outlined),
                          label: const Text('Pick PDF'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _busy ? null : _summarise,
                            icon: _busy
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2))
                                : const Icon(Icons.auto_awesome),
                            label: Text(_busy ? 'Working...' : 'Summarize'),
                          ),
                        ),
                      ],
                    ),
                          ],
                        ),
                      ),
                    ),
                    if (_result != null) ...[
                      const SizedBox(height: 16),
                      SummaryView(
                        result: _result!,
                        onAcceptTask: _acceptTask,
                        sourceTitle: _sourceName ?? 'Document Summary',
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _busy ? null : _saveAsNote,
                          icon: const Icon(Icons.note_add_outlined),
                          label: const Text('Save as note'),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    Text('Recommended priorities', style: textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (_priorities.isEmpty)
                      const Text('No pending tasks to prioritise.')
                    else
                      for (var i = 0; i < _priorities.length; i++)
                        Card(
                          child: ListTile(
                            leading: CircleAvatar(child: Text('${i + 1}')),
                            title: Text(_priorities[i].title),
                            subtitle: Text(
                              '${isOverdue(_priorities[i]) ? 'Overdue - ' : ''}'
                              '${formatDue(_priorities[i].dueAt)} | '
                              '${priorityLabel(_priorities[i].priority)}',
                            ),
                          ),
                        ),
                    const SizedBox(height: 24),
                    Text('Saved summaries', style: textTheme.titleMedium),
                    const SizedBox(height: 8),
                    if (_summarised.isEmpty)
                      const Text('Summaries of your notes will appear here.')
                    else
                      for (final note in _summarised)
                        Card(
                          child: ListTile(
                            title: Text(note.title),
                            subtitle:
                                Text(note.summary!, maxLines: 3, overflow: TextOverflow.ellipsis),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)),
                              );
                              _load();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
