import 'package:flutter/material.dart';

/// Responsive note preview for both list and card-grid layouts.
class NotePreviewCard extends StatelessWidget {
  const NotePreviewCard({
    super.key,
    required this.title,
    required this.preview,
    required this.hasSummary,
    required this.onTap,
    required this.onDelete,
  });

  final String title;
  final String preview;
  final bool hasSummary;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: hasSummary ? const Color(0xFFFFEFE6) : const Color(0xFFDCE9DF),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(
                        hasSummary ? Icons.auto_awesome_rounded : Icons.sticky_note_2_outlined,
                        color: hasSummary ? const Color(0xFFC96D43) : const Color(0xFF214F42),
                        size: 19,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      tooltip: 'Delete note',
                      icon: const Icon(Icons.more_horiz_rounded),
                      onPressed: onDelete,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(preview, maxLines: 3, overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(height: 1.45, color: const Color(0xFF758078))),
                const SizedBox(height: 6),
                Text(hasSummary ? 'AI summary' : 'Quick note',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: const Color(0xFF758078), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      );
}
