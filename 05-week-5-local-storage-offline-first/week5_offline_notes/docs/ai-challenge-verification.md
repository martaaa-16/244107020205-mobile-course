# AI Challenge Verification

## Dependency dan migrasi yang diverifikasi

Perintah yang dijalankan pada project:

```bash
flutter pub get
flutter analyze
flutter test
flutter build web --debug
```

Dependency storage yang digunakan:

- `shared_preferences` untuk preferensi tema.
- `sqflite` untuk tabel `notes` dan `cached_posts`.
- `sqflite_common_ffi` untuk database pada Windows/Linux/macOS.
- `sqflite_common_ffi_web` serta `sqlite3.wasm` dan `sqflite_sw.js` untuk Chrome.

Schema yang diuji saat database baru dibuat:

```sql
CREATE TABLE notes(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT NOT NULL,
  body TEXT NOT NULL DEFAULT '',
  updated_at TEXT NOT NULL,
  dirty INTEGER NOT NULL DEFAULT 0
);
```

## Hasil

| Pemeriksaan | Hasil |
| --- | --- |
| `flutter pub get` | Berhasil |
| `flutter analyze` | No issues found |
| `flutter test` | Semua test lulus |
| `flutter build web --debug` | Berhasil |
| Cache-first posts | Cache dikembalikan sebelum refresh background |
| Offline notes | Catatan tetap tampil dari SQLite |
| Dirty sync | `Dirty: 1` berubah menjadi `Dirty: 0` setelah sync |

## Batasan yang ditemukan

Implementasi sync masih mensimulasikan upload dengan delay satu detik karena
codelab belum memiliki backend tulis. Karena itu, status Wi-Fi tidak menjadi
input sync; demo deterministik memakai toggle `forceOffline`. Dalam aplikasi
produksi, bagian delay diganti request REST dan `markAllSynced()` hanya
dijalankan setelah respons 2xx.