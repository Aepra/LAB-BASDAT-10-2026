SET search_path TO classicmodels;

-- Nomor 1
SELECT productCode AS kode_produk, productName AS nama_produk,
msrp, quantityInStock AS jumlah_stok,
CASE
	WHEN msrp < 50 AND quantityInStock > 500 THEN 'Ekonomis - Stok Tinggi'
	WHEN msrp < 50 AND quantityInStock <= 500 THEN 'Ekonomis - Stok Rendah'
	WHEN msrp BETWEEN 50 AND 100 THEN 'Harga Menengah'
	WHEN msrp > 100 THEN 'Harga Premium'
END AS kategori_produk
FROM products
ORDER BY msrp DESC;

-- SELECT * FROM orders;
-- SELECT * FROM orderdetails;
-- Nomor 2
SELECT productCode AS kode_produk,
SUM(quantityOrdered) AS total_unit_terjual,
COUNT(DISTINCT orderNumber) AS jumlah_pesanan
FROM orderdetails
GROUP BY productCode
	HAVING SUM(quantityOrdered) > (
		SELECT AVG(quantityOrdered)
		FROM orderdetails
	) AND COUNT(DISTINCT orderNumber) > 10
ORDER BY total_unit_terjual DESC;

-- Nomor 3
SELECT productCode AS kode_produk,
productName AS nama_produk,
quantityInStock AS jumlah_stok, msrp
FROM products
WHERE quantityInStock > (
	SELECT AVG(quantityInStock)
	FROM products
) AND msrp > (
	SELECT AVG(msrp)
	FROM products
)
ORDER BY jumlah_stok DESC;

-- Nomor 3 (+Soal tambahan)
SELECT productCode AS kode_produk,
productName AS nama_produk,
quantityInStock AS jumlah_stok, msrp
FROM products
WHERE quantityInStock > (
	SELECT AVG(quantityInStock)
	FROM products
) AND msrp > (
	SELECT MIN(msrp)
	FROM products LIMIT 3
)
ORDER BY jumlah_stok DESC, msrp ASC;

-- Nomor 4
BEGIN;
UPDATE orders SET status = 'Pengiriman'
WHERE orderNumber = 10100;

SELECT orderNumber, status FROM orders
WHERE orderNumber = 10100;

SAVEPOINT status_pengiriman;

UPDATE orders SET status = 'Batal'
WHERE orderNumber = 10100 RETURNING*;

ROLLBACK TO SAVEPOINT status_pengiriman;
COMMIT; -- Menyimpan perubahan secara permanen

-- Menampilkan data pesanan setelah transaksi selesai
SELECT orderNumber, status FROM orders
WHERE orderNumber = 10100;

-- NOTE:
/*
- ROLLBACK TO SAVEPOINT nama_savepoint;
Membatalkan perubahan hanya sampai ke titik savepoint yang ditentukan. Perubahan
query yang dijalankan sebelum titik savepoint tersebut tetap tersimpan sementara
di memori transaksi (belum hilang) dan nanti masih bisa di-COMMIT.
- ROLLBACK;
Membatalkan seluruh perubahan dari awal saat perintah BEGIN / START TRANSACTION
dijalankan. Semua savepoint yang sempat dibuat di dalam transaksi tersebut juga
akan otomatis terhapus, dan transaksi langsung diakhiri.
*/

-- SOAL_TAMBAHAN

-- Soal nomor 1
-- (Cara pertama)
SELECT customerNumber AS nomor_pelanggan,
customerName AS nama_pelanggan,
city AS kota_domisili, (
	SELECT COUNT(o.orderNumber) FROM orders o
	WHERE o.customerNumber = c.customerNumber
) AS total_pesanan,
CASE
	WHEN (
		SELECT COUNT(o.orderNumber) FROM orders o
		WHERE o.customerNumber = c.customerNumber
	) > 5 THEN 'Pelanggan Loyal'
	WHEN (
		SELECT COUNT(o.orderNumber) FROM orders o
		WHERE o.customerNumber = c.customerNumber
	) BETWEEN 2 AND 5 THEN 'Pelanggan Aktif'
	WHEN (
		SELECT COUNT(o.orderNumber) FROM orders o
		WHERE o.customerNumber = c.customerNumber
	) = 1 THEN 'Pelanggan Baru'
	ELSE 'Pelanggan Pasif'
