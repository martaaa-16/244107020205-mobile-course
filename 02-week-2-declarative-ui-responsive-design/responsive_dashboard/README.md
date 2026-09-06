# Praktikum: dashboard responsif

<p align="center">
  <img src="img/1.png" width="300">
</p>

## Menambahkan interaksi: StatefulWidget dan Cupertino

<table>
  <tr>
    <td align="center">
      <img src="img/2.png" width="300">
    </td>
    <td align="center">
      <img src="img/3.png" width="300">
    </td>
  </tr>
</table>

### Eksperimen warm-up

1. Ubah breakpoint dari `700` menjadi nilai lain dan amati perubahan jumlah kolom.

<p align="center">
  <img src="img/4.png" width="420">
</p>

> **Hasil:** Breakpoint diubah dari `700` menjadi `900`. Breakpoint `700` menentukan kapan dashboard berubah dari satu kolom menjadi dua kolom. Jika diubah menjadi `900`, layar dengan lebar 700-899 piksel tetap menggunakan satu kolom. Dua kolom baru ditampilkan pada layar dengan lebar minimal 900 piksel.

2. Ubah `themeMode` menjadi `ThemeMode.dark`, lalu kembalikan ke `ThemeMode.system`.

#### Ketika Diubah Menjadi `ThemeMode.dark`

<p align="center">
  <img src="img/5.png" width="420">
</p>

> **Hasil:** Tampilan aplikasi akan selalu menggunakan Dark Mode, meskipun `isDark` bernilai `false` dan switch berada dalam kondisi terang.

#### Ketika Dikembalikan Menjadi `ThemeMode.system`

<p align="center">
  <img src="img/6.png" width="420">
</p>

> **Hasil:** Tema aplikasi akan mengikuti pengaturan tema perangkat atau emulator.

3. Uji aplikasi dengan ukuran layar emulator yang berbeda.

<table>
  <tr>
    <td align="center">
      <img src="img/7.png" width="300"><br>
      <b>540 x 960 px</b>
    </td>
    <td align="center">
      <img src="img/8.png" width="300"><br>
      <b>1080 x 1920 px</b><br>
    </td>
    <td align="center">
      <img src="img/9.png" width="300"><br>
      <b>720 x 1280 px</b>
    </td>
  </tr>
  <tr>
    <td align="center">
      <img src="img/10.png" width="300"><br>
      <b>900 x 1600 px</b>
    </td>
    <td align="center">
      <img src="img/11.png" width="300"><br>
      <b>1440 x 2560 px</b>
    </td>
    <td></td>
  </tr>
</table>

> **Hasil:** Setelah diuji pada beberapa ukuran layar emulator, aplikasi dapat menyesuaikan jumlah kolom berdasarkan lebar layar. Jika lebar layar kurang dari 700 px, dashboard menampilkan satu kolom. Jika lebar layar 700 px atau lebih, dashboard menampilkan dua kolom. Hal ini menunjukkan bahwa `LayoutBuilder` membuat tampilan aplikasi responsif terhadap ukuran layar.

4. Tambahkan `Semantics` atau label yang bermakna pada elemen penting bagi screen reader.

<table>
  <tr>
    <td align="center">
      <img src="img/12.png" width="300"><br>
      <b>Menambahkan Semantics pada Dark Mode Switch</b>
    </td>
    <td align="center">
      <img src="img/13.png" width="300"><br>
      <b>Menambahkan Semantics pada DashboardCard</b>
    </td>
  </tr>
</table>