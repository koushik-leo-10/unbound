import 'package:flutter/material.dart';
import 'package:mindmap_ai_client/mindmap_ai_client.dart';
import '../core/api.dart';
import '../core/ui_helpers.dart';
import '../services/speech_service.dart';
import '../widgets/state_views.dart';
import '../widgets/summary_view.dart';
import '../widgets/note_preview_card.dart';
import '../widgets/workspace_header.dart';

/// Screen 2 - Smart Notes: list of notes.
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  bool _loading = true;
  String? _error;
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final notes = await client.notes.getNotes();
      if (mounted) setState(() => _notes = notes);
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _open([Note? note]) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)),
    );
    if (mounted) _load();
  }

  Future<void> _delete(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete note?'),
        content: Text('"${note.title}" will be removed. Tasks created from it are kept.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await client.notes.deleteNote(note.id!);
      await _load();
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const WorkspaceHeader(
        title: 'Notes',
        subtitle: 'A home for ideas worth keeping',
        icon: Icons.sticky_note_2_outlined,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _open(),
        icon: const Icon(Icons.add),
        label: const Text('New note'),
      ),
      body: _loading
          ? const LoadingView()
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : _notes.isEmpty
                  ? const EmptyView(
                      icon: Icons.note_alt_outlined,
                      message: 'No notes yet.\nTap "New note" or use your voice.')
                  : RefreshIndicator(
                      onRefresh: _load,
                      child: LayoutBuilder(builder: (context, constraints) {
                        final wide = constraints.maxWidth >= 760;
                        NotePreviewCard cardFor(Note note) => NotePreviewCard(
                              title: note.title,
                              preview: note.summary?.isNotEmpty == true ? note.summary! : note.content,
                              hasSummary: note.summary?.isNotEmpty == true,
                              onTap: () => _open(note),
                              onDelete: () => _delete(note),
                            );
                        if (wide) {
                          return GridView.builder(
                            padding: const EdgeInsets.fromLTRB(24, 18, 24, 96),
                            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 340,
                              mainAxisExtent: 205,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: _notes.length,
                            itemBuilder: (context, i) => cardFor(_notes[i]),
                          );
                        }
                        return ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
                          itemCount: _notes.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, i) => cardFor(_notes[i]),
                        );
                      }),
                    ),
    );
  }
}

/// Create or edit a note, dictate with the microphone, summarise with AI.
class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key, this.note});

  final Note? note;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _speech = SpeechService();
  late final TextEditingController _title =
      TextEditingController(text: widget.note?.title ?? '');
  late final TextEditingController _content =
      TextEditingController(text: widget.note?.content ?? '');

  Note? _note;
  SummaryResult? _result;
  bool _busy = false;
  bool _listening = false;
  String _partial = '';

  @override
  void initState() {
    super.initState();
    _note = widget.note;
  }

  @override
  void dispose() {
    _speech.dispose();
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  String get _derivedTitle {
    final typed = _title.text.trim();
    if (typed.isNotEmpty) return typed;
    final text = _content.text.trim();
    return text.length > 40 ? '${text.substring(0, 40)}...' : text;
  }

  Future<Note> _save({String? summary}) async {
    final existing = _note;
    final saved = existing == null
        ? await client.notes.createNote(_derivedTitle, _content.text)
        : await client.notes.updateNote(
            existing.id!,
            _derivedTitle,
            _content.text,
            summary: summary,
          );
    _note = saved;
    return saved;
  }

  Future<void> _run(Future<void> Function() action, {String? success}) async {
    if (_busy) return; // blocks duplicate submissions
    setState(() => _busy = true);
    try {
      await action();
      if (success != null && mounted) showMessage(context, success);
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _toggleMic() async {
    if (_listening) {
      await _speech.stop();
      setState(() => _listening = false);
      return;
    }
    final ready = await _speech.init(
      onStatus: (status) {
        if (status == 'done' || status == 'notListening') {
          if (mounted) setState(() => _listening = false);
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
    setState(() => _listening = true);
    await _speech.start(onResult: (text, isFinal) {
      if (!mounted) return;
      setState(() => _partial = isFinal ? '' : text);
      if (isFinal && text.isNotEmpty) {
        final current = _content.text.trimRight();
        _content.text = current.isEmpty ? text : '$current $text';
      }
    });
  }

  Future<void> _summarise() => _run(() async {
        if (_content.text.trim().isEmpty) {
          throw const FormatException('Write or dictate something first.');
        }
        await _save(); // the note needs an id so accepted tasks can reference it
        final result = await client.ai.summarizeText(_content.text);
        await _save(summary: result.summary);
        if (mounted) setState(() => _result = result);
      });

  Future<void> _acceptTask(SuggestedTask task) async {
    await client.tasks.createTask(
      task.title,
      task.priority,
      task.durationMinutes,
      dueAt: task.dueAt,
      sourceNoteId: _note?.id,
    );
    if (mounted) showMessage(context, 'Task added.');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'New note' : 'Edit note'),
        actions: [
          TextButton.icon(
            onPressed: _busy
                ? null
                : () => _run(() async {
                      await _save();
                      if (mounted) Navigator.pop(context);
                    }),
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _title,
            textCapitalization: TextCapitalization.sentences,
            decoration:
                const InputDecoration(labelText: 'Title (optional)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _content,
            minLines: 6,
            maxLines: 14,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              labelText: 'Note, meeting transcript or dictation',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
          ),
          if (_listening || _partial.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _partial.isEmpty ? 'Listening...' : _partial,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton.filledTonal(
                tooltip: _listening ? 'Stop dictation' : 'Dictate',
                icon: Icon(_listening ? Icons.stop : Icons.mic),
                onPressed: _busy ? null : _toggleMic,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: _busy ? null : _summarise,
                  icon: _busy
                      ? const SizedBox(
                          width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.auto_awesome),
                  label: Text(_busy ? 'Working...' : 'Summarize'),
                ),
              ),
            ],
          ),
          if (_result != null) ...[
            const SizedBox(height: 16),
            SummaryView(
              result: _result!,
              onAcceptTask: _acceptTask,
              sourceTitle: _title.text.isNotEmpty ? _title.text : 'Note',
            ),
          ],
        ],
      ),
    );
  }
}
