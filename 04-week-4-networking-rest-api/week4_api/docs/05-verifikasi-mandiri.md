# 7. Refactoring dan testing

## Verifikasi Mandiri

### Tidak Ada HTTP Sungguhan di Test

- UI tidak membuat instance `Dio` dan tidak memanggil endpoint secara langsung.
- Akses data produksi melewati repository dan provider.
- `test/post_test.dart` memakai `FakePostRepository`; `fetchPosts` dan `fetchPostsPage` dioverride sehingga tidak mengirim request.
- `test/widget_test.dart` meng-override `pagedPostsProvider` dengan `FakePagedPostsNotifier`, sehingga widget test tidak memulai HTTP.
- Test model komentar hanya menguji `fromJson` dan tidak membuat client jaringan.

### Checklist Perilaku

- UI memiliki empat state: loading memakai `CircularProgressIndicator`, error memakai `friendlyErrorMessage` dan tombol retry pada halaman list, empty memakai pesan data kosong, dan success menampilkan `PostTile`.
- Pagination menambahkan data dengan `items: [...currentItems, ...items]` tanpa mengganti seluruh halaman.
- Guard `if (state.isLoadingMore || !state.hasMore) return` mencegah request ganda dan request setelah data habis.
- Item terakhir menampilkan indikator saat `hasMore` bernilai true dan pesan `Semua data termuat.` saat false.
- `flutter analyze` lulus tanpa issue.
- `flutter test` lulus dengan seluruh test project.

### Hasil Terakhir

```text
flutter analyze: No issues found!
flutter test: All tests passed! (7 tests)
```
