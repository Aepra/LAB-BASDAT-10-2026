SELECT * FROM prodi;
SELECT * FROM mahasiswa;

INSERT INTO prodi (nama_prodi) VALUES
	('Sistem Informasi'), ('Biologi'), ('Kimia'), ('Fisika'),
	('Ilmu Komputer'), ('Manajemen Bisnis'), ('Ilmu Komunikasi');

-- INSERT INTO mahasiswa (nim, nama, ipk, email, id_prodi)
-- VALUES ('H07124332', 'Rain', 3.75, '', 7);

INSERT INTO mahasiswa (nim, nama, email, id_prodi) VALUES
	('H07125017', 'Shinichi Kudo', 'shinich1c0nan@email.com', 5),
	('H07125002', 'Vivien', NULL, 1),
	('H07125041', 'Jeno', 'leejeno@email.com', 6)
RETURNING *;

UPDATE mahasiswa set ipk = 3.75
WHERE ipk = 3.50 RETURNING *;

DELETE FROM mahasiswa
WHERE email IS NULL
RETURNING *;

-- SELECT * FROM mahasiswa;

-- Membatalkan seluruh perubahan
-- ROLLBACK;