# LAB-BASDAT-10-2026

Repository untuk kegiatan **Praktikum Basis Data**.

## 1. Initial Setup

Setup ini dilakukan **satu kali** sebelum pengumpulan tugas.

### 1.1 Fork Repository

Klik **Fork** pada repository utama:

```text
Aepra/LAB-BASDAT-10-2026
```

Hasil fork akan berada di akun GitHub masing-masing:

```text
username-kamu/LAB-BASDAT-10-2026
```

### 1.2 Clone Repository

Buat atau tentukan folder untuk menyimpan repository.

Contoh:

```text
D:\PraktikumBasdat
```

Buka **Terminal** di dalam folder tersebut, kemudian jalankan:

```bash
git clone <URL-REPOSITORY-HASIL-FORK>
cd LAB-BASDAT-10-2026
```

Contoh:

```bash
git clone https://github.com/username-kamu/LAB-BASDAT-10-2026.git
```

### 1.3 Buat Branch NIM

Buat branch menggunakan NIM masing-masing:

```bash
git checkout -b H071251001
```

Ganti `H071251001` dengan NIM masing-masing.

Kemudian lakukan initial commit:

```bash
git add .
git commit -m "Initial commit - H071251001"
git push -u origin H071251001
```

Setelah berhasil, setup awal selesai.

> Branch NIM yang sudah dibuat akan digunakan untuk pengumpulan tugas berikutnya.

---

## 2. Pengumpulan Tugas

Setiap pengumpulan dilakukan menggunakan **branch NIM yang sudah dibuat pada Initial Setup**.

### 2.1 Siapkan Tugas

Buka folder repository yang sudah di-clone sebelumnya:

```text
D:\PraktikumBasdat\LAB-BASDAT-10-2026
```

Pastikan menggunakan branch NIM:

```bash
git checkout H071251001
```

Simpan tugas di dalam folder NIM:

```text
LAB-BASDAT-10-2026/
└── H071251001/
    └── Praktikum-01/
        └── jawaban.sql
```

### 2.2 Commit dan Push

Setelah tugas selesai:

```bash
git add .
git commit -m "[Praktikum 01] H071251001"
git push
```

### 2.3 Buat Pull Request

Buka repository hasil fork di GitHub, kemudian buat **Pull Request**.

Gunakan:

```text
Base repository  : Aepra/LAB-BASDAT-10-2026
Base branch      : main
Compare branch   : H071251001
```

Judul Pull Request:

```text
[H071251001] Praktikum 01
```

> Untuk pengumpulan berikutnya, gunakan branch NIM yang sama dan buat folder praktikum sesuai nomor tugas.

---

## Struktur Repository

Contoh:

```text
LAB-BASDAT-10-2026/
└── H071251001/
    ├── Praktikum-01/
    │   └── jawaban.sql
    ├── Praktikum-02/
    │   └── jawaban.sql
    └── Praktikum-03/
        └── jawaban.sql
```

**Branch:** NIM masing-masing
**Folder tugas:** `NIM/Praktikum-XX/`
**Pengumpulan:** Pull Request
