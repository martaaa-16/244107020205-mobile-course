import 'package:flutter_test/flutter_test.dart';

import 'package:week3_todo/providers/stats_provider.dart';

void main() {
  // Test sukses memastikan notifier mengembalikan tiga data statistik.
  test('fetchStats mengembalikan tiga item saat server berhasil', () async {
    final notifier = StatsNotifier(skipDelay: true);

    final result = await notifier.fetchStats(failureRoll: 0.9);

    expect(result, hasLength(3));
    expect(result.first.label, 'Pengguna aktif');
  });

  // Test gagal memaksa roll di bawah 0.3 agar tidak bergantung pada random.
  test('fetchStats melempar error saat simulasi server gagal', () async {
    final notifier = StatsNotifier(skipDelay: true);

    expect(
      () => notifier.fetchStats(failureRoll: 0.1),
      throwsA(isA<Exception>()),
    );
  });
}
