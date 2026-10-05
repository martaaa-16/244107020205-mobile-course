# Praktikum 3: Cache-first dan Sinkronisasi Catatan

## Skenario Verifikasi

1. Tekan tombol `+` di pojok kanan atas.
2. Isi judul dan isi catatan, lalu tekan `Save`.
3. Pastikan catatan tampil dengan status `Dirty`.
4. Aktifkan toggle `Force offline`.
5. Pastikan panel berubah menjadi `FORCE OFFLINE` dan sync ditahan.
6. Tekan `Sync` untuk memastikan muncul pesan `Offline mode: sync skipped`.
7. Matikan toggle `Force offline`.
8. Tekan `Sync now` dan tunggu simulasi upload selama satu detik.
9. Pastikan panel berubah menjadi `ONLINE MODE`, ikon catatan menjadi cloud, dan badge dirty menjadi `0`.

## Hasil Observasi

<table>
  <tr>
    <td align="center">
      <img src="screenshots/1.png" width="350"><br>
      <b>Gambar 1. Sebelum sync</b><br>
      Force offline aktif, catatan masih <code>Dirty: 1</code>, dan sync ditahan.
    </td>
    <td align="center">
      <img src="screenshots/2.png" width="350"><br>
      <b>Gambar 2. Sesudah sync</b><br>
      Online mode aktif, catatan sudah tersinkron, dan dirty menjadi <code>0</code>.
    </td>
  </tr>
</table>

| Kondisi | Catatan | Status dirty | Hasil |
| --- | --- | --- | --- |
| Sebelum sync | Tetap tampil dari cache lokal | `Dirty: 1` | Sync dilewati saat offline |
| Sesudah sync | Tetap tampil | `Dirty: 0` | Catatan ditandai synced |

## AI Challenge

Artefak prompt, output awal AI, keputusan storage, dan hasil verifikasi tersedia
di folder [`docs/`](docs/):

- [Prompt AI](docs/ai-challenge-prompt.md)
- [Output awal AI](docs/ai-challenge-initial-output.md)
- [Keputusan storage final](docs/storage-decision.md)
- [Hasil verifikasi](docs/ai-challenge-verification.md)
- [Checklist verifikasi mandiri](docs/self-verification-checklist.md)

## Error Umum dan Solusinya

| Gejala | Penyebab umum | Solusi |
| --- | --- | --- |
| `MissingPluginException` pada `shared_preferences` atau `sqflite` | Plugin baru ditambahkan, tetapi aplikasi hanya di-hot reload atau hot restart | Hentikan aplikasi sepenuhnya, lalu jalankan ulang `flutter run`. |
| `DatabaseException: table notes already exists` | Schema berubah tanpa migrasi atau database development masih memakai versi lama | Naikkan `version` database dan implementasikan `onUpgrade`; saat development, uninstall aplikasi untuk menghapus database lama. |
| Badge dirty tidak pernah menjadi `0` | `markAllSynced()` tidak dipanggil setelah simulasi/server berhasil | Panggil `markAllSynced()` hanya setelah server menjawab sukses, lalu verifikasi dengan `countDirty()`. |
| UI tidak refresh setelah tambah catatan | `notesProvider` tidak di-invalidasi setelah mutasi | Panggil `ref.invalidate(notesProvider)` setelah `addNote()` selesai. |
| Test menyentuh database sungguhan | Test menggunakan `NoteRepository` asli | Gunakan `FakeNoteRepository` dan override `noteRepositoryProvider`, seperti pada [note_test.dart](test/note_test.dart). |

