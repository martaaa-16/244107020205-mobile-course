sealed class Failure {
  const Failure(this.message);
  final String message;

  static Failure fromObject(
    Object error, {
    String fallback = 'Terjadi kesalahan. Silakan coba lagi.',
  }) {
    if (error is Failure) return error;

    final raw = error.toString();
    final normalized = raw
        .replaceAll('Exception: ', '')
        .replaceAll('Error: ', '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (normalized.isEmpty) {
      return LocalFailure(fallback);
    }

    if (normalized.contains('Email') || normalized.contains('Kata sandi')) {
      return LocalFailure(normalized);
    }

    if (normalized.contains('token') || normalized.contains('refresh')) {
      return LocalFailure('Sesi Anda telah berakhir. Silakan login kembali.');
    }

    if (normalized.contains('database') ||
        normalized.contains('sqlite') ||
        normalized.contains('sqflite')) {
      return LocalFailure('Data lokal tidak bisa dibuka. Silakan coba lagi.');
    }

    if (normalized.contains('network') || normalized.contains('dio')) {
      return LocalFailure(
        'Koneksi gagal. Periksa jaringan Anda dan coba lagi.',
      );
    }

    if (normalized.contains('timeout')) {
      return LocalFailure('Koneksi waktu habis. Silakan coba lagi.');
    }

    return LocalFailure(fallback);
  }
}

class LocalFailure extends Failure {
  const LocalFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}
