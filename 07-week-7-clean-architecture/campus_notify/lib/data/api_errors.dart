import 'package:dio/dio.dart';

String getFriendlyErrorMessage(Object error) {
  if (error is DioException) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi waktu habis (timeout). Silakan periksa jaringan Anda.';
      case DioExceptionType.connectionError:
        return 'Perangkat offline atau gagal terhubung ke server.';
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        if (statusCode == 401) {
          return 'Sesi Anda telah berakhir. Silakan login kembali (401).';
        } else if (statusCode == 403) {
          return 'Anda tidak memiliki akses ke layanan ini (403).';
        } else if (statusCode == 404) {
          return 'Data tidak ditemukan di server (404).';
        } else if (statusCode != null && statusCode >= 500) {
          return 'Terjadi kesalahan pada server kampus (500).';
        }
        return 'Gagal memproses permintaan (Status: $statusCode).';
      case DioExceptionType.cancel:
        return 'Permintaan dibatalkan.';
      default:
        return 'Terjadi kesalahan jaringan yang tidak diketahui.';
    }
  }
  return error.toString().replaceAll('Exception: ', '');
}
