// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:week3_todo/main.dart';
import 'package:week3_todo/providers/stats_provider.dart';

void main() {
  testWidgets('menambah tugas baru', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MyApp()));
    expect(find.text('Belum ada tugas'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Kerjakan PR minggu 3');
    await tester.tap(find.text('Tambah'));
    await tester.pumpAndSettle();

    expect(find.text('Kerjakan PR minggu 3'), findsOneWidget);
  });

  testWidgets('aplikasi dimulai pada daftar ToDo', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          statsProvider.overrideWith(
            () => StatsNotifier(skipDelay: true, failureRoll: 0.9),
          ),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.text('Belum ada tugas'), findsOneWidget);
  });

  testWidgets('NavigationBar membuka halaman statistik', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          statsProvider.overrideWith(
            () => StatsNotifier(skipDelay: true, failureRoll: 0.9),
          ),
        ],
        child: const MyApp(),
      ),
    );

    await tester.tap(find.text('Statistik'));
    await tester.pumpAndSettle();

    expect(find.text('Statistik'), findsWidgets);
    expect(find.text('Pengguna aktif'), findsOneWidget);
  });
}
