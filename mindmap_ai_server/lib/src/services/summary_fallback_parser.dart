import '../generated/protocol.dart';
import 'validators.dart';

/// Rule-based, offline fallback summarizer when the LLM service is busy,
/// out of credits (429), or unreachable. Extracts key sentences, action items,
/// and suggested tasks.
class SummaryFallbackParser {
  static SummaryResult parse(String text) {
    final clean = text.trim();
    if (clean.isEmpty) {
      return SummaryResult(
        summary: 'No readable text was found in the document.',
        keyPoints: [],
        actionItems: [],
        suggestedTasks: [],
      );
    }

    // Split into sentences
    final rawSentences = clean
        .split(RegExp(r'(?<=[.!?])\s+|\n{2,}'))
        .map((s) => s.replaceAll(RegExp(r'\s+'), ' ').trim())
        .where((s) => s.length > 25 && s.length < 350)
        .toList();

    // Word frequency scoring for extractive summary
    final words = clean
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s]'), '')
        .split(RegExp(r'\s+'))
        .where((w) => w.length > 3 && !_stopWords.contains(w));

    final wordScores = <String, int>{};
    for (final w in words) {
      wordScores[w] = (wordScores[w] ?? 0) + 1;
    }

    // Score sentences based on informative word density
    final scoredSentences = <_ScoredSentence>[];
    for (var i = 0; i < rawSentences.length; i++) {
      final s = rawSentences[i];
      final sWords = s.toLowerCase().split(RegExp(r'\s+'));
      var score = 0;
      for (final w in sWords) {
        score += wordScores[w] ?? 0;
      }
      // Boost earlier sentences (usually thesis/intro statements)
      if (i < 3) score = (score * 1.3).round();
      scoredSentences.add(_ScoredSentence(index: i, text: s, score: score));
    }

    // Sort to find top sentences, then restore chronological order for reading flow
    scoredSentences.sort((a, b) => b.score.compareTo(a.score));
    final topSentences = scoredSentences.take(4).toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    final summaryText = topSentences.isNotEmpty
        ? topSentences.map((s) => s.text).join(' ')
        : (clean.length > 300 ? '${clean.substring(0, 300)}...' : clean);

    // Extract Key Points (informative bullet points)
    final keyPoints = scoredSentences
        .skip(2)
        .take(5)
        .map((s) => s.text)
        .toList();

    // Extract Action Items (sentences with imperative verbs / obligation markers)
    final actionKeywords = RegExp(
      r'\b(must|should|need to|needs to|action|todo|ensure|review|complete|implement|prepare|verify|submit|finalize|follow up|schedule|deliver)\b',
      caseSensitive: false,
    );

    final actionItems = <String>[];
    for (final s in rawSentences) {
      if (actionKeywords.hasMatch(s)) {
        final cleaned = s.replaceAll(RegExp(r'^[*\-#0-9.]+\s*'), '').trim();
        if (cleaned.length > 15 && cleaned.length < 150 && !actionItems.contains(cleaned)) {
          actionItems.add(cleaned);
        }
      }
      if (actionItems.length >= 6) break;
    }

    // If no explicit action items found, synthesize helpful review actions from key points
    if (actionItems.isEmpty && topSentences.isNotEmpty) {
      actionItems.add('Review and analyze the key findings of this document');
      actionItems.add('Share relevant takeaways with stakeholders');
    }

    // Generate Suggested Tasks from action items
    final suggestedTasks = <SuggestedTask>[];
    for (var i = 0; i < actionItems.length && i < 4; i++) {
      final item = actionItems[i];
      suggestedTasks.add(
        SuggestedTask(
          title: item.length > Validators.maxTitleLength
              ? '${item.substring(0, Validators.maxTitleLength - 3)}...'
              : item,
          dueAt: DateTime.now().toUtc().add(Duration(days: 1 + i)),
          priority: i == 0 ? TaskPriority.high : TaskPriority.medium,
          durationMinutes: 45,
        ),
      );
    }

    return SummaryResult(
      summary: summaryText,
      keyPoints: keyPoints.isNotEmpty ? keyPoints : [summaryText],
      actionItems: actionItems,
      suggestedTasks: suggestedTasks,
    );
  }

  static const _stopWords = {
    'the', 'and', 'for', 'that', 'this', 'with', 'from', 'have', 'were',
    'which', 'will', 'there', 'their', 'about', 'would', 'could', 'should',
    'these', 'those', 'been', 'being', 'they', 'what', 'when', 'where', 'more',
  };
}

class _ScoredSentence {
  _ScoredSentence({required this.index, required this.text, required this.score});
  final int index;
  final String text;
  final int score;
}
