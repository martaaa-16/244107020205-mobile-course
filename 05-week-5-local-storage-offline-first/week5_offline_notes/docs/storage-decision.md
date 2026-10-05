# Keputusan Storage Final

## Skema 1000+ catatan

```text
notes
├── id          INTEGER PRIMARY KEY AUTOINCREMENT
├── title       TEXT NOT NULL
├── body        TEXT NOT NULL DEFAULT ''
├── updated_at  TEXT NOT NULL
└── dirty       INTEGER NOT NULL DEFAULT 0

cached_posts
├── id          INTEGER PRIMARY KEY
├── payload     TEXT NOT NULL
└── cached_at   TEXT NOT NULL
```

Query utama:

```sql
SELECT * FROM notes ORDER BY updated_at DESC;
SELECT COUNT(*) FROM notes WHERE dirty = 1;
UPDATE notes SET dirty = 0 WHERE dirty = 1;
```

Untuk jumlah yang jauh lebih besar dari 1000, tambahkan index pada
`updated_at` dan gunakan pagination. Untuk codelab ini, 1000+ baris masih
lebih tepat dikelola sebagai tabel SQLite daripada satu nilai JSON di
SharedPreferences.

## Verifikasi terhadap checklist AI

- **Daftar catatan di SharedPreferences:** ditolak. SharedPreferences hanya
  digunakan oleh `PrefsRepository` untuk preferensi tema.
- **Antrean sync:** didukung. Tabel `notes` memiliki `dirty` dan `updated_at`;
  `syncNotes` menghitung dirty, melakukan simulasi upload, lalu menandai bersih.
- **Klaim real-time:** tidak diasumsikan. Provider saat ini menggunakan
  `FutureProvider` dan invalidate eksplisit, bukan stream database. Stream
  real-time akan menjadi alasan memilih Drift bila requirement itu muncul.
- **Boilerplate:** `sqflite` sudah dipasang dan diverifikasi bersama migrasi
  schema, repository, adapter model, provider, serta setup SQLite Web. Hive dan
  Drift tidak dipasang karena tidak dipilih untuk aplikasi ini; estimasi
  boilerplate keduanya pada tabel awal adalah perbandingan desain, bukan hasil
  benchmark instalasi.
## Jawaban Final AI Challenge

| Pilihan | Kompleksitas query dan relasi | Reaktivitas | Type-safety | Boilerplate | Testing | Keputusan |
| --- | --- | --- | --- | --- | --- | --- |
| SharedPreferences | Sangat rendah; tidak cocok untuk koleksi atau relasi | Tidak ada stream database | Rendah, berdasarkan tipe value dan key | Paling kecil | Mudah untuk key-value | Dipakai untuk preferensi tema saja |
| Hive | Query sederhana; relasi perlu dikelola manual | Listener tersedia | Model/adapter membantu, tetapi schema tidak sekuat SQL | Rendah-sedang | Box mudah diuji | Tidak dipilih karena catatan membutuhkan query dan sync metadata |
| sqflite (SQLite) | SQL, transaksi, index, dan relasi lengkap | Tidak built-in; provider di-invalidate eksplisit | Mapping model ditulis manual | Sedang | Mudah dengan database adapter/test fixture | **Dipilih untuk catatan** |
| Drift | SQL, relasi, migrasi, dan query terstruktur | Kuat melalui `watch()` dan stream | Paling tinggi karena generated code | Sedang-tinggi | Baik, tetapi perlu generator | Alternatif terbaik bila aplikasi membutuhkan stream real-time |

**Keputusan final:** gunakan `SharedPreferences` untuk preferensi tema dan
SQLite melalui `sqflite` untuk catatan. Daftar catatan tidak disimpan di
SharedPreferences karena koleksi JSON besar rapuh untuk query, update parsial,
dan antrean sinkronisasi.

## Tabel keputusan

| Kebutuhan | Pilihan final | Justifikasi |
| --- | --- | --- |
| Preferensi tema | `SharedPreferences` | Hanya menyimpan nilai kecil seperti `darkMode`; API key-value cukup, cepat, dan tidak membutuhkan relasi, query, atau stream database. |
| Catatan | SQLite melalui `sqflite` | Catatan adalah koleksi terstruktur yang dapat bertambah, perlu CRUD, urutan `updated_at`, transaksi, dan metadata sync (`dirty`). |


## Kesimpulan

Kombinasi `SharedPreferences + SQLite` dipilih karena setiap storage digunakan
untuk bentuk data yang sesuai. Preferensi tema bersifat kecil dan key-value,
sedangkan catatan memiliki struktur, lifecycle CRUD, dan metadata sinkronisasi.
Pilihan ini juga menjaga dependency dan boilerplate tetap proporsional untuk
codelab tanpa mengorbankan kemampuan offline-first.