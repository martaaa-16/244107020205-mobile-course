# Checklist Verifikasi Mandiri - Campus Notify

Dokumen ini berisi hasil verifikasi mandiri terhadap seluruh kriteria teknis dan keamanan aplikasi **Campus Notify** (Modul 06: Authentication, Security & FCM).

---

## 📋 Table Verification Checklist

| No | Kriteria Verifikasi | Status | Bukti / Catatan Implementasi |
|---:|:---|:---:|:---|
| 1 | **Keamanan Token & Storage** | ✅ Lolos | Token JWT disembunyikan dan disimpan secara aman di `FlutterSecureStorage` ([`token_store.dart`](../lib/data/token_store.dart)). Token FCM di-log dan ditampilkan di UI secara terpotong (12 karakter pertama + `...`), tidak di-hardcode. |
| 2 | **Handling 401 & Auto Refresh** | ✅ Lolos | `Dio` Interceptor ([`api_client.dart`](../lib/data/api_client.dart)) menangkap 401, mencoba refresh token sekali lalu me-retry request. Jika refresh gagal, sesi dibersihkan via `store.clear()` dan pengguna dipaksa login ulang. |
| 3 | **Pengujian 3 App States** | ✅ Lolos | State *Foreground*, *Background*, & *Terminated* teruji sepenuhnya dan terdokumentasi dengan matriks screenshot di [`README.md`](../README.md#matriks-pengujian-wajib). Klik notifikasi terbukti masuk ke rute tujuan. |
| 4 | **Pesan Topic vs Personal Token** | ✅ Lolos | Pengiriman pesan masal/pengumuman kampus menggunakan *Topic Subscription* (`pengumuman-kampus`), sedangkan notifikasi khusus akun menggunakan FCM Device Token unik. |
| 5 | **Analisis Kode & Unit Testing** | ✅ Lolos | `flutter analyze` 100% bersih tanpa warning/issue. Seluruh unit test pada `flutter test` ([`test/auth_push_test.dart`](../test/auth_push_test.dart)) lulus 100%. |

---

## 🔒 1. Keamanan Token & Storage
- Token JWT access dan refresh tidak pernah disimpan pada `SharedPreferences` yang mudah dibaca. Penulisan dan pembacaan dilakukan via secure storage (`FlutterSecureStorage`).
- FCM Device Token tidak pernah dicetak dalam bentuk string utuh di log produksi atau screenshot pelaporan untuk mencegah eksploitasi token.

## 🔄 2. Penanganan Respon 401 & Token Renewal
- Menggunakan interceptor `onError` pada Client HTTP (`Dio`).
- Jika request mengembalikan `statusCode == 401`, interceptor otomatis mengambil refresh token, meminta token akses baru ke backend, dan melanjutkan request awal yang sempat gagal.
- Apabila refresh token sudah tidak valid/kadaluarsa, sistem memanggil `store.clear()` dan secara otomatis memicu redirect ke halaman login via `authStateProvider`.

## 📲 3. Pengujian Tiga State Aplikasi
- **Foreground**: Banner Heads-Up lokal dipicu oleh `flutter_local_notifications`.
- **Background**: Banner sistem OS bawaan ditangkap via `onMessageOpenedApp`.
- **Terminated**: Launch aplikasi via tap notifikasi ditangkap pada `getInitialMessage`.

## 📢 4. Strategi Pengiriman: Topic vs Device Token
- **Broadcast/PubSub**: Digunakan untuk pengumuman umum kampus dengan fungsi `subscribeToTopic('pengumuman-kampus')`.
- **Personal Push**: Digunakan untuk pesan yang ditargetkan secara personal ke perangkat tertentu dengan mendaftarkan token FCM unik perangkat ke backend via `POST /devices`.

## ✅ 5. Hasil Verifikasi Kode & Testing
- Command `flutter analyze` telah dijalankan dan menghasilkan `No issues found!`.
- Command `flutter test` telah dijalankan dan menghasilkan `All tests passed!`.
