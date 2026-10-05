import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'local/note.dart';
import 'repositories/note_repository.dart';
import 'sync_notes.dart';

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepository();
});

class ForceOfflineNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void set(bool value) => state = value;
}

final forceOfflineProvider = NotifierProvider<ForceOfflineNotifier, bool>(
  ForceOfflineNotifier.new,
);

final notesProvider = FutureProvider<List<Note>>((ref) {
  return ref.watch(noteRepositoryProvider).fetchNotes();
});

final dirtyCountProvider = FutureProvider<int>((ref) {
  return ref.watch(noteRepositoryProvider).countDirty();
});

Future<int> syncNotesFromProvider(WidgetRef ref) async {
  final synced = await syncNotes(
    ref.read(noteRepositoryProvider),
    forceOffline: ref.read(forceOfflineProvider),
  );
  ref.invalidate(notesProvider);
  ref.invalidate(dirtyCountProvider);
  return synced;
}
