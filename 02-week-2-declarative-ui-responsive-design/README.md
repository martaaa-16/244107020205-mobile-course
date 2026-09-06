# LAPORAN PRAKTIKUM JOBSHEET-02

- [Laporan Tugas Pertemuan 2](./pertemuan_2/README.md)
- [Laporan Jobsheet Pertemuan 2](./responsive_dashboard/README.md)


## Refleksi

### 1. Imperative dan Declarative

Imperative menjelaskan langkah-langkah untuk membangun atau mengubah UI. Declarative menjelaskan tampilan yang diinginkan berdasarkan state, lalu framework mengatur pembaruannya. Flutter menggunakan pendekatan declarative.

### 2. Penggunaan `Expanded`

`Expanded` membantu membagi sisa ruang di dalam `Row` atau `Column`. Namun, `Expanded` dapat menyebabkan overflow jika child lain terlalu lebar atau parent memiliki ukuran tak terbatas. Gunakan `Flexible`, batas ukuran, dan `TextOverflow.ellipsis` jika teks panjang.

### 3. Pengaruh Breakpoint dan Theme

Breakpoint mengubah susunan layout berdasarkan lebar layar, misalnya satu kolom pada layar sempit dan dua kolom pada layar lebar. Theme mengatur warna dan kontras, sehingga tema terang dan gelap dapat meningkatkan kenyamanan serta keterbacaan pengguna.

### 4. Verifikasi Rekomendasi AI

Rekomendasi AI diverifikasi dengan menjalankan `flutter analyze`, `flutter test`, dan widget test pada layar sempit serta lebar. Selain itu, diperiksa juga penggunaan `Semantics`, perilaku breakpoint, dukungan theme, kemungkinan overflow, dan ketersediaan widget pada Flutter stable.