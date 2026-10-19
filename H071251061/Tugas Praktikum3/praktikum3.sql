------------------1----------------------------
SELECT
	ordernumber,
	UPPER(productCode) AS "Kode Produk",
	quantityOrdered,
	priceEach
FROM
	orderdetails
WHERE
	LEFT (productCode, 3) = 'S18'
	AND (
		(quantityOrdered) BETWEEN 20 AND 50
		OR (priceEach < 30)
	)
ORDER BY
	quantityOrdered DESC;
------------------2----------------------------
SELECT
	customerNumber,
	customerName,
	country,
	CONCAT(contactFirstName,'',contactLastName) AS "Nama Kontak",
	creditLimit,
	creditLimit - 10000 AS "Selisih Kredit"
FROM 
	customers
WHERE
	(country ILIKE 'USA'
	OR country ILIKE 'Canada'
	OR country ILIKE'France')
	AND (creditLimit > 30000)
ORDER BY
	creditLimit DESC;
------------------3----------------------------
SELECT
	productCode,
	productName,
	buyPrice,
	CONCAT(productCode,'',SUBSTRING(productName,6)) AS "Kode Nama",
	MSRP,
	GREATEST(buyPrice,MSRP) AS "Harga Tertinggi",
	LEAST(buyPrice,MSRP) AS "Harga Terendah"
FROM
	products
WHERE
	productName ILIKE '%car%';
------------------4----------------------------
SELECT
	orderNumber,
	orderDate,
	shippedDate,
	EXTRACT(YEAR FROM orderDate) AS "Tahun",
	EXTRACT(MONTH FROM orderDate) AS "Bulan",
	AGE(shippedDate, orderDate) AS "Lama Pengiriman",
	(shippedDate - orderDate) AS "Interval Pengiriman",
	CURRENT_DATE AS "Tanggal Laporan",
	CURRENT_TIME AS "Waktu Laporan"
FROM
	orders
WHERE
	shippedDate IS NOT NULL;
------------------5----------------------------
SELECT
	orderNumber,
	orderDate,
	shippedDate,
	orderDate + INTERVAL '10 days' AS "Estimasi Kirim",
	COALESCE(shippedDate, orderDate + INTERVAL '10 days') AS "Tanggal Aktual",
	(shippedDate - orderDate) AS "Selisih Waktu"
FROM
	orders
WHERE
	comments ILIKE '%customer%'
	AND EXTRACT(MONTH FROM orderDate) BETWEEN 10 AND 12
	AND (orderNumber %2 !=0)
ORDER BY
	orderDate DESC;
------------------SOAL TAMBAHAN 1----------------------------
SELECT
	productCode,
	productName,
	UPPER (SUBSTRING (productName,5)) AS "shortName",
	buyPrice * 0.7 + (quantityInStock % 10) AS "promoPrice"
FROM
	products
WHERE
	productName ILIKE '%V%'
	AND (quantityInStock) BETWEEN 1000 AND 4000
	AND quantityInStock & 4=4;

------------------SOAL TAMBAHAN 2----------------------------
SELECT
	orderNumber,
	orderDate,
	COALESCE (shippedDate, CURRENT_DATE) AS "Tanggal Penyelesaian",
	GREATEST (requiredDate, shippedDate) AS "Toleransi Akhir",
	requiredDate - orderDate AS "Target Hari"
FROM
	orders
WHERE
	EXTRACT (YEAR FROM orderDate ) =2003
	AND comments IS NOT NULL
ORDER BY
	"Target Hari" DESC;