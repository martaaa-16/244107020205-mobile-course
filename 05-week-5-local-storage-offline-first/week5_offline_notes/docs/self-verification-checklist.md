# Checklist Verifikasi Mandiri

| Checklist | Status | Bukti atau cara verifikasi |
| --- | --- | --- |
| UI tidak memanggil SQLite/SharedPreferences langsung | Lulus secara struktur | UI memakai provider; akses storage berada di `NoteRepository` dan `PrefsRepository`. |
| Baca catatan saat offline | Lulus | `notesProvider` memanggil repository lokal dan daftar tetap berasal dari SQLite. |
| Tambah catatan saat offline | Lulus | Tombol `+` memakai `noteRepositoryProvider`; catatan baru disimpan dengan `dirty = true`. |
| Hapus catatan saat offline | Lulus secara struktur | `NoteTile` memanggil `NoteRepository.deleteNote()` melalui provider dan meng-invalidasi daftar serta badge. |
| Badge dirty sebelum/sesudah sync akurat | Lulus pada skenario demo | `countDirty()` membaca flag `dirty`; `syncNotes` menandai bersih setelah simulasi sukses. |
| Cache posts tampil tanpa internet | Lulus secara struktur | `loadPostsCacheFirst` mengembalikan cache lebih dahulu; refresh Dio di background bersifat best effort. |
| `flutter analyze` tanpa issue | Lulus pada verifikasi terakhir | Jalankan `flutter analyze` dari folder project. |
| Semua test lulus | Perlu dijalankan ulang setelah perubahan hapus | Jalankan `flutter test`; test model, fake repository, NoteTile, dan detail tersedia di folder `test/`. |
| Hasil AI terdokumentasi | Lulus | Prompt, output awal, keputusan storage, dan verifikasi ada di folder `docs/`. |

## Skenario Manual Offline

1. Jalankan aplikasi, buat catatan, dan pastikan badge menunjukkan `Dirty: 1`.
2. Aktifkan `Force offline`.
3. Buka ulang aplikasi, baca catatan dari cache lokal, lalu tekan ikon hapus
   pada catatan. Daftar dan badge diperbarui dari provider lokal.
4. Matikan `Force offline` dan tekan `Sync now` untuk memeriksa perubahan dirty
   menjadi `0` pada catatan yang masih tersisa.

Pada demo ini server tulis masih disimulasikan dengan delay satu detik. Dalam
aplikasi nyata, `markAllSynced()` hanya boleh dipanggil setelah respons server
berhasil.