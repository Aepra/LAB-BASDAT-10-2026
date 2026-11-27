SET search_path TO classicmodels, public;




SELECT productCode,
		SUM(quantityOrdered) AS "Total Unit Terjual",
		COUNT(DISTINCT orderNumber) AS "Jumlah Pesanan Berbeda"
FROM orderDetails
GROUP BY productCode
HAVING SUM(quantityOrdered) > (SELECT AVG(quantityOrdered) FROM orderDetails)
			AND COUNT(DISTINCT orderNumber) >= 10
ORDER BY "Total Unit Terjual" DESC;


SELECT productCode, 
		productName,
		quantityInStock,
		msrp
FROM products
WHERE quantityInStock > (SELECT AVG(quantityInStock) FROM products)
		AND msrp > (SELECT AVG(msrp)FROM products)
ORDER BY quantityInStock DESC;


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

SELECT orderNumber, 
		status 
FROM orders
WHERE orderNumber = 10100;


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
    id_anggota INT NOT NULL,
    id_buku INT NOT NULL,
    tanggal_pinjam DATE NOT NULL,
    tanggal_kembali DATE NULL,
    denda INT DEFAULT 0,
    CONSTRAINT fk_peminjaman_anggota FOREIGN KEY (id_anggota) REFERENCES anggota(id),
    CONSTRAINT fk_peminjaman_buku FOREIGN KEY (id_buku) REFERENCES buku(id)
);

CREATE INDEX idx_buku_genre ON buku(genre);
CREATE INDEX idx_anggota_kota ON anggota(kota_domisili);


		