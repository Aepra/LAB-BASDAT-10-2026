CREATE TABLE prodi (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    nama_prodi VARCHAR(100) NOT NULL
);

CREATE TABLE mahasiswa (
    nim VARCHAR(10) PRIMARY KEY,
    nama VARCHAR(100) NOT NULL,
    ipk NUMERIC(3,2) DEFAULT 0.00,
    email VARCHAR(150) UNIQUE,
    id_prodi INT,
    CONSTRAINT fk_mahasiswa_prodi
        FOREIGN KEY (id_prodi)
        REFERENCES prodi(id)
);

INSERT INTO prodi (nama_prodi)
VALUES ('Sistem Informasi'),
		('Arsitektur');

INSERT INTO mahasiswa (nim, nama, email, id_prodi)
VALUES ('H071251081', 'lily', 'lily@gmail', '1'),
		('D041251055', 'dini', 'dini@gmail', '2'),
		('H07125111', 'aisyah', NULL, '1')
RETURNING*;

UPDATE mahasiswa 
SET ipk=3.75
WHERE ipk=3.50
RETURNING*;

DELETE FROM mahasiswa
WHERE email IS NULL 
RETURNING*;

SELECT*FROM mahasiswa

