# E-Raport MDTU V3.17 — GitHub Pages + Supabase (uji awal)

## Deploy
1. Upload isi folder ini ke repository GitHub (root): `index.html`, `panduan/`, `supabase_setup.sql`, `README.md`.
2. GitHub > Settings > Pages > Deploy from branch > main > /(root) > Save.
3. Akses `https://USERNAME.github.io/NAMA-REPO/`.

## Supabase
1. Buat project Supabase dan jalankan `supabase_setup.sql` di SQL Editor.
2. Jalankan contoh INSERT organisasi pada komentar akhir SQL, catat UUID hasilnya.
3. Buat user lewat Supabase Authentication > Users. Masukkan user_id ke tabel `eraport_members` dengan role `admin` atau `operator` (guru hanya dapat membaca dalam prototipe ini).
4. Buka panel `Sinkronisasi Instansi` pada E-Raport, isi Project URL, anon/publishable key, UUID organisasi, email, password.
5. Login > Ambil data > isi data E-Raport > Kirim data. Ulangi Ambil data sebelum mulai mengedit di laptop lain.

## Penting
- Ini **sinkronisasi manual satu dokumen JSON**, bukan sinkronisasi real-time/per-siswa. Konflik revisi ditolak; jangan mengedit bersamaan.
- Setelah Ambil data, buka ulang menu agar tampilan diperbarui. Jangan refresh halaman sebelum Kirim data karena sesi login panel ini tidak dipertahankan.
- Semua pengguna operator dapat mengubah seluruh database. Pembatasan per kelas/per guru belum tersedia.
- Data tetap tersimpan lokal dan perlu backup JSON rutin. Jangan simpan data santri atau service_role key dalam repo.
- GitHub Pages memerlukan internet untuk membuka website. Untuk offline, gunakan HTML lokal.
- Sebelum penggunaan produksi, lakukan uji akses, uji multi-operator, dan tinjauan privasi serta backup.
