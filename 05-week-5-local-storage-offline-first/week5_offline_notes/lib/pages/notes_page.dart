import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/note.dart';
import '../data/note_providers.dart';
import '../widgets/note_tile.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    final dirtyCount = ref.watch(dirtyCountProvider);
    final forceOffline = ref.watch(forceOfflineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Notes'),
        actions: [
          IconButton(
            onPressed: () => _addNote(context, ref),
            icon: const Icon(Icons.add),
            tooltip: 'Add note',
          ),
          dirtyCount.when(
            data: (count) => Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Center(child: Text('Dirty: $count')),
            ),
            error: (_, _) => const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text('Force offline'),
            subtitle: Text(forceOffline ? 'Sync disabled' : 'Sync enabled'),
            value: forceOffline,
            onChanged: (value) =>
                ref.read(forceOfflineProvider.notifier).set(value),
          ),
          dirtyCount.when(
            data: (count) =>
                _SyncStatus(forceOffline: forceOffline, dirtyCount: count),
            error: (_, _) => const SizedBox.shrink(),
            loading: () => const LinearProgressIndicator(),
          ),
          Expanded(
            child: notes.when(
              data: (items) => _NotesList(items: items),
              error: (error, _) => Center(child: Text('Error: $error')),
              loading: () => const Center(child: CircularProgressIndicator()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final count = await syncNotesFromProvider(ref);
          if (!context.mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                forceOffline
                    ? 'Offline mode: sync skipped'
                    : 'Synced $count note(s)',
              ),
            ),
          );
        },
        icon: const Icon(Icons.sync),
        label: Text(forceOffline ? 'Offline' : 'Sync now'),
      ),
    );
  }

  Future<void> _addNote(BuildContext context, WidgetRef ref) async {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New note'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: bodyController,
              decoration: const InputDecoration(labelText: 'Body'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (shouldSave != true || titleController.text.trim().isEmpty) return;
    await ref
        .read(noteRepositoryProvider)
        .addNote(
          title: titleController.text.trim(),
          body: bodyController.text.trim(),
        );
    ref.invalidate(notesProvider);
    ref.invalidate(dirtyCountProvider);
  }
}

class _SyncStatus extends StatelessWidget {
  const _SyncStatus({required this.forceOffline, required this.dirtyCount});

  final bool forceOffline;
  final int dirtyCount;

  @override
  Widget build(BuildContext context) {
    final isSynced = dirtyCount == 0;
    final color = forceOffline ? Colors.orange : Colors.teal;
    final title = forceOffline ? 'FORCE OFFLINE' : 'ONLINE MODE';
    final detail = forceOffline
        ? 'Local cache aktif - sync ditahan'
        : isSynced
        ? 'Semua catatan sudah tersinkron'
        : '$dirtyCount catatan menunggu sync';

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(forceOffline ? Icons.wifi_off : Icons.cloud_done, color: color),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
              Text(detail),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotesList extends StatelessWidget {
  const _NotesList({required this.items});

  final List<Note> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(child: Text('No cached notes'));
    }
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final note = items[index];
        return NoteTile(note: note);
      },
    );
  }
}
