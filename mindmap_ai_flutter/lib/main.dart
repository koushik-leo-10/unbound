import 'package:flutter/material.dart';
import 'core/auth_state.dart';
import 'screens/auth_screen.dart';
import 'screens/home_screen.dart';
import 'screens/insights_screen.dart';
import 'screens/mindmap_screen.dart';
import 'screens/notes_screen.dart';
import 'screens/tasks_screen.dart';
import 'screens/assistant_screen.dart';
import 'theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthManager.instance.init();
  runApp(const UnboundApp());
}

class UnboundApp extends StatelessWidget {
  const UnboundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Unbound',
      debugShowCheckedModeBanner: false,
      theme: UnboundTheme.light,
      darkTheme: UnboundTheme.dark,
      home: ListenableBuilder(
        listenable: AuthManager.instance,
        builder: (context, _) {
          if (!AuthManager.instance.isAuthenticated) {
            return AuthScreen(onAuthenticated: () {});
          }
          return const AppShell();
        },
      ),
    );
  }
}

/// Responsive navigation between the six main workspaces.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  static const int homeTab = 0;

  int _index = homeTab;

  void _go(int index) => setState(() => _index = index);

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      HomeScreen(onNavigate: _go),
      const MindMapScreen(),
      const NotesScreen(),
      const TasksScreen(),
      const InsightsScreen(),
      const AssistantScreen(),
    ];
    final destinations = const [
      _WorkspaceDestination(Icons.space_dashboard_outlined, Icons.space_dashboard, 'Overview'),
      _WorkspaceDestination(Icons.account_tree_outlined, Icons.account_tree, 'Mind maps'),
      _WorkspaceDestination(Icons.sticky_note_2_outlined, Icons.sticky_note_2, 'Notes'),
      _WorkspaceDestination(Icons.task_alt_outlined, Icons.task_alt, 'Tasks'),
      _WorkspaceDestination(Icons.auto_awesome_outlined, Icons.auto_awesome, 'Insights'),
      _WorkspaceDestination(Icons.smart_toy_outlined, Icons.smart_toy, 'Assistant'),
    ];
    return LayoutBuilder(builder: (context, constraints) {
      final wide = constraints.maxWidth >= 900;
      final extended = constraints.maxWidth >= 1180;
      final page = KeyedSubtree(key: ValueKey(_index), child: screens[_index]);
      return Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              if (wide)
                Container(
                  width: extended ? 252 : 88,
                  color: UnboundTheme.forestDeep,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(extended ? 24 : 0, 28, extended ? 24 : 0, 28),
                        child: Row(
                          mainAxisAlignment: extended ? MainAxisAlignment.start : MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .12),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(Icons.hub_rounded, color: Colors.white, size: 23),
                            ),
                            if (extended) ...[
                              const SizedBox(width: 12),
                              const Text(
                                'unbound',
                                style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700, letterSpacing: -.6),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: extended ? 16 : 10),
                        child: Divider(color: Colors.white.withValues(alpha: .12), height: 1),
                      ),
                      const SizedBox(height: 16),
                      for (var i = 0; i < destinations.length; i++)
                        _RailItem(
                          destination: destinations[i],
                          selected: _index == i,
                          extended: extended,
                          onTap: () => _go(i),
                        ),
                      const Spacer(),
                      if (extended)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 17,
                                backgroundColor: Colors.white.withValues(alpha: .15),
                                child: const Icon(Icons.person_outline, color: Colors.white, size: 19),
                              ),
                              const SizedBox(width: 10),
                              const Expanded(
                                child: Text('Your workspace', style: TextStyle(color: Colors.white70, fontSize: 12)),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              Expanded(child: page),
            ],
          ),
        ),
        bottomNavigationBar: wide
            ? null
            : NavigationBar(
                selectedIndex: _index,
                onDestinationSelected: _go,
                destinations: [
                  for (final destination in destinations)
                    NavigationDestination(
                      icon: Icon(destination.icon),
                      selectedIcon: Icon(destination.selectedIcon),
                      label: destination.label,
                    ),
                ],
              ),
      );
    });
  }
}

class _WorkspaceDestination {
  const _WorkspaceDestination(this.icon, this.selectedIcon, this.label);
  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class _RailItem extends StatelessWidget {
  const _RailItem({
    required this.destination,
    required this.selected,
    required this.extended,
    required this.onTap,
  });

  final _WorkspaceDestination destination;
  final bool selected;
  final bool extended;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? UnboundTheme.forestDeep : Colors.white70;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: extended ? 12 : 10, vertical: 3),
      child: Material(
        color: selected ? const Color(0xFFE0E9DF) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            height: 48,
            child: Row(
              mainAxisAlignment: extended ? MainAxisAlignment.start : MainAxisAlignment.center,
              children: [
                if (extended) const SizedBox(width: 14),
                Icon(selected ? destination.selectedIcon : destination.icon, color: foreground, size: 21),
                if (extended) ...[
                  const SizedBox(width: 13),
                  Text(
                    destination.label,
                    style: TextStyle(color: foreground, fontSize: 13, fontWeight: selected ? FontWeight.w700 : FontWeight.w500),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
