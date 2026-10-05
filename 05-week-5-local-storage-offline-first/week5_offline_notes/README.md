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

