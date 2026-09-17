# Hasil Testing

Perintah yang dijalankan dari folder `week4_api`:

```powershell
flutter analyze
flutter test
```

## Hasil

| Pemeriksaan | Hasil |
|---|---|
| `flutter analyze` | Lulus tanpa issue |
| `flutter test` | Lulus |
| Test `Comment.fromJson` dengan field hilang/null | Lulus |
| Widget test halaman `PagedPostPage` | Lulus |

Catatan: pengujian runtime sebelumnya juga berhasil menjalankan aplikasi Android dan mengambil halaman pertama endpoint pagination dengan status HTTP 200.
