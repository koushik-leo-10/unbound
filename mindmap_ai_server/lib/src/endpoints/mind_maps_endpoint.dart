import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

/// CRUD operations for saving and managing visual mind maps in PostgreSQL.
class MindMapsEndpoint extends Endpoint {
  Future<MindMap> createMindMap(
    Session session,
    String title,
    String rootNodeJson, {
    int? sourceNoteId,
    int? userId,
  }) async {
    final cleanTitle = title.trim().isEmpty ? 'Untitled Mind Map' : title.trim();
    final now = DateTime.now();
    final map = MindMap(
      title: cleanTitle,
      rootNodeJson: rootNodeJson,
      sourceNoteId: sourceNoteId,
      userId: userId,
      createdAt: now,
      updatedAt: now,
    );
    return MindMap.db.insertRow(session, map);
  }

  Future<List<MindMap>> getMindMaps(Session session, {int? userId}) async {
    if (userId != null) {
      return MindMap.db.find(
        session,
        where: (t) => t.userId.equals(userId),
        orderBy: (t) => t.updatedAt.desc(),
      );
    }
    return MindMap.db.find(
      session,
      orderBy: (t) => t.updatedAt.desc(),
    );
  }

  Future<MindMap?> getMindMap(Session session, int id) async {
    return MindMap.db.findById(session, id);
  }

  Future<MindMap> updateMindMap(
    Session session,
    int id,
    String title,
    String rootNodeJson,
  ) async {
    final map = await MindMap.db.findById(session, id);
    if (map == null) {
      throw AppException(message: 'Mind map not found.');
    }
    map.title = title.trim().isEmpty ? map.title : title.trim();
    map.rootNodeJson = rootNodeJson;
    map.updatedAt = DateTime.now();
    return MindMap.db.updateRow(session, map);
  }

  Future<void> deleteMindMap(Session session, int id) async {
    final map = await MindMap.db.findById(session, id);
    if (map != null) {
      await MindMap.db.deleteRow(session, map);
    }
  }
}
