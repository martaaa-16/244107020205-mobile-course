# AI Verification Checklist & Keputusan Teknis

Dokumen ini berisi hasil verifikasi mandiri terhadap draf kode AI untuk `PushService` pada aplikasi **Campus Notify**, catatan perbedaan platform, batasan `BuildContext`, serta daftar perbaikan manual.

---

## 📋 Checklist Verifikasi Draf AI

| No | Parameter Verifikasi | Status | Catatan / Hasil Verifikasi |
|---:|:---|:---:|:---|
| 1 | **Background Handler Top-Level** | ✅ Lolos | `firebaseMessagingBackgroundHandler` dideklarasikan sebagai fungsi *top-level* di luar class dengan anotasi `@pragma('vm:entry-point')`. |
| 2 | **`onTokenRefresh` ke Backend** | ✅ Lolos | Listener `onTokenRefresh` memanggil `onToken(newToken)` yang mengeksekusi request HTTP `POST /devices` ke backend, bukan sekadar `print()`. |
| 3 | **Foreground Local Notification** | ✅ Lolos | Menggunakan `flutter_local_notifications` secara manual di dalam handler `FirebaseMessaging.onMessage` untuk menampilkan Heads-up banner saat aplikasi aktif. |
| 4 | **Navigasi 3 App States** | ✅ Lolos | Mendukung penanganan rute navigasi `data.route` pada 3 state: Foreground (`onDidReceiveNotificationResponse`), Background (`onMessageOpenedApp`), dan Terminated (`getInitialMessage`). |
| 5 | **Keamanan Token & Secret** | ✅ Lolos | Token FCM dipotong saat di-log (`token.substring(0, 12) + '...'`), tidak di-hardcode, dan JWT disimpan di `FlutterSecureStorage`. |

---

## ⚡ Perbedaan Platform: Android 13+ vs iOS

### 1. Android (Android 13 / API 33+)
- **Izin Notifikasi Runtime**: Android 13 membutuhkan izin `POST_NOTIFICATIONS` yang harus diminta secara eksplisit saat runtime.
- **Notification Channel**: Wajib membuat `AndroidNotificationChannel` dengan tingkat `Importance.max` dan `Priority.high` agar banner heads-up melayang di atas aplikasi aktif.
- **Small Icon**: Diperlukan resource icon bawaan (misal `@mipmap/ic_launcher`) pada `AndroidInitializationSettings`.

### 2. iOS (Apple Push Notification service / APNs)
- **APNs Token**: Membutuhkan konfigurasi APNs Certificate / Key pada Firebase Console.
- **Foreground Presentation**: Notifikasi foreground diatur melalui `setForegroundNotificationPresentationOptions(alert: true, badge: true, sound: true)`.
- **Darwin Settings**: Pengaturan izin awal diminta melalui `DarwinInitializationSettings`.

---

## 🚫 Batasan Akses `BuildContext`

`FirebaseMessaging` handler dan callback `flutter_local_notifications` dapat dipanggil saat aplikasi berada di background atau saat aplikasi baru terbangun (*cold start*), di mana pohon widget Flutter belum selesai terbangun.

1. **Dilarang Menggunakan `BuildContext`**: Memanggil `Navigator.of(context)` atau `GoRouter.of(context)` langsung di dalam event listener async atau background handler akan menyebabkan crash (`Looking up a deactivated widget's ancestor is unsafe`).
2. **Solusi Navigasi**: Menggunakan callback fungsi `void Function(String route) onNavigate` yang dikoneksikan ke instance global `GoRouter` atau `GlobalKey<NavigatorState>`.

---

## 🛠️ Daftar Perbaikan & Keputusan Teknis Manual

1. **Pemisahan Responsibilitas Provider**:
   - Provider Riverpod memisahkan layer registrasi token dan layer navigasi router agar `PushService` murni menangani pesan FCM tanpa tergantung secara langsung pada widget tree.
2. **Penanganan Kanal Notifikasi Android (V2)**:
   - Membuat channel ID khusus `pengumuman_channel_v2` untuk memastikan OS Android menerapkan konfigurasi `Importance.max` tanpa terhalang cache channel ID lama.
3. **Penyederhanaan Callback Rute**:
   - Rute diparsing secara aman dari `message.data['route']` dengan fallback ke `'/'` apabila payload route kosong.

---

## 📊 Tabel Hasil Pengujian 3 App States

| App State | Screenshot | Hasil Observasi & Action |
| :--- | :---: | :--- |
| **Foreground** | `screenshot/5.png` | Banner lokal dipicu oleh `flutter_local_notifications`. Klik banner mengarahkan pengguna ke `/pengumuman/3`. |
| **Background** | `screenshot/4.png` | Banner sistem OS muncul. Klik banner ditangkap oleh `onMessageOpenedApp` dan membuka rute tujuan. |
| **Terminated** | `screenshot/6.png` | Aplikasi mati total. Banner diklik &rarr; aplikasi dipicu lewat `getInitialMessage` dan langsung menuju rute tujuan. |
