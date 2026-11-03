import 'package:flutter/material.dart';
import '../theme.dart';

/// A consistent, compact title bar for each workspace.
class WorkspaceHeader extends StatelessWidget implements PreferredSizeWidget {
  const WorkspaceHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.actions = const [],
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> actions;

  @override
  Size get preferredSize => const Size.fromHeight(88);

  @override
  Widget build(BuildContext context) => ColoredBox(
        color: UnboundTheme.canvas,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 10, 20, 10),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE9DF),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(icon, color: UnboundTheme.forest, size: 23),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -.5)),
                    const SizedBox(height: 2),
                    Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: UnboundTheme.muted)),
                  ],
                ),
              ),
              ...actions,
            ],
          ),
        ),
      );
}
