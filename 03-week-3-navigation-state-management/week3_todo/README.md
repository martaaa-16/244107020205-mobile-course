# Praktikum 3 - Pengujian Tiga State

1. Salin kode di atas ke project ToDo Anda atau project terpisah, lalu jalankan. Amati tampilan loading selama 2 detik pertama.

2. Ubah `build()` sementara agar melempar error:

  ```dart
  throw Exception('Gagal terhubung ke server');
  ```

  Jalankan aplikasi dan amati UI error beserta tombol `Coba lagi`.

  **Jawaban:** Tombol `Coba lagi` belum dapat ditekan otomatis karena Flutter Driver Extension belum aktif. Namun, handler tombol sudah terpasang melalui `ref.invalidate(productsProvider)`.

<p align="center">
  <img src="screenshots/1.png" width="350">
</p>

3. Tekan tombol `Coba lagi`. `ref.invalidate` akan menjalankan ulang provider. Pulihkan kode, lalu pastikan state success tampil.

  **Jawaban:** State success berhasil tampil dengan daftar produk Keyboard, Mouse, dan Monitor.

<p align="center">
  <img src="screenshots/2.png" width="350">
</p>

4. Refleksikan: Mengapa menampilkan ulang data lama (stale data) dengan indikator refresh kadang lebih baik daripada mengosongkan layar? Kapan pola tersebut penting?

  **Jawaban:** Menampilkan data lama dengan indikator refresh lebih baik karena layar tetap berguna dan tidak kosong saat menunggu data baru.

  Pola ini penting untuk dashboard, daftar produk, feed, dan aplikasi dengan koneksi lambat. Namun, data lama sebaiknya tidak digunakan untuk informasi kritis seperti saldo, pembayaran, atau stok real-time.