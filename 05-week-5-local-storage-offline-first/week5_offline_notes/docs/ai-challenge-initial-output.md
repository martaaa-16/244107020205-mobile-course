# Output Awal AI

## Rekomendasi awal

| Kebutuhan | Rekomendasi awal | Alasan |
| --- | --- | --- |
| Preferensi tema | SharedPreferences | Data kecil, key-value, tidak membutuhkan query atau relasi. |
| Catatan | SQLite melalui `sqflite` | Mendukung query terstruktur, index, transaksi, relasi, dan flag sync. |

## Perbandingan awal

| Storage | Query dan relasi | Stream/reactivity | Type-safety | Boilerplate | Testing |
| --- | --- | --- | --- | --- | --- |
| SharedPreferences | Sangat terbatas; tidak cocok untuk relasi | Tidak ada built-in stream | Rendah, nilai dibaca berdasarkan key | Rendah | Mudah untuk key-value, rapuh untuk koleksi |
| Hive | Query sederhana dan box; relasi manual | Listener tersedia | Ada adapter/type model, tetapi tidak sekuat schema SQL | Rendah sampai sedang | Cukup mudah dengan box test |
| sqflite | SQL lengkap, transaksi, index, relasi | Tidak built-in; perlu invalidate/notifier sendiri | Type-safety berada di model dan mapping aplikasi | Sedang | Mudah diuji dengan database test/in-memory adapter |
| Drift | SQL lengkap dengan relasi dan migrasi | Kuat melalui `watch()` dan stream | Tinggi melalui generated tables/queries | Sedang sampai tinggi | Baik, tetapi setup generator menambah langkah |

## Skema untuk 1000+ catatan

```text
notes
├── id INTEGER PRIMARY KEY
├── title TEXT NOT NULL
├── body TEXT NOT NULL
├── updated_at TEXT NOT NULL
└── dirty INTEGER NOT NULL DEFAULT 0

Index:
  INDEX notes_updated_at_idx ON notes(updated_at)
```

Untuk 1000+ catatan, daftar dibaca dengan query terurut dan sebaiknya memakai
pagination. `dirty` dan `updated_at` mempertahankan informasi yang diperlukan
untuk antrean sinkronisasi sederhana.

## Trade-off yang disampaikan AI

- SharedPreferences paling cepat dipasang, tetapi menyimpan daftar catatan
  sebagai satu JSON besar rapuh terhadap korupsi, update parsial, dan query.
- Hive lebih sederhana daripada SQL untuk object lokal, tetapi relasi, query
  kompleks, dan migrasi harus dirancang manual.
- sqflite memberi kontrol SQL dan ukuran dependency yang masuk akal, tetapi
  mapping row/model serta migrasi perlu ditulis sendiri.
- Drift memberi type-safety, generated query, migration tooling, dan stream,
  tetapi menambah generator, file generated, dan boilerplate awal.