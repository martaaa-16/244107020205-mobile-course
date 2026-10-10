# Praktikum 2: FCM, permission, dan token lifecycle

- Tampilkan token di halaman Debug (terpotong, mis. 12 karakter pertama + ...)
<img src="screenshot/1.jpeg" width="350"><br>

- Hapus data aplikasi / reinstall, dan tunjukkan bahwa onTokenRefresh memperbarui token di backend
<img src="screenshot/2.jpeg" width="350"><br>

## 4. Uji kirim pertama dari Firebase Console
1. Buka Firebase Console -> Messaging -> buat campaign notifikasi percobaan.
2. Masukkan title dan body, targetkan aplikasi Android Anda.
<img src="screenshot/3.png" width="350"><br>
3. Kirim saat aplikasi dalam state background: banner sistem harus muncul. Klik banner: aplikasi terbuka.
<img src="screenshot/fcm-console-test.jpeg" width="350"><br>
4. Catat hasilnya sebagai bukti screenshots/fcm-console-test.png.