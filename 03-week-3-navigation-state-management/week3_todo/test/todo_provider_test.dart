import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:week3_todo/providers/todo_provider.dart';

void main() {
  test('incompleteTodosProvider hanya mengembalikan tugas belum selesai', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final notifier = container.read(todoListProvider.notifier);
    notifier.add('Belum selesai');
    notifier.add('Selesai');
    notifier.toggle(1);

    final incompleteTodos = container.read(incompleteTodosProvider);

    expect(incompleteTodos, hasLength(1));
    expect(incompleteTodos.single.title, 'Belum selesai');
  });
}
