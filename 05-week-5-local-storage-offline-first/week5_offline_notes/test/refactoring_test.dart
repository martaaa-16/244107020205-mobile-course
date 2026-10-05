import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:week5_offline_notes/data/local/note.dart';
import 'package:week5_offline_notes/data/note_providers.dart';
import 'package:week5_offline_notes/pages/note_detail_page.dart';
import 'package:week5_offline_notes/widgets/note_tile.dart';

void main() {
  final note = Note(
    id: 7,
    title: 'Offline title',
    body: 'Offline body',
    updatedAt: DateTime(2026, 10, 5),
    dirty: true,
  );

  testWidgets('NoteTile shows the unsynced badge', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: NoteTile(note: note)),
      ),
    );

    expect(find.text('Belum tersinkron'), findsOneWidget);
  });

  testWidgets('detail page reads the note provider by id', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          noteDetailProvider(note.id!).overrideWith((ref) async => note),
        ],
        child: const MaterialApp(home: NoteDetailPage(noteId: 7)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Offline title'), findsOneWidget);
    expect(find.text('Offline body'), findsOneWidget);
    expect(find.text('Belum tersinkron'), findsOneWidget);
  });
}
