-- Membuat database baru
CREATE DATABASE db_rs_sejahtera

-- Membuat 5 tabel
CREATE TABLE poliklinik (
	id_poli INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nama_poli VARCHAR(50) NOT NULL UNIQUE,
	gedung VARCHAR(50) NOT NULL
);

CREATE TABLE pasien (
	id_pasien INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nik VARCHAR(16) NOT NULL UNIQUE,
	nama_pasien VARCHAR(150) NOT NULL,
	jenis_kelamin CHAR(1) CHECK (jenis_kelamin IN ('L', 'P'))
);

CREATE TABLE dokter (
	id_dokter INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nama_dokter VARCHAR(150) NOT NULL,
	no_izin_praktek VARCHAR(30) UNIQUE,
	pengalaman_tahun INT DEFAULT 0 CHECK (pengalaman_tahun >= 0),
	id_poli INT,
	CONSTRAINT fk_dokter_poliklinik
		FOREIGN KEY (id_poli)
		REFERENCES poliklinik (id_poli)
);

CREATE TABLE rekam_medis (
	id_rm INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	keluhan TEXT NOT NULL,
	biaya_pemeriksaan NUMERIC(10,2) DEFAULT 150000,
	id_pasien INT,
	CONSTRAINT fk_rekam_medis_pasien
		FOREIGN KEY (id_pasien)
		REFERENCES pasien (id_pasien),
	id_dokter INT,
	CONSTRAINT fk_rekam_medis_dokter
		FOREIGN KEY (id_dokter)
		REFERENCES dokter (id_dokter)
);

CREATE TABLE resep_obat (
	id_resep INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nama_obat VARCHAR(100) NOT NULL,
	jumlah INT CHECK (jumlah > 0),
	id_rm INT,
	CONSTRAINT fk_resep_obat_medis
		FOREIGN KEY (id_rm)
		REFERENCES rekam_medis (id_rm)
);

-- Lihat tabel
SELECT table_name FROM information_schema.tables
WHERE table_schema = 'public';

-- Lihat tabel beserta deskripsinya
SELECT table_name, column_name,
	data_type, character_maximum_length, is_nullable
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

-- Menambahkan kolom baru (gol_darah)
ALTER TABLE pasien
ADD COLUMN gol_darah CHAR(2);

-- Mengubah tipe data kolom (nama_obat)
ALTER TABLE resep_obat
ALTER COLUMN nama_obat TYPE TEXT;

-- Menghapus kolom (gedung) pada tabel poliklinik
ALTER TABLE poliklinik
DROP COLUMN gedung;
-- DROP COLUMN IF EXISTS gedung;

-- Menghapus tabel dari database
DROP TABLE resep_obat, rekam_medis;

-- DROP TABLE resep_obat;
-- DROP TABLE rekam_medis;

-- DROP TABLE rekam_medis CASCADE;
-- DROP TABLE resep_obat;

/*
NOTE:
Tabel resep_obat merupakan child table dari tabel rekam_medis.
Oleh karena itu, child table harus lebih dulu dihapus,
namun bisa diakali dengan menggunakan perintah CASCADE.
*/