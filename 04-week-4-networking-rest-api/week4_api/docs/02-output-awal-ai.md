# Output Awal AI

Output awal AI menghasilkan bagian-bagian berikut:

- `Comment` model di `lib/data/models/comment.dart`.
- `CommentRepository` di `lib/data/repositories/comment_repository.dart`.
- Provider komentar di `lib/data/comment_providers.dart`.
- Unit test `Comment.fromJson` di `test/comment_test.dart`.

## Masalah yang Ditemukan

1. Versi awal provider menggunakan bentuk family notifier yang tidak cocok dengan API Riverpod yang terpasang pada project.
2. Saat proses pagination sebelumnya, deklarasi notifier sempat berada di dalam class state. Dart tidak mengizinkan class bersarang.
3. Dokumentasi prompt, output, perbaikan, dan hasil testing belum dibuat di folder `docs/`.

Masalah tersebut diperbaiki sebelum hasil akhir dicatat.
