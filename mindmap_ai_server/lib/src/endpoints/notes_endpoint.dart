import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';
import '../services/validators.dart';

/// notes.createNote / getNotes / updateNote / deleteNote
///
/// Demo build: a single demo user, no authentication.
class NotesEndpoint extends Endpoint {
  Future<Note> createNote(Session session, String title, String content) async {
    final note = Note(
      title: Validators.requireText(title, field: 'Title', max: Validators.maxTitleLength),
      content: Validators.requireText(content, field: 'Note'),
      createdAt: DateTime.now().toUtc(),
    );
    return Note.db.insertRow(session, note);
  }

  /// Newest first.
  Future<List<Note>> getNotes(Session session) {
    return Note.db.find(
      session,
      orderBy: (t) => t.createdAt.desc(),
    );
  }

  Future<Note> updateNote(
    Session session,
    int id,
    String title,
    String content, {
    String? summary,
  }) async {
    final note = await Note.db.findById(session, id);
    if (note == null) throw AppException(message: 'Note not found.');
    note.title = Validators.requireText(title, field: 'Title', max: Validators.maxTitleLength);
    note.content = Validators.requireText(content, field: 'Note');
    if (summary != null) note.summary = summary.trim();
    return Note.db.updateRow(session, note);
  }

  /// Deletes the note; tasks created from it are kept but detached.
  Future<void> deleteNote(Session session, int id) async {
    await session.db.transaction((transaction) async {
      final linked = await Task.db.find(
        session,
        where: (t) => t.sourceNoteId.equals(id),
        transaction: transaction,
      );
      for (final task in linked) {
        task.sourceNoteId = null;
        await Task.db.updateRow(session, task, transaction: transaction);
      }
      await Note.db.deleteWhere(
        session,
        where: (t) => t.id.equals(id),
        transaction: transaction,
      );
    });
  }
}
