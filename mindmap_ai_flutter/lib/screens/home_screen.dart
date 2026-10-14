import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mindmap_ai_client/mindmap_ai_client.dart';
import '../core/api.dart';
import '../core/auth_state.dart';
import '../core/ui_helpers.dart';
import '../theme.dart';
import '../widgets/preferences_sheet.dart';
import '../widgets/state_views.dart';
import '../widgets/task_form_dialog.dart';
import '../widgets/dashboard_action_card.dart';
import 'notes_screen.dart';

/// Screen 1 - Interactive Home Dashboard.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onNavigate});

  /// Switches the bottom-navigation tab:
  /// 1 = Mind maps, 2 = Notes, 3 = Tasks, 4 = Insights, 5 = Assistant
  final ValueChanged<int> onNavigate;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
  bool _refreshingAi = false;
  String? _error;
  DailySuggestion? _suggestion;
  List<Task> _pending = [];
  List<Task> _completed = [];
  List<Task> _overdue = [];
  List<Note> _recentNotes = [];
  UserPreferences? _prefs;
  DashboardStats? _stats;
  String _taskFilter = 'today'; // 'today', 'upcoming', 'high_priority'

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
      final (suggestion, pending, completed, overdue, notes, prefs, stats) = await (
        client.ai.getDailySuggestion(),
        client.tasks.getTasks(status: TaskStatus.pending),
        client.tasks.getTasks(status: TaskStatus.completed),
        client.tasks.getOverdueTasks(),
        client.notes.getNotes(),
        client.preferences.getPreferences(),
        client.user.getDashboardStats(),
      ).wait;

      if (!mounted) return;
      setState(() {
        _suggestion = suggestion;
        _pending = pending;
        _completed = completed;
        _overdue = overdue;
        _recentNotes = notes.take(5).toList();
        _prefs = prefs;
        _stats = stats;
      });
      _syncTimeZoneOnce(prefs);
    } catch (e) {
      if (mounted) setState(() => _error = friendlyError(e));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _refreshAiSuggestion() async {
    setState(() => _refreshingAi = true);
    try {
      final suggestion = await client.ai.getDailySuggestion();
      if (mounted) {
        setState(() => _suggestion = suggestion);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('AI suggestion refreshed!'), duration: Duration(seconds: 2)),
        );
      }
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _refreshingAi = false);
    }
  }

  Future<void> _toggleTaskStatus(Task task) async {
    final nextStatus = task.status == TaskStatus.pending ? TaskStatus.completed : TaskStatus.pending;
    try {
      await client.tasks.updateTask(task.id!, status: nextStatus);
      await _load();
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    }
  }

  Future<void> _quickAddTask() async {
    final form = await TaskFormDialog.show(context);
    if (form == null) return;
    try {
      await client.tasks.createTask(
        form.title,
        form.priority,
        form.durationMinutes,
        dueAt: form.dueAt,
      );
      await _load();
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    }
  }

  Future<void> _quickAddNote() async {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Quick Note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'What\'s on your mind?', border: OutlineInputBorder()),
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                Navigator.pop(ctx, true);
              }
            },
            child: const Text('Save Note'),
          ),
        ],
      ),
    );

    if (saved == true && titleController.text.trim().isNotEmpty) {
      try {
        await client.notes.createNote(titleController.text.trim(), contentController.text.trim());
        await _load();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Note saved successfully!')),
          );
        }
      } catch (e) {
        if (mounted) showMessage(context, friendlyError(e));
      }
    }
  }

  Future<void> _syncTimeZoneOnce(UserPreferences prefs) async {
    final now = DateTime.now();
    if (prefs.timezone != 'UTC' || now.timeZoneOffset.inMinutes == 0) return;
    try {
      final updated = await client.preferences.savePreferences(
        prefs.workingDayStartMinutes,
        prefs.workingDayEndMinutes,
        prefs.breakMinutes,
        now.timeZoneName,
        now.timeZoneOffset.inMinutes,
      );
      if (mounted) setState(() => _prefs = updated);
    } catch (_) {}
  }

  Future<void> _openPreferences() async {
    final prefs = _prefs;
    if (prefs == null) return;
    final saved = await PreferencesSheet.show(context, prefs);
    if (saved == true) _load();
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthManager.instance.currentUser;
    final userName = user?.name ?? 'Creator';
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final now = DateTime.now();

    final todayTasks = _pending
        .where((t) => t.dueAt != null && !isOverdue(t) && _isSameDay(t.dueAt!.toLocal(), now))
        .toList();
    final upcomingTasks = _pending
        .where((t) =>
            t.dueAt != null &&
            !isOverdue(t) &&
            !_isSameDay(t.dueAt!.toLocal(), now) &&
            t.dueAt!.isBefore(now.add(const Duration(days: 7))))
        .toList();
    final highPriorityTasks = _pending.where((t) => t.priority == TaskPriority.high).toList();

    List<Task> displayedTasks;
    if (_taskFilter == 'today') {
      displayedTasks = todayTasks;
    } else if (_taskFilter == 'upcoming') {
      displayedTasks = upcomingTasks;
    } else {
      displayedTasks = highPriorityTasks;
    }

    final totalTasksCount = _pending.length + _completed.length;
    final progress = totalTasksCount > 0 ? (_completed.length / totalTasksCount) : 0.0;

    return Scaffold(
      body: _loading
          ? const LoadingView()
          : _error != null
              ? ErrorView(message: _error!, onRetry: _load)
              : RefreshIndicator(
                  onRefresh: _load,
                  child: CustomScrollView(
                    slivers: [
                      // Modern Interactive App Bar / Header
                      SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(28, 26, 28, 24),
                          decoration: const BoxDecoration(
                            color: UnboundTheme.forest,
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${_greeting()}, $userName',
                                          style: theme.textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: -0.4,
                                              color: Colors.white,
                                              fontSize: 25,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('EEEE, MMMM d').format(now),
                                          style: theme.textTheme.bodySmall?.copyWith(
                                            color: Colors.white.withValues(alpha: .7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Preferences',
                                    icon: const Icon(Icons.tune_rounded),
                                    color: Colors.white,
                                    onPressed: _prefs == null ? null : _openPreferences,
                                  ),
                                  PopupMenuButton<String>(
                                    tooltip: 'Account Menu',
                                    icon: const Icon(Icons.more_vert_rounded),
                                    color: Colors.white,
                                    onSelected: (val) {
                                      if (val == 'logout') {
                                        AuthManager.instance.logout();
                                      } else if (val == 'prefs') {
                                        _openPreferences();
                                      }
                                    },
                                    itemBuilder: (ctx) => [
                                      PopupMenuItem(
                                        enabled: false,
                                        child: Text(
                                          '${user?.email ?? ""}\n(User #${user?.id ?? 1})',
                                          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                                        ),
                                      ),
                                      const PopupMenuDivider(),
                                      const PopupMenuItem(
                                        value: 'prefs',
                                        child: Row(
                                          children: [
                                            Icon(Icons.settings_outlined, size: 20),
                                            SizedBox(width: 10),
                                            Text('Scheduling settings'),
                                          ],
                                        ),
                                      ),
                                      const PopupMenuItem(
                                        value: 'logout',
                                        child: Row(
                                          children: [
                                            Icon(Icons.logout_rounded, size: 20, color: Colors.red),
                                            SizedBox(width: 10),
                                            Text('Sign out', style: TextStyle(color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 18),

                              // Interactive Productivity Progress Bar
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: .1),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: Colors.white.withValues(alpha: .14)),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Daily Progress',
                                          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
                                        ),
                                        Text(
                                          '${_completed.length} / $totalTasksCount tasks done (${(progress * 100).toInt()}%)',
                                          style: theme.textTheme.labelMedium?.copyWith(
                                            color: const Color(0xFFFFC39E),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        minHeight: 8,
                                        backgroundColor: Colors.white.withValues(alpha: .16),
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                          progress == 1.0 ? const Color(0xFFB7D59A) : UnboundTheme.clay,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Stat Cards Grid
                      SliverLayoutBuilder(
                        builder: (context, constraints) {
                          final columns = constraints.crossAxisExtent >= 1000
                              ? 4
                              : constraints.crossAxisExtent >= 620
                                  ? 4
                                  : 2;
                          return SliverPadding(
                            padding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
                            sliver: SliverGrid.count(
                              crossAxisCount: columns,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: columns == 2 ? 1.35 : 1.15,
                              children: [
                                _buildStatCard(
                                  title: 'Notes',
                                  count: _stats?.totalNotes ?? _recentNotes.length,
                                  icon: Icons.sticky_note_2_outlined,
                                  color: UnboundTheme.forest,
                                  onTap: () => widget.onNavigate(2),
                                ),
                                _buildStatCard(
                                  title: 'In progress',
                                  count: _pending.length,
                                  icon: Icons.pending_actions_rounded,
                                  color: UnboundTheme.clay,
                                  onTap: () => widget.onNavigate(3),
                                ),
                                _buildStatCard(
                                  title: 'Completed',
                                  count: _completed.length,
                                  icon: Icons.task_alt_rounded,
                                  color: UnboundTheme.moss,
                                  onTap: () => widget.onNavigate(3),
                                ),
                                _buildStatCard(
                                  title: 'Overdue',
                                  count: _overdue.length,
                                  icon: Icons.schedule_rounded,
                                  color: _overdue.isNotEmpty ? const Color(0xFFB85042) : UnboundTheme.muted,
                                  onTap: () => widget.onNavigate(3),
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // Overdue Alert Banner if tasks are overdue
                      if (_overdue.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                            child: Card(
                              color: colorScheme.errorContainer,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              child: ListTile(
                                leading: Icon(Icons.error_outline_rounded, color: colorScheme.onErrorContainer),
                                title: Text(
                                  '${_overdue.length} overdue task${_overdue.length == 1 ? '' : 's'} require attention',
                                  style: TextStyle(color: colorScheme.onErrorContainer, fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Tap to view and auto-reschedule with AI',
                                  style: TextStyle(color: colorScheme.onErrorContainer, fontSize: 13),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: colorScheme.onErrorContainer),
                                onTap: () => widget.onNavigate(3),
                              ),
                            ),
                          ),
                        ),

                      // Interactive AI Suggestion Card
                      if (_suggestion != null)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      colorScheme.primary.withOpacity(0.08),
                                      colorScheme.tertiary.withOpacity(0.05),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: colorScheme.primary.withOpacity(0.15),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Icon(Icons.auto_awesome, color: colorScheme.primary, size: 20),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            'AI Daily Focus',
                                            style: theme.textTheme.titleMedium?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        _refreshingAi
                                            ? const SizedBox(
                                                width: 18,
                                                height: 18,
                                                child: CircularProgressIndicator(strokeWidth: 2),
                                              )
                                            : IconButton(
                                                icon: const Icon(Icons.refresh_rounded, size: 20),
                                                tooltip: 'Regenerate suggestion',
                                                onPressed: _refreshAiSuggestion,
                                              ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      _suggestion!.message,
                                      style: theme.textTheme.bodyLarge?.copyWith(
                                        height: 1.4,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                          decoration: BoxDecoration(
                                            color: colorScheme.surfaceContainerHighest,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            _suggestion!.generatedByAi ? 'AI Powered' : 'Smart Rules Fallback',
                                            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                      SliverToBoxAdapter(
                        child: LayoutBuilder(builder: (context, constraints) {
                          final columns = constraints.maxWidth >= 820 ? 3 : 2;
                          final tileWidth = (constraints.maxWidth - 48 - (columns - 1) * 12) / columns;
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(24, 18, 24, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Make a move', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -.4)),
                                const SizedBox(height: 4),
                                Text('Pick a quick action to keep momentum.', style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                                const SizedBox(height: 14),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: [
                                    SizedBox(width: tileWidth, height: 84, child: DashboardActionCard(icon: Icons.account_tree_rounded, title: 'Mind map', description: 'Connect ideas', color: UnboundTheme.forest, onTap: () => widget.onNavigate(1))),
                                      SizedBox(width: tileWidth, height: 84, child: DashboardActionCard(icon: Icons.smart_toy_rounded, title: 'AI assistant', description: 'Schedule and plan', color: UnboundTheme.clay, onTap: () => widget.onNavigate(5))),
                                    SizedBox(width: tileWidth, height: 84, child: DashboardActionCard(icon: Icons.add_task_rounded, title: 'New task', description: 'Plan the next step', color: const Color(0xFF688D72), onTap: _quickAddTask)),
                                    SizedBox(width: tileWidth, height: 84, child: DashboardActionCard(icon: Icons.edit_note_rounded, title: 'Quick note', description: 'Save an idea', color: const Color(0xFF7780A4), onTap: _quickAddNote)),
                                    SizedBox(width: tileWidth, height: 84, child: DashboardActionCard(icon: Icons.auto_awesome_rounded, title: 'AI summary', description: 'Find the key points', color: const Color(0xFFB17858), onTap: () => widget.onNavigate(4))),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                      ),

                      // Recent Smart Notes Carousel
                      if (_recentNotes.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Recent Notes', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                    TextButton(
                                      onPressed: () => widget.onNavigate(1),
                                      child: const Text('View All'),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                SizedBox(
                                  height: 110,
                                  child: ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _recentNotes.length,
                                    separatorBuilder: (_, index) => const SizedBox(width: 12),
                                    itemBuilder: (ctx, i) {
                                      final note = _recentNotes[i];
                                      final hasSummary = note.summary != null && note.summary!.isNotEmpty;
                                      return SizedBox(
                                        width: 190,
                                        child: InkWell(
                                          borderRadius: BorderRadius.circular(16),
                                          onTap: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)),
                                            );
                                            _load();
                                          },
                                          child: Card(
                                            margin: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            child: Padding(
                                              padding: const EdgeInsets.all(12),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          note.title,
                                                          maxLines: 1,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      if (hasSummary)
                                                        const Icon(Icons.auto_awesome, size: 14, color: Colors.amber),
                                                    ],
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Expanded(
                                                    child: Text(
                                                      note.content,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                      // Interactive Task Board / Schedule
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Task Agenda', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                                  TextButton(
                                    onPressed: () => widget.onNavigate(3),
                                    child: const Text('All Tasks'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Filter Pills
                              Row(
                                children: [
                                  _buildFilterChip('Today (${todayTasks.length})', 'today'),
                                  const SizedBox(width: 8),
                                  _buildFilterChip('Upcoming (${upcomingTasks.length})', 'upcoming'),
                                  const SizedBox(width: 8),
                                  _buildFilterChip('High Priority (${highPriorityTasks.length})', 'high_priority'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Tasks List with interactive checkboxes
                      displayedTasks.isEmpty
                          ? SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.done_all_rounded, size: 40, color: colorScheme.outline),
                                      const SizedBox(height: 8),
                                      Text(
                                        'No ${_taskFilter == "today" ? "tasks for today" : _taskFilter == "upcoming" ? "upcoming tasks" : "high priority tasks"}!',
                                        style: TextStyle(color: colorScheme.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : SliverPadding(
                              padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (ctx, i) {
                                    final task = displayedTasks[i];
                                    final isDone = task.status == TaskStatus.completed;
                                    return Card(
                                      margin: const EdgeInsets.only(bottom: 8),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                      child: ListTile(
                                        leading: Checkbox(
                                          value: isDone,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                          onChanged: (_) => _toggleTaskStatus(task),
                                        ),
                                        title: Text(
                                          task.title,
                                          style: TextStyle(
                                            decoration: isDone ? TextDecoration.lineThrough : null,
                                            fontWeight: isDone ? FontWeight.normal : FontWeight.w600,
                                          ),
                                        ),
                                        subtitle: Row(
                                          children: [
                                            Icon(Icons.circle, size: 10, color: priorityColor(task.priority)),
                                            const SizedBox(width: 6),
                                            Text(
                                              task.priority.name.toUpperCase(),
                                              style: TextStyle(fontSize: 11, color: priorityColor(task.priority), fontWeight: FontWeight.bold),
                                            ),
                                            if (task.dueAt != null) ...[
                                              const SizedBox(width: 8),
                                              Text('•  ${formatDue(task.dueAt)}', style: const TextStyle(fontSize: 12)),
                                            ],
                                          ],
                                        ),
                                        trailing: IconButton(
                                          icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                                          onPressed: () => widget.onNavigate(3),
                                        ),
                                      ),
                                    );
                                  },
                                  childCount: displayedTasks.length,
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Card(
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(9),
                    decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(12)),
                    child: Icon(icon, color: color, size: 19),
                  ),
                  const Spacer(),
                  Icon(Icons.arrow_outward_rounded, color: theme.colorScheme.outline, size: 16),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$count', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: -.6)),
                  const SizedBox(height: 1),
                  Text(title, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String key) {
    final isSelected = _taskFilter == key;
    final colorScheme = Theme.of(context).colorScheme;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      selected: isSelected,
      onSelected: (val) {
        if (val) setState(() => _taskFilter = key);
      },
      selectedColor: colorScheme.primaryContainer,
      showCheckmark: false,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
