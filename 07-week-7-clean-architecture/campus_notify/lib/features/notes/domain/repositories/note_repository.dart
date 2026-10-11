import 'package:campus_notify/features/notes/domain/entities/note.dart';
import 'package:campus_notify/core/failure.dart';

abstract class NoteRepository {
  Future<({List<Note> notes, Failure? failure})> fetchNotes();
  Future<({Note? note, Failure? failure})> addNote({
    required String title,
    String body = '',
  });
}
