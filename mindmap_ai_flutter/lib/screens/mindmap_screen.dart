import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:mindmap_ai_client/mindmap_ai_client.dart';
import '../core/api.dart';
import '../core/auth_state.dart';
import '../core/ui_helpers.dart';
import '../widgets/workspace_header.dart';

/// Interactive node representation for the visual mind map canvas.
class MindNode {
  MindNode({
    required this.id,
    required this.label,
    required this.color,
    this.notes = '',
    List<MindNode>? children,
  }) : children = children ?? [];

  final String id;
  String label;
  String color;
  String notes;
  List<MindNode> children;

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'color': color,
        'notes': notes,
        'children': children.map((c) => c.toJson()).toList(),
      };

  factory MindNode.fromJson(Map<String, dynamic> json) {
    return MindNode(
      id: json['id'] as String? ?? 'node-${Random().nextInt(99999)}',
      label: json['label'] as String? ?? 'Topic',
      color: json['color'] as String? ?? '#4F46E5',
      notes: json['notes'] as String? ?? '',
      children: (json['children'] as List<dynamic>?)
              ?.map((c) => MindNode.fromJson(c as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

/// Screen: Visual Mind Map Canvas.
class MindMapScreen extends StatefulWidget {
  const MindMapScreen({super.key, this.initialTopic});

  final String? initialTopic;

  @override
  State<MindMapScreen> createState() => _MindMapScreenState();
}

class _MindMapScreenState extends State<MindMapScreen> {
  final TransformationController _transformController = TransformationController();
  MindNode? _root;
  bool _generating = false;
  bool _saving = false;
  List<MindMap> _savedMaps = [];
  int? _currentMapId;
  String _mapTitle = 'My Mind Map';

  @override
  void initState() {
    super.initState();
    _loadSavedMaps();
    if (widget.initialTopic != null && widget.initialTopic!.isNotEmpty) {
      _generateAiMap(widget.initialTopic!);
    } else {
      _loadDefaultTemplate();
    }
  }

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _loadDefaultTemplate() {
    setState(() {
      _mapTitle = 'Product Strategy';
      _root = MindNode(
        id: 'root',
        label: 'Unbound Platform',
        color: '#4F46E5',
        notes: 'Central Product Vision & Core Architecture',
        children: [
          MindNode(
            id: 'b1',
            label: 'AI Capabilities',
            color: '#06B6D4',
            children: [
              MindNode(id: 'b1-1', label: 'Smart Summaries', color: '#06B6D4'),
              MindNode(id: 'b1-2', label: 'Voice Intent Parser', color: '#06B6D4'),
              MindNode(id: 'b1-3', label: 'Proactive Daily Focus', color: '#06B6D4'),
            ],
          ),
          MindNode(
            id: 'b2',
            label: 'Task Scheduling',
            color: '#10B981',
            children: [
              MindNode(id: 'b2-1', label: 'Working Hours Matrix', color: '#10B981'),
              MindNode(id: 'b2-2', label: 'Auto-Reschedule Slot Finder', color: '#10B981'),
              MindNode(id: 'b2-3', label: 'Urgency Prioritization', color: '#10B981'),
            ],
          ),
          MindNode(
            id: 'b3',
            label: 'Visual Node Graph',
            color: '#F59E0B',
            children: [
              MindNode(id: 'b3-1', label: 'Interactive Canvas View', color: '#F59E0B'),
              MindNode(id: 'b3-2', label: 'Dynamic Branch Colors', color: '#F59E0B'),
              MindNode(id: 'b3-3', label: 'AI Graph Generation', color: '#F59E0B'),
            ],
          ),
          MindNode(
            id: 'b4',
            label: 'User Security',
            color: '#EC4899',
            children: [
              MindNode(id: 'b4-1', label: 'PostgreSQL Hashed Auth', color: '#EC4899'),
              MindNode(id: 'b4-2', label: 'Session Persistence', color: '#EC4899'),
            ],
          ),
        ],
      );
    });
  }

  Future<void> _loadSavedMaps() async {
    try {
      final user = AuthManager.instance.currentUser;
      final maps = await client.mindMaps.getMindMaps(userId: user?.id);
      if (mounted) setState(() => _savedMaps = maps);
    } catch (_) {}
  }

  Future<void> _generateAiMap(String topicOrText) async {
    setState(() => _generating = true);
    try {
      final jsonString = await client.ai.generateMindMap(topicOrText);
      final mapData = jsonDecode(jsonString) as Map<String, dynamic>;
      final node = MindNode.fromJson(mapData);
      setState(() {
        _root = node;
        _mapTitle = node.label;
        _currentMapId = null;
      });
      _resetZoom();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Generated mind map for "$_mapTitle" with AI!')),
        );
      }
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  Future<void> _showAiPromptDialog() async {
    final controller = TextEditingController();
    List<Note> notes = [];
    try {
      notes = await client.notes.getNotes();
    } catch (_) {}

    if (!mounted) return;

    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Row(
                children: [
                  Icon(Icons.auto_awesome, color: Colors.indigo),
                  SizedBox(width: 10),
                  Text('Generate Mind Map with AI'),
                ],
              ),
              content: SizedBox(
                width: 480,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Enter a topic, brainstorming idea, or project goal:'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller,
                      decoration: InputDecoration(
                        hintText: 'e.g. Launching a Mobile App, Physics Study Plan...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        filled: true,
                      ),
                      maxLines: 2,
                    ),
                    if (notes.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Text('Or generate from an existing Note:', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Container(
                        constraints: const BoxConstraints(maxHeight: 140),
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: notes.take(5).length,
                          separatorBuilder: (_, index) => const Divider(height: 1),
                          itemBuilder: (c, i) {
                            final n = notes[i];
                            return ListTile(
                              dense: true,
                              title: Text(n.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                              subtitle: Text(n.content, maxLines: 1, overflow: TextOverflow.ellipsis),
                              onTap: () {
                                controller.text = '${n.title}\n${n.content}';
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                FilledButton.icon(
                  icon: const Icon(Icons.auto_awesome),
                  label: const Text('Generate'),
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      Navigator.pop(ctx, controller.text.trim());
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );

    if (selected != null && selected.isNotEmpty) {
      await _generateAiMap(selected);
    }
  }

  Future<void> _saveMindMap() async {
    if (_root == null) return;
    setState(() => _saving = true);
    try {
      final user = AuthManager.instance.currentUser;
      final jsonStr = jsonEncode(_root!.toJson());
      if (_currentMapId == null) {
        final saved = await client.mindMaps.createMindMap(
          _mapTitle,
          jsonStr,
          userId: user?.id,
        );
        _currentMapId = saved.id;
      } else {
        await client.mindMaps.updateMindMap(_currentMapId!, _mapTitle, jsonStr);
      }
      await _loadSavedMaps();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mind Map saved to database!')),
        );
      }
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showSavedMapsDialog() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Saved Mind Maps'),
        content: SizedBox(
          width: 400,
          child: _savedMaps.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('No saved mind maps found. Click "Save" to persist your current map!'),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: _savedMaps.length,
                  itemBuilder: (c, i) {
                    final item = _savedMaps[i];
                    return ListTile(
                      leading: const Icon(Icons.hub_rounded, color: Colors.indigo),
                      title: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('Updated ${formatDue(item.updatedAt)}'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        onPressed: () async {
                          final nav = Navigator.of(ctx);
                          await client.mindMaps.deleteMindMap(item.id!);
                          await _loadSavedMaps();
                          nav.pop();
                          _showSavedMapsDialog();
                        },
                      ),
                      onTap: () {
                        try {
                          final data = jsonDecode(item.rootNodeJson) as Map<String, dynamic>;
                          setState(() {
                            _root = MindNode.fromJson(data);
                            _mapTitle = item.title;
                            _currentMapId = item.id;
                          });
                          _resetZoom();
                          Navigator.pop(ctx);
                        } catch (e) {
                          showMessage(context, 'Failed to parse mind map: $e');
                        }
                      },
                    );
                  },
                ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  void _zoomIn() {
    final matrix = _transformController.value.clone();
    matrix.scale(1.2, 1.2, 1.0);
    _transformController.value = matrix;
  }

  void _zoomOut() {
    final matrix = _transformController.value.clone();
    matrix.scale(0.8, 0.8, 1.0);
    _transformController.value = matrix;
  }

  Color _parseColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return Colors.indigo;
    }
  }

  void _editNodeDialog(MindNode node, {MindNode? parent}) {
    final controller = TextEditingController(text: node.label);
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(node == _root ? 'Edit Root Concept' : 'Edit Node'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(labelText: 'Node Label', border: OutlineInputBorder()),
              autofocus: true,
            ),
          ],
        ),
        actions: [
          if (node != _root && parent != null)
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              onPressed: () {
                setState(() => parent.children.remove(node));
                Navigator.pop(ctx);
              },
              child: const Text('Delete Node'),
            ),
          TextButton(
            onPressed: () {
              final newChild = MindNode(
                id: 'node-${Random().nextInt(99999)}',
                label: 'New Sub-topic',
                color: node.color,
              );
              setState(() => node.children.add(newChild));
              Navigator.pop(ctx);
            },
            child: const Text('+ Add Child'),
          ),
          FilledButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                setState(() {
                  node.label = controller.text.trim();
                  if (node == _root) _mapTitle = node.label;
                });
              }
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: WorkspaceHeader(
        title: _mapTitle,
        subtitle: 'Map ideas and shape connections',
        icon: Icons.account_tree_rounded,
        actions: [
          IconButton(
            icon: const Icon(Icons.folder_open_rounded),
            tooltip: 'Saved Mind Maps',
            onPressed: _showSavedMapsDialog,
          ),
          IconButton(
            icon: _saving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save_outlined),
            tooltip: 'Save Mind Map',
            onPressed: _saveMindMap,
          ),
          IconButton.filledTonal(
            onPressed: _generating ? null : _showAiPromptDialog,
            tooltip: 'Generate with AI',
            icon: _generating
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.auto_awesome, size: 18),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Background Canvas Grid Pattern
          Positioned.fill(
            child: CustomPaint(
              painter: _CanvasGridPainter(isDark: isDark),
            ),
          ),

          // Interactive Pan & Zoom Area
          Positioned.fill(
            child: _generating
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(strokeWidth: 3),
                        SizedBox(height: 16),
                        Text('AI is organizing concepts into a visual mind map...', style: TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                  )
                : _root == null
                    ? const Center(child: Text('No mind map loaded.'))
                    : InteractiveViewer(
                        transformationController: _transformController,
                        boundaryMargin: const EdgeInsets.all(1500),
                        minScale: 0.2,
                        maxScale: 3.5,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Padding(
                                padding: const EdgeInsets.all(120),
                                child: _buildVisualMindMapTree(_root!),
                              ),
                            ),
                          ),
                        ),
                      ),
          ),

          // Floating Controls Overlay (Zoom In, Zoom Out, Reset View, Add Node)
          Positioned(
            right: 20,
            bottom: 24,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.add_rounded),
                      tooltip: 'Zoom In',
                      onPressed: _zoomIn,
                    ),
                    IconButton(
                      icon: const Icon(Icons.remove_rounded),
                      tooltip: 'Zoom Out',
                      onPressed: _zoomOut,
                    ),
                    IconButton(
                      icon: const Icon(Icons.fit_screen_rounded),
                      tooltip: 'Reset Zoom',
                      onPressed: _resetZoom,
                    ),
                    const Divider(height: 8),
                    IconButton(
                      icon: const Icon(Icons.auto_awesome_rounded, color: Colors.indigo),
                      tooltip: 'Generate with AI',
                      onPressed: _showAiPromptDialog,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a tree structure with connecting curves between parents and children.
  Widget _buildVisualMindMapTree(MindNode root) {
    final rootColor = _parseColor(root.color);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Central Root Node
        GestureDetector(
          onTap: () => _editNodeDialog(root),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [rootColor, rootColor.withOpacity(0.8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: rootColor.withOpacity(0.4),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.hub_rounded, color: Colors.white, size: 28),
                const SizedBox(width: 12),
                Text(
                  root.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 60),

        // Branches
        if (root.children.isNotEmpty)
          IntrinsicHeight(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < root.children.length; i++) ...[
                  if (i > 0) const SizedBox(width: 48),
                  _buildBranch(root.children[i], parent: root),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildBranch(MindNode branch, {required MindNode parent}) {
    final color = _parseColor(branch.color);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Connecting visual dot
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        Container(
          width: 2,
          height: 24,
          color: color.withOpacity(0.6),
        ),

        // Branch Node Card
        GestureDetector(
          onTap: () => _editNodeDialog(branch, parent: parent),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 220),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color, width: 2),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.bubble_chart_rounded, color: color, size: 18),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    branch.label,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Sub-nodes
        if (branch.children.isNotEmpty) ...[
          Container(
            width: 2,
            height: 20,
            color: color.withOpacity(0.5),
          ),
          for (final sub in branch.children) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _editNodeDialog(sub, parent: branch),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 200),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.4)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 8, color: color),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        sub.label,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],

        // Quick Add Sub-node Button
        const SizedBox(height: 8),
        IconButton(
          icon: Icon(Icons.add_circle_outline_rounded, size: 18, color: color.withOpacity(0.8)),
          tooltip: 'Add sub-topic',
          onPressed: () {
            setState(() {
              branch.children.add(MindNode(
                id: 'sub-${Random().nextInt(99999)}',
                label: 'New Idea',
                color: branch.color,
              ));
            });
          },
        ),
      ],
    );
  }
}

/// Custom painter for a subtle background dot grid on the mind map canvas.
class _CanvasGridPainter extends CustomPainter {
  _CanvasGridPainter({required this.isDark});
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.04)
      ..style = PaintingStyle.fill;

    const double spacing = 28;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
