import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../../../../core/failure.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../models/note_model.dart';

Future<Database> openNotesDb() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'notes.db');

  return openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE notes (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          body TEXT NOT NULL,
          updatedAt TEXT NOT NULL,
          dirty INTEGER NOT NULL DEFAULT 0
        )
      ''');
    },
  );
}

class NoteRepositoryImpl implements NoteRepository {
  final Future<Database> Function() openDb;

  NoteRepositoryImpl({required this.openDb});

@override
  Future<({Failure? failure, List<Note> notes})> fetchNotes() async {
    try {
      final db = await openDb();
      final maps = await db.query('notes', orderBy: 'updatedAt DESC');
      final notes = maps.map((map) => NoteModel.fromMap(map)).toList();
      return (failure: null, notes: notes);
    } catch (e) {
      return (failure: LocalFailure(e.toString()), notes: <Note>[]);
    }
  }

  @override
  Future<({Note? note, Failure? failure})> addNote({
    required String title,
    String body = '',
  }) async {
    try {
      final db = await openDb();
      final now = DateTime.now();
      final id = await db.insert('notes', {
        'title': title,
        'body': body,
        'updatedAt': now.toIso8601String(),
        'dirty': 0,
      });

      final newNote = Note(
        id: id,
        title: title,
        body: body,
        updatedAt: now,
      );

      return (note: newNote, failure: null);
    } catch (e) {
      return (note: null, failure: LocalFailure(e.toString()));
    }
  }
}