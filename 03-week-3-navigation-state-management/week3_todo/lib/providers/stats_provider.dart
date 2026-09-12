import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Model kecil yang mewakili satu baris statistik pada halaman.
class Statistic {
  const Statistic({required this.label, required this.value});

  final String label;
  final String value;
}

// AsyncNotifier mengelola status loading, data, dan error secara otomatis.
class StatsNotifier extends AsyncNotifier<List<Statistic>> {
  // Opsi ini membuat unit test tidak perlu menunggu simulasi jaringan.
  StatsNotifier({this.skipDelay = false, this.failureRoll});

  @visibleForTesting
  final bool skipDelay;

  @visibleForTesting
  final double? failureRoll;

  // build dipanggil Riverpod saat provider pertama kali dibaca atau di-invalidate.
  @override
  Future<List<Statistic>> build() => fetchStats();

  // Simulasi pengambilan data dengan peluang gagal sebesar 30 persen.
  Future<List<Statistic>> fetchStats({double? failureRoll}) async {
    if (!skipDelay) {
      await Future<void>.delayed(const Duration(seconds: 2));
    }

    // Nilai 0.0-0.3 dianggap gagal; failureRoll memudahkan test deterministik.
    final roll = failureRoll ?? this.failureRoll ?? Random().nextDouble();
    if (roll < 0.3) {
      throw Exception('Server statistik tidak dapat dihubungi.');
    }

    // Data sukses selalu terdiri dari tiga item sesuai kebutuhan UI.
    return const [
      Statistic(label: 'Pengguna aktif', value: '1.248'),
      Statistic(label: 'Pesanan bulan ini', value: '386'),
      Statistic(label: 'Pendapatan', value: 'Rp24,8 jt'),
    ];
  }
}

// Provider tunggal yang menjadi sumber state untuk StatsPage.
final statsProvider = AsyncNotifierProvider<StatsNotifier, List<Statistic>>(
  StatsNotifier.new,
);
