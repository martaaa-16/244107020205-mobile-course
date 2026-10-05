import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/note_providers.dart';

class NoteDetailPage extends ConsumerWidget {
  const NoteDetailPage({super.key, required this.noteId});

  final int noteId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.watch(noteDetailProvider(noteId));

    return Scaffold(
      appBar: AppBar(title: const Text('Note detail')),
      body: note.when(
        data: (item) {
          if (item == null) {
            return const Center(child: Text('Note not found'));
          }
          return ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text(
                item.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(item.body),
              const SizedBox(height: 24),
              Text('Updated: ${item.updatedAt.toLocal()}'),
              const SizedBox(height: 8),
              Text(
                item.dirty ? 'Belum tersinkron' : 'Sudah tersinkron',
                style: TextStyle(
                  color: item.dirty ? Colors.orange.shade800 : Colors.teal,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
        error: (error, _) => Center(child: Text('Error: $error')),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
