SET search_path TO classicmodels;

-- Nomor 1:
SELECT orderNumber, UPPER(productCode) AS "Kode Produk", quantityOrdered, priceEach
FROM orderdetails WHERE (priceEach < 30 OR quantityOrdered BETWEEN 20 AND 50)
AND LEFT(productCode, 3) = 'S18' ORDER BY quantityOrdered DESC;

-- Nomor 2:
SELECT customerNumber, customerName, country, 
CONCAT(contactFirstName, ' ', contactLastName) AS "Nama Kontak",
creditLimit, (creditLimit - 10000) AS "Selisih Kredit"
FROM customers WHERE (country = 'USA' OR country = 'Canada' OR country = 'France')
AND creditLimit > 30000 ORDER BY creditLimit DESC;

-- Nomor 3:
SELECT productCode, productName, buyPrice, MSRP,
GREATEST(buyPrice, MSRP) AS "Harga Tertinggi",
LEAST(buyPrice, MSRP) AS "Harga Terendah"
FROM products WHERE productName ILIKE '%car%';

-- Nomor 3 (+Soal tambahan)
SELECT productCode, SUBSTRING(productname, 6), buyPrice, MSRP,
GREATEST(buyPrice, MSRP) AS "Harga Tertinggi",
LEAST(buyPrice, MSRP) AS "Harga Terendah"
FROM products WHERE productName ILIKE '%car%';

-- Nomor 4:
SELECT orderNumber, orderDate, shippedDate,
EXTRACT(YEAR FROM orderDate) AS "Tahun",
EXTRACT(MONTH FROM orderdate) AS "Bulan",
(shippedDate - orderDate) AS "Lama Pengiriman", -- Menghasilkan angka (misal: 3)*
AGE(shippedDate, orderDate) AS "Interval Pengiriman", -- Menghasilkan interval (misal: 3 days)
CURRENT_DATE AS "Tanggal Laporan", CURRENT_TIME AS "Waktu Laporan"
FROM orders WHERE shippedDate IS NOT NULL;

-- SELECT comments FROM orders;
-- Nomor 5:
SELECT orderNumber, orderDate, shippedDate,
orderDate + INTERVAL '10 days' AS "Estimasi Kirim",
COALESCE(shippedDate, orderDate + INTERVAL '10 days') AS "Tanggal Aktual",
shippedDate - orderDate AS "Selisih Waktu" FROM orders
WHERE comments ILIKE '%customer%' AND
DATE_PART('month', orderDate) BETWEEN 10 AND 12 AND
orderNumber % 2 = 1 -- atau: orderNumber % 2 != 0
ORDER BY orderDate DESC;

-- Soal tambahan:
SELECT productCode, productName, UPPER(SUBSTRING(productName, 6, 15)) AS shortname,
(buyPrice - buyPrice * 0.30) + quantityInstock % 10 AS promoprice FROM products
WHERE productName ILIKE '%V%' AND quantityInstock BETWEEN 1000 AND 4000
AND quantityInstock & 4 = 4;

SELECT orderNumber, orderDate::date,
COALESCE(shippedDate::date, CURRENT_DATE) AS tanggalPenyelesaian,
GREATEST(requiredDate::date, shippedDate::date) AS toleransiAkhir,
(requiredDate::date - orderDate::date) AS targetHari FROM orders
WHERE EXTRACT(YEAR FROM orderDate) = 2003 AND comments IS NOT NULL
ORDER BY targetHari DESC;

/*
NOTE:
Berbeda dengan fungsi EXTRACT(), jika membutuhkan semacam nama bulan atau nama hari
dalam bentuk TEXT/String, maka gunakan fungsi format teks yang seperti ini contohnya
TO_CHAR(orderDate, 'Month')

*S&K:
1. Di PostgreSQL, jika shippedDate dan orderDate memiliki tipe data DATE,
maka pengurangan (shippedDate-orderDate) akan menghasilkan angka murni
atau tipe data INTEGER. Namun, beberapa tampilan antarmuka pgAdmin 4 atau
format bawaan tabel secara otomatis menambahkan kata "days" di layar hanya
sebagai label tampilan agar paham bahwa angka tersebut adalah durasi hari.

2. Jika shippedDate dan orderDate itu tipe datanya TIMESTAMP, maka
operasi pengurangannya secara otomatis akan langsung menghasilkan
tipe data INTERVAL, bukan tipe data angka/Integer.

3. Query ini akan menghasilkan tipe data NUMERIC:
EXTRACT(DAY FROM (shippedDate - orderDate)) AS "Lama Pengiriman",

4. Kalau yang ini akan menghasilkan tipe data INTEGER:
(shippedDate::date - orderDate::date) AS "Lama Pengiriman",
*/