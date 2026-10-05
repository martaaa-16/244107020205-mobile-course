import 'repositories/note_repository.dart';

Future<int> syncNotes(NoteRepository repo, {bool forceOffline = false}) async {
  if (forceOffline) return 0;

  final dirtyCount = await repo.countDirty();
  if (dirtyCount == 0) return 0;

  await Future.delayed(const Duration(seconds: 1));
  await repo.markAllSynced();
  return dirtyCount;
}
