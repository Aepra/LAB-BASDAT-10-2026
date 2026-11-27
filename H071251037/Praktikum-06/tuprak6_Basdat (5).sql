SET search_path TO public;

-- Nomor 5
CREATE TABLE anggota (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	nama_anggota VARCHAR(50) NOT NULL,
	kota_domisili VARCHAR(20) NOT NULL
);

CREATE TABLE buku (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    judul_buku VARCHAR(100) NOT NULL,
    genre VARCHAR(20) NOT NULL,
    stok INT DEFAULT 1
);

CREATE TABLE peminjaman (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	id_anggota INT,
	CONSTRAINT fk_peminjaman_anggota
		FOREIGN KEY (id_anggota)
		REFERENCES anggota(id),
	id_buku INT,
	CONSTRAINT fk_peminjaman_buku
		FOREIGN KEY (id_buku)
		REFERENCES buku(id),
	tanggal_pinjam DATE NOT NULL,
	tanggal_kembali DATE,
	denda INT DEFAULT 0
);

CREATE INDEX index_genre_buku ON buku(genre);
CREATE INDEX index_domisili_anggota ON anggota(kota_domisili);

INSERT INTO buku(judul_buku, genre, stok) VALUES
    ('Holy Mother', 'Thriller', 5),
    ('Platina Data', 'Misteri', 10);
SELECT judul_buku, genre, stok 
FROM buku WHERE genre = 'Misteri';

INSERT INTO anggota(nama_anggota, kota_domisili) VALUES
    ('Fatimah', 'Makassar'),
    ('Naflah', 'Bogor'),
    ('Nabilah', 'Jakarta');
SELECT * FROM anggota WHERE kota_domisili = 'Makassar';