END AS status_loyalitas 
FROM customers c
ORDER BY total_pesanan DESC, nama_pelanggan ASC;

-- (Cara kedua)
SELECT nomor_pelanggan, nama_pelanggan,
kota_domisili, total_pesanan,
CASE
	WHEN total_pesanan > 5 THEN 'Pelanggan Loyal'
	WHEN total_pesanan BETWEEN 2 AND 5 THEN 'Pelanggan Aktif'
	WHEN total_pesanan = 1 THEN 'Pelanggan Baru'
	ELSE 'Pelanggan Pasif'
END AS status_loyalitas
FROM (
    SELECT c.customerNumber AS nomor_pelanggan,
	c.customerName AS nama_pelanggan,
	c.city AS kota_domisili, (
		SELECT COUNT(o.orderNumber) FROM orders o
		WHERE o.customerNumber = c.customerNumber
	) AS total_pesanan
	FROM customers c
) AS main_table
ORDER BY total_pesanan DESC, nama_pelanggan ASC;

-- (Cara ketiga)
SELECT c.customerNumber AS nomor_pelanggan,
c.customerName AS nama_pelanggan,
c.city AS kota_domisili,
COUNT(o.orderNumber) AS total_pesanan,
CASE
	WHEN COUNT(o.orderNumber) > 5 THEN 'Pelanggan Loyal'
	WHEN COUNT(o.orderNumber) BETWEEN 2 AND 5 THEN 'Pelanggan Aktif'
	WHEN COUNT(o.orderNumber) = 1 THEN 'Pelanggan Baru'
	ELSE 'Pelanggan Pasif'
END AS status_loyalitas 
FROM customers c LEFT JOIN orders o
	ON c.customerNumber = o.customerNumber
GROUP BY c.customerNumber
ORDER BY total_pesanan DESC, nama_pelanggan ASC;

-- Soal nomor 2
SELECT e.employeeNumber AS nomor_karyawan,
CONCAT(e.firstName, ' ', e.lastName) AS nama_lengkap,
e.email, e.officeCode AS kode_kantor
FROM employees e WHERE e.jobTitle = 'Sales Rep'
AND NOT EXISTS (
	SELECT 1
	FROM customers c JOIN orders o
		ON c.customerNumber = o.customerNumber
    WHERE c.salesRepEmployeeNumber = e.employeeNumber
		AND o.status = 'Shipped'
) ORDER BY nomor_karyawan;

-- Soal nomor 3
SELECT productCode, productName,
productLine, buyPrice FROM products
WHERE productLine = 'Classic Cars' AND
	buyPrice > ALL(
		SELECT buyPrice FROM products
		WHERE productLine = 'Vintage Cars'
	)
ORDER BY buyPrice DESC;

-- Soal nomor 4
SELECT nomor_pelanggan, nama_pelanggan, total_belanja
FROM (
	SELECT c.customerNumber AS nomor_pelanggan,
	c.customerName AS nama_pelanggan,
	ROUND(od.quantityOrdered * od.priceEach, 2) AS total_belanja
	FROM customers c JOIN orders o 
		ON c.customerNumber = o.customerNumber
	JOIN orderdetails od ON o.orderNumber = od.orderNumber
) AS derived_table
WHERE total_belanja > (
	SELECT AVG(quantityOrdered * priceEach) FROM orderdetails
)
ORDER BY total_belanja DESC;

-- Soal nomor 5
SELECT * FROM customers WHERE customerNumber = 103;

-- BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;

UPDATE customers
SET creditLimit = creditLimit + 10000
WHERE customerNumber = 103;

SAVEPOINT sp_update_kredit;

UPDATE customers
SET city = 'Surabaya'
WHERE customerNumber = 103 RETURNING*;

ROLLBACK TO SAVEPOINT sp_update_kredit;
COMMIT;

SELECT customerNumber, customerName,
city, country, creditLimit FROM customers
WHERE customerNumber = 103;