--nomor 1
SELECT productCode, productName, MSRP, quantityInStock,
CASE 
	WHEN MSRP < 50 AND quantityInStock > 500 THEN 'Ekonomis - Stok Tinggi'
	WHEN MSRP < 50 AND quantityInStock < 500 THEN 'Ekonomis - Stok Rendah'
	WHEN MSRP BETWEEN 50 AND 100 THEN 'Harga Menengah'
	WHEN MSRP > 100 THEN 'Harga Premium'
END AS kategori
FROM products
ORDER BY MSRP DESC;

--nomor 2
SELECT productCode, 
SUM(quantityOrdered) AS total_unit_terjual,
COUNT(DISTINCT orderNumber) AS jumlah_pesanan
FROM orderdetails
GROUP BY productCode
HAVING SUM(quantityOrdered) > (
	SELECT AVG(quantityOrdered)
	FROM orderdetails
)
AND COUNT(DISTINCT orderNumber) > 10
ORDER BY total_unit_terjual DESC;

--nomor 3
SELECT productCode, productName, quantityInStock, msrp
FROM products
WHERE quantityInStock > (
	SELECT AVG(quantityInStock) 
	FROM products)
AND msrp > (
	SELECT AVG(msrp)
	FROM products)
ORDER BY quantityInStock DESC;

--nomor 4
BEGIN;

UPDATE orders
SET status = 'Pengiriman'
WHERE orderNumber = 10100;

SAVEPOINT status_pengiriman;

UPDATE orders
SET status = 'Batal'
WHERE orderNumber = 10100;

ROLLBACK TO SAVEPOINT status_pengiriman;

COMMIT;

--nomor 5
--anggota
CREATE TABLE anggota (
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
nama_anggota VARCHAR(50) NOT NULL,
kota_domisili VARCHAR(20) NOT NULL
);

--buku
CREATE TABLE buku (
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
judul_buku VARCHAR(100) NOT NULL,
genre VARCHAR(20) NOT NULL,
stok INT DEFAULT 1
);

--pinjaman
CREATE TABLE pinjaman (
id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
id_anggota INT REFERENCES anggota(id),
id_buku INT REFERENCES buku(id),
tanggal_pinjam DATE NOT NULL,
tanggal_kembali DATE,
denda INT DEFAULT 0
);

CREATE INDEX idx_buku_genre
ON buku(genre);

CREATE INDEX idx_anggota_kota_domisili
ON anggota(kota_domisili);

--soal tambahan
--nomor 6
CREATE TABLE kurir (
id_kurir SERIAL PRIMARY KEY,
nama_kurir VARCHAR(50) NOT NULL,
no_telepon VARCHAR(20) NOT NULL UNIQUE,
status_aktif BOOLEAN DEFAULT TRUE
);

CREATE TABLE pengiriman (
id_pengiriman SERIAL PRIMARY KEY,
nomor_resi VARCHAR(30) NOT NULL UNIQUE,
id_kurir INT REFERENCES kurir(id_kurir),
tanggal_kirim TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
ongkos_kirim NUMERIC(12,2) NOT NULL CHECK(ongkos_kirim > 0),
status_pengiriman VARCHAR(20) DEFAULT 'Dalam Perjalanan'
);

CREATE INDEX idx_pengiriman_kurir
ON pengiriman(id_kurir);

CREATE INDEX idx_pengiriman_status
ON pengiriman(status_pengiriman);

DROP INDEX idx_pengiriman_status;

INSERT INTO kurir(id_kurir, nama_kurir, no_telepon, status_aktif)
VALUES(002 , 'rahuul', '08299', false);

SELECT * FROM kurir

INSERT INTO pengiriman(id_pengiriman, nomor_resi, id_kurir, tanggal_kirim, ongkos_kirim, status_pengiriman)
VALUES(9, 'XYZ', 1, NOW(), 1.00, 'Di Bontojolong');

SELECT * FROM pengiriman