# Perbaikan dan Penjelasan Kode

## Perbaikan yang Dilakukan

- Memindahkan `PagedPostsNotifier` ke level top-level karena Dart tidak mengizinkan class di dalam class.
- Menghapus kurung kurawal ekstra pada akhir file pagination.
- Menggunakan `PagedPostPage` sebagai `home` di `main.dart`.
- Menyesuaikan provider komentar dengan API Riverpod yang tersedia: `FamilyAsyncNotifier<List<Comment>, int>` dan `AsyncNotifierProvider.family`.
- Memusatkan `baseUrl`, `connectTimeout`, dan `receiveTimeout` di `lib/data/api_client.dart`.
- Menambahkan test untuk field JSON yang hilang dan bernilai `null`.

## Penjelasan Per Bagian Kode

### `Comment`

- Constructor `const` membuat object immutable dan menerima lima field wajib.
- `postId` dan `id` mengubah nilai `num` menjadi `int`; nilai hilang atau `null` menjadi `0`.
- `name`, `email`, dan `body` memakai cast nullable; nilai hilang atau `null` menjadi string kosong.
- `toJson()` mengembalikan object ke bentuk JSON API.

### `CommentRepository`

- Repository menerima instance `Dio` dari provider, sehingga UI tidak memanggil Dio secara langsung.
- `fetchComments(postId)` mengirim `GET /comments` dengan query `postId`.
- `response.data ?? []` mencegah data null diproses sebagai list.
- `whereType` hanya mengambil object map yang valid, lalu mengubahnya menjadi `Comment`.
- Timeout 10 detik berasal dari `BaseOptions` pada shared client, bukan dari method repository.

### `commentsProvider`

- `commentRepositoryProvider` menyediakan repository dengan Dio terpusat.
- `CommentsNotifier.build(postId)` mengambil komentar berdasarkan parameter post.
- Exception dari repository dibiarkan naik ke Riverpod dan otomatis menjadi `AsyncError`.
- `commentsProvider` memakai family agar setiap `postId` memiliki state sendiri.
- `friendlyErrorMessage` pada `providers.dart` memetakan timeout, connection error, 404, 401/403, dan response server lainnya termasuk 500.

### Test

Test memastikan `fromJson` tidak crash ketika `postId` bernilai null serta `email` dan `body` tidak dikirim. Nilai default yang diharapkan diverifikasi dengan `expect`.
