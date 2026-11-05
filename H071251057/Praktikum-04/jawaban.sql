--nomor 1
SELECT customerNumber,
SUM(amount) AS "Total Pembayaran",
COUNT(checkNumber) AS "Jumlah Transaksi",
MAX(amount) AS "Setoran Tertinggi" 
FROM payments
GROUP BY customerNumber
HAVING COUNT(checkNumber) > 4 AND AVG(amount) > 20000;

--nomor 2
SELECT customerNumber,
SUM(amount) AS "Total Pembayaran" 
FROM payments 
GROUP BY customerNumber
HAVING SUM(amount) > 80000
ORDER BY "Total Pembayaran" DESC;

--nomor 3
SELECT productLine,
COUNT(productCode) AS "Jumlah Produk",
ROUND(AVG(MSRP), 2) AS "Rata-rata Harga",
STRING_AGG(productName, ', ') AS "Daftar Produk"
FROM products
GROUP BY productLine
HAVING COUNT(productCode) > 10;

--nomor 4
SELECT reportsTo AS employeeNumber
FROM employees
WHERE reportsTo IS NOT NULL
EXCEPT
SELECT employeeNumber
FROM employees
WHERE jobTitle LIKE '%VP%' OR jobTitle LIKE '%President%';

--nomor 5
SELECT productCode,
SUM(quantityOrdered) AS "Total Unit Terjual",
ROUND(AVG(priceEach), 2) AS "Rata-rata Harga"
FROM orderdetails
WHERE priceEach > 100
GROUP BY productCode
HAVING SUM(quantityOrdered) > 50
ORDER BY "Total Unit Terjual" DESC;

--nomor 6
SELECT productCode,
SUM(quantityOrdered) AS "Total Unit dipesan",
SUM(quantityOrdered * priceEach) AS "Pendapatan Kotor",
ROUND(AVG(priceEach), 2) AS "Rata-rata Harga",
MAX(priceEach) - MIN(priceEach) AS "rentang volatilitas"
FROM orderdetails
WHERE quantityOrdered > 20
GROUP BY productCode
HAVING SUM(quantityOrdered * priceEach) > 50000
ORDER BY "Pendapatan Kotor" DESC;

--nomor 7
SELECT customerNumber
FROM customers
WHERE creditLimit > 80000
INTERSECT
SELECT DISTINCT customerNumber
FROM orders
WHERE status = 'Cancelled' OR status = 'On Hold'
EXCEPT
SELECT customerNumber
FROM payments
GROUP BY customerNumber
HAVING SUM(amount) > 100000;

--soal tambahan
--soal 1
SELECT EXTRACT(YEAR FROM orderdate) AS tahun, status,
COUNT(*) AS jumlah_pesanan,
ROUND(AVG(EXTRACT (DAY FROM requiredDate - orderDate)),1) AS rata_tenggat_hari,
AVG(COALESCE(EXTRACT(DAY FROM shippedDate - orderDate),0)) AS rata_durasi_kirim,
COUNT(comments) AS jumlah_berkomentar
FROM orders
WHERE EXTRACT(YEAR FROM orderDate) BETWEEN 2003 AND 2005
AND (status ILIKE '%ship%' OR status = 'Cancelled') 
AND comments IS NOT NULL 
GROUP BY EXTRACT(YEAR FROM orderDate), status
HAVING COUNT(*) > 5
ORDER BY tahun ASC, jumlah_pesanan DESC;

--soal 2
SELECT productCode AS kode_produk,
SUM(quantityOrdered) AS total_unit,
SUM(quantityOrdered * priceEach) AS total_pendapatan,
AVG(priceEach) AS rata_harga,
MAX(priceEach) AS harga_tertinggi,
MIN(priceEach) AS harga_terendah
FROM orderDetails
WHERE priceEach BETWEEN 50 AND 150
GROUP BY productCode
HAVING SUM(quantityOrdered * priceEach) > 30000
ORDER BY total_pendapatan DESC;

