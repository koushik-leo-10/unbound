import 'package:flutter/material.dart';
import 'package:mindmap_ai_client/mindmap_ai_client.dart';
import '../core/api.dart';
import '../core/ui_helpers.dart';

/// Bottom sheet for working hours, break length and time zone.
class PreferencesSheet extends StatefulWidget {
  const PreferencesSheet({super.key, required this.preferences});

  final UserPreferences preferences;

  static Future<bool?> show(BuildContext context, UserPreferences preferences) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => PreferencesSheet(preferences: preferences),
    );
  }

  @override
  State<PreferencesSheet> createState() => _PreferencesSheetState();
}

class _PreferencesSheetState extends State<PreferencesSheet> {
  late int _start = widget.preferences.workingDayStartMinutes;
  late int _end = widget.preferences.workingDayEndMinutes;
  late int _break = widget.preferences.breakMinutes;
  bool _saving = false;

  TimeOfDay _toTime(int minutes) => TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);

  Future<void> _pick(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _toTime(isStart ? _start : _end),
    );
    if (picked == null) return;
    setState(() {
      final minutes = picked.hour * 60 + picked.minute;
      if (isStart) {
        _start = minutes;
      } else {
        _end = minutes;
      }
    });
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      await client.preferences.savePreferences(
        _start,
        _end,
        _break,
        now.timeZoneName,
        now.timeZoneOffset.inMinutes,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) showMessage(context, friendlyError(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 0, 24, 24 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Scheduling preferences', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Working day starts'),
            trailing: Text(_toTime(_start).format(context)),
            onTap: () => _pick(true),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Working day ends'),
            trailing: Text(_toTime(_end).format(context)),
            onTap: () => _pick(false),
          ),
          DropdownButtonFormField<int>(
            initialValue: _break,
            decoration: const InputDecoration(labelText: 'Break between tasks'),
            items: [
              for (final m in const [0, 5, 10, 15, 30])
                DropdownMenuItem(value: m, child: Text('$m minutes')),
            ],
            onChanged: (v) => setState(() => _break = v ?? 10),
          ),
          const SizedBox(height: 8),
          Text(
            'Time zone: ${DateTime.now().timeZoneName} (taken from this device)',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(_saving ? 'Saving...' : 'Save'),
            ),
          ),
        ],
      ),
    );
  }
}
