SET search_path TO "classicmodels", public;

-- Nomor 1
SELECT customerNumber, SUM(amount) AS total_akumulasi_setoran,
COUNT(checkNumber) AS jumlah_frekuensi_transaksi,
MAX(amount) AS nilai_setoran_terbesar FROM payments
GROUP BY customerNumber HAVING COUNT(DISTINCT checkNumber) > 4
AND AVG(amount) > 20000;

-- Nomor 2
SELECT customerNumber, SUM(amount) AS totalkeseluruhan_setoran
FROM payments GROUP BY customerNumber HAVING SUM(amount) > 80000
ORDER BY totalkeseluruhan_setoran DESC;

-- Nomor 3
-- SELECT productName, productScale, productLine, productVendor FROM products;
SELECT productLine AS "Nama Kategori Barang",
COUNT(productName) AS "Jumlah Ragam Produk",
ROUND(AVG(msrp),2) AS "Rata-rata MSRP",
STRING_AGG(productName, ', ' ORDER BY productName) AS "Daftar Nama Produk"
FROM products GROUP BY productLine HAVING COUNT(productName) > 10;

-- Nomor 4
-- SELECT employeeNumber, reportsTo, jobTitle FROM employees;
SELECT reportsTo FROM employees WHERE reportsTo IS NOT NULL
EXCEPT
SELECT employeeNumber FROM employees WHERE jobTitle ILIKE '%VP%'
OR jobTitle ILIKE '%President%';

-- Nomor 5
SELECT productCode, SUM(quantityOrdered) AS total_unit_terjual,
ROUND(AVG(priceEach),2) AS rata_rata_harga_jual
FROM orderdetails WHERE priceEach > 100 GROUP BY productCode
HAVING SUM(quantityOrdered) > 50 ORDER BY total_unit_terjual DESC;

-- Nomor 6
SELECT productCode, SUM(quantityOrdered) AS total_pesanan_unit,
SUM(quantityOrdered * priceEach) AS estimasi_pendapatan_kotor,
ROUND(AVG(priceEach),2) AS rata_rata_harga_satuan,
MAX(priceEach) - MIN(priceEach) AS rentang_volatilitas
FROM orderdetails
WHERE quantityOrdered > 20 GROUP BY productCode
HAVING SUM(quantityOrdered * priceEach) > 50000
ORDER BY estimasi_pendapatan_kotor DESC;

-- Nomor 7
-- SELECT customerNumber, status FROM orders ORDER BY customerNumber ASC;
SELECT customerNumber FROM customers WHERE creditLimit > 80000
INTERSECT
SELECT customerNumber FROM orders WHERE status ILIKE '%Cancelled%'
OR status ILIKE '%On Hold%'
EXCEPT
SELECT customerNumber FROM payments GROUP BY customerNumber
HAVING SUM(amount) > 100000;

-- Soal tambahan
-- SELECT COUNT(orderNumber) AS jumlah_pesanan FROM orders GROUP BY EXTRACT(Year FROM orderDate), status;
SELECT EXTRACT(Year FROM orderDate) AS tahun, status,
COUNT(orderNumber) AS jumlah_pesanan,
ROUND(AVG(shippedDate::date - orderDate::date), 1) AS rata_tenggat_hari,
AVG(COALESCE(shippedDate::date-orderDate::date, 0)) AS rata_durasi_kirim,
COUNT(comments) AS jumlah_berkomentar FROM orders
WHERE
	(EXTRACT(Year FROM orderDate) BETWEEN 2003 AND 2005 )
	AND (status ILIKE '%ship%' OR status = 'Cancelled')
	-- AND comments IS NOT NULL
GROUP BY EXTRACT(Year FROM orderDate), status
HAVING COUNT(*) > 5
ORDER BY tahun, COUNT(*) DESC;

SELECT productCode, SUM(quantityOrdered) AS total_unit,
SUM(quantityOrdered * priceEach) AS total_pendapatan,
AVG(priceEach) AS rata_rata_harga, MAX(priceEach) AS harga_tertinggi,
MIN(priceEach) AS harga_terendah FROM orderdetails
WHERE priceEach BETWEEN 50 AND 150 GROUP BY productCode
HAVING SUM(quantityOrdered * priceEach) > 30000
ORDER BY total_pendapatan DESC;