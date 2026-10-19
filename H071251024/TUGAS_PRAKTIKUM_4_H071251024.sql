-- soal 1
SELECT
    customerNumber,
    SUM(amount) AS total_pembayaran,
    COUNT(DISTINCT checkNumber) AS jumlah_transaksi,
    MAX(amount) AS pembayaran_terbesar
FROM classicmodels.payments
GROUP BY customerNumber
HAVING COUNT(DISTINCT checkNumber) > 4
   AND AVG(amount) > 20000;

-- soal 2
SELECT
    customerNumber,
    SUM(amount) AS total_pembayaran
FROM classicmodels.payments
GROUP BY customerNumber
HAVING SUM(amount) > 80000
ORDER BY total_pembayaran DESC;

-- soal 3
SELECT
    productLine AS kategori_produk,
    COUNT(*) AS jumlah_produk,
    ROUND(AVG(msrp), 2) AS rata_rata_harga_ritel,
    STRING_AGG(productName, ', ' ORDER BY productName) AS daftar_produk
FROM classicmodels.products
GROUP BY productLine
HAVING COUNT(*) > 10;

-- soal 4
SELECT employeeNumber
FROM classicmodels.employees
WHERE reportsTo IS NOT NULL
INTERSECT
SELECT employeeNumber
FROM classicmodels.employees
WHERE jobTitle NOT ILIKE '%VP%'
  AND jobTitle NOT ILIKE '%President%';

-- soal 5
SELECT
    productCode,
    SUM(quantityOrdered) AS total_unit_terjual,
    ROUND(AVG(priceEach), 2) AS rata_rata_harga_jual
FROM classicmodels.orderdetails
WHERE priceEach > 100
GROUP BY productCode
HAVING SUM(quantityOrdered) > 50
ORDER BY total_unit_terjual DESC;

-- soal 6
SELECT
    productCode,
    SUM(quantityOrdered) AS total_unit_dipesan,
    SUM(quantityOrdered * priceEach) AS estimasi_pendapatan_kotor,
    ROUND(AVG(priceEach), 2) AS rata_rata_harga_satuan,
    MAX(priceEach) - MIN(priceEach) AS rentang_harga
FROM classicmodels.orderdetails
WHERE quantityOrdered > 20
GROUP BY productCode
HAVING SUM(quantityOrdered * priceEach) > 50000
ORDER BY estimasi_pendapatan_kotor DESC;

-- soal 7
(SELECT customerNumber
FROM classicmodels.customers
WHERE creditLimit > 80000
INTERSECT
SELECT customerNumber
FROM classicmodels.orders
WHERE status LIKE 'Cancelled' 
OR status LIKE 'On Hold') 
EXCEPT
SELECT customerNumber
FROM classicmodels.payments
GROUP BY customerNumber
HAVING SUM(amount) > 100000;