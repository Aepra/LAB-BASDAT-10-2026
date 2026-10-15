SET search_path TO classicmodels public;

-- Soal 1
SELECT 
	customerNumber AS "Nomor Pelanggan",
	SUM(amount) AS "Total Pembayran",
	COUNT(*) AS "Jumlah Frekuensi",
	MAX(amount) AS "Setoran Terbesar"
FROM classicmodels.payments
GROUP BY customerNumber
HAVING COUNT(*) > 4 AND AVG(amount) > 20000;

-- Soal 02
SELECT
	customerNumber AS "Nomor Pelanggan",
	SUM(amount) AS "Total Dana"
FROM classicmodels.payments
GROUP BY customerNumber
HAVING SUM(amount) > 80000
ORDER BY SUM(amount) DESC

-- Soal 03
SELECT 
	productLine AS "Kategori",
	COUNT(*) AS "Jumlah per Kategori",
	ROUND(AVG(buyPrice), 2) AS "Rata Rata",
	STRING_AGG(productName, ', ' ORDER BY productName) AS "Nama Produk"
FROM classicmodels.products
GROUP BY productLine
HAVING COUNT(productLine) > 10

-- Soal 04
SELECT DISTINCT reportsto AS "Nomor Identitas"
FROM classicmodels.employees
WHERE reportsto IS NOT NULL
EXCEPT
SELECT DISTINCT employeeNumber FROM classicmodels.employees
WHERE jobtitle LIKE 'VP%' OR jobtitle LIKE 'President%'

-- Soal 05
SELECT 
	productCode AS "Produk Kode",
	SUM(quantityOrdered) AS "Total Unit Terjual",
	ROUND(AVG(priceEach), 2) AS "Harga Rata Rata"
FROM classicmodels.orderdetails
WHERE priceEach > 100
GROUP BY productCode
HAVING SUM(quantityOrdered) > 50
ORDER BY SUM(quantityOrdered) DESC

-- Soal 06
SELECT
	productCode AS "Produk Kode",
	SUM(quantityOrdered) AS "Total Unit Terjual",
	SUM(quantityOrdered * priceEach) AS "Pendapatan Kotor",
	ROUND(AVG(priceEach), 2) AS "Harga Rata Rata",
	MAX(priceEach) - MIN(priceEach) AS "Rentang Volatilitas"
FROM classicmodels.orderdetails
WHERE quantityOrdered > 20
GROUP BY productCode
HAVING SUM(quantityOrdered * priceEach) > 50000
ORDER BY SUM(quantityOrdered * priceEach) DESC;

-- Soal 07
SELECT customerNumber FROM classicmodels.customers
WHERE creditlimit > 80000
INTERSECT
SELECT customerNumber FROM classicmodels.orders
WHERE status IN ('Cancelled', 'On Hold')
EXCEPT
SELECT customerNumber FROM classicmodels.payments
GROUP BY customerNumber
HAVING SUM(amount) > 100000

-- Soal Live code 1
SELECT
	EXTRACT(YEAR FROM orderDate) AS tahun,
	status,
	COUNT(*) AS jumlah_pesanan,
	round(AVG(shippedDate::date - orderDate::date),1) AS rata_tenggat_hari,
	AVG(COALESCE(shippedDate::date - orderDate::date,0)) AS rata_durasi_kirim,
	COUNT(comments) AS jumlah_komentar FROM orders
WHERE (orderdate between '2003-01-01' AND '2005-12-31')
AND status ILIKE '%ship%' OR status LIKE 'Cancelled'
AND comments IS NOT NULL
GROUP BY EXTRACT(YEAR FROM orderdate), status
HAVING COUNT(*) > 5
ORDER BY EXTRACT(YEAR FROM orderdate), COUNT(*) DESC;

-- Soal Live code 2
SELECT productCode AS kode_produk,
COUNT(quantityOrdered) AS total_unit,
SUM(quantityOrdered*priceEach) AS total_pendapatan,
MAX(priceEach) AS harga_tertinggi,
MIN(priceEach) AS harga_terendah
FROM orderdetai
WHERE buyPrice BETWEEN 50 AND 150
GROUP BY productCode
HAVING SUM(quantityInStock*buyPrice)

