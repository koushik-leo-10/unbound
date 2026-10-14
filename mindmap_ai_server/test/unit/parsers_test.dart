import 'package:mindmap_ai_server/src/generated/protocol.dart';
import 'package:mindmap_ai_server/src/services/ai_parsers.dart';
import 'package:mindmap_ai_server/src/services/prioritizer.dart';
import 'package:mindmap_ai_server/src/services/validators.dart';
import 'package:mindmap_ai_server/src/services/voice_fallback_parser.dart';
import 'package:test/test.dart';

void main() {
  group('AiParsers.summary', () {
    test('keeps null deadlines and defaults unknown priorities', () {
      final result = AiParsers.summary({
        'summary': 'Project review is on Monday.',
        'keyPoints': ['Review Monday', '', 42],
        'actionItems': ['Finish slides'],
        'suggestedTasks': [
          {'title': 'Finish slides', 'dueAt': null, 'priority': 'urgent', 'durationMinutes': 90},
          {'title': '', 'dueAt': null},
          'not a map',
        ],
      });
      expect(result.keyPoints, ['Review Monday']);
      expect(result.suggestedTasks, hasLength(1));
      expect(result.suggestedTasks.first.dueAt, isNull);
      expect(result.suggestedTasks.first.priority, TaskPriority.medium);
      expect(result.suggestedTasks.first.durationMinutes, 90);
    });

    test('rejects an empty summary', () {
      expect(() => AiParsers.summary({'summary': '  '}), throwsA(isA<AppException>()));
    });

    test('drops invalid and absurd dates', () {
      final result = AiParsers.summary({
        'summary': 'x',
        'suggestedTasks': [
          {'title': 'A', 'dueAt': 'not-a-date'},
          {'title': 'B', 'dueAt': '1999-01-01T00:00:00Z'},
        ],
      });
      expect(result.suggestedTasks.every((t) => t.dueAt == null), isTrue);
    });
  });

  group('VoiceFallbackParser', () {
    test('recognises task commands', () {
      final result = VoiceFallbackParser.parse('Remind me to call the supplier');
      expect(result.intent, VoiceIntent.task);
      expect(result.title, 'call the supplier');
    });

    test('treats everything else as a note', () {
      final result = VoiceFallbackParser.parse('Note: budget approved for Q4');
      expect(result.intent, VoiceIntent.note);
      expect(result.title, 'budget approved for Q4');
    });
  });

  group('Validators', () {
    test('rejects empty text', () {
      expect(() => Validators.requireText('  ', field: 'Title'), throwsA(isA<AppException>()));
    });

    test('clamps durations', () {
      expect(Validators.duration(1), 5);
      expect(Validators.duration(9999), 480);
    });
  });

  group('Prioritizer', () {
    test('ranks overdue first, then urgent, then relaxed', () {
      final now = DateTime.utc(2026, 10, 11, 12);
      Task make(int id, TaskPriority p, DateTime? due) => Task(
            id: id,
            title: 't$id',
            dueAt: due,
            durationMinutes: 60,
            priority: p,
            status: TaskStatus.pending,
            createdAt: now,
          );
      final ranked = Prioritizer.rank([
        make(1, TaskPriority.high, null),
        make(2, TaskPriority.low, now.subtract(const Duration(days: 1))),
        make(3, TaskPriority.medium, now.add(const Duration(hours: 5))),
      ], now);
      expect(ranked.map((t) => t.id), [2, 3, 1]);
    });
  });
}
