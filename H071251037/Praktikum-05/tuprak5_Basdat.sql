SET search_path TO classicmodels;

-- Nomor 1
SELECT c.contactFirstName, c.customerName, o.city,
	e.firstName || ' ' || e.lastName AS sales_rep_name
FROM employees AS e INNER JOIN offices AS o
	ON e.officeCode = o.officeCode
INNER JOIN customers AS c
	ON e.employeeNumber = c.salesRepEmployeeNumber
WHERE c.contactFirstName ILIKE 'A%' AND
o.city != 'NYC' ORDER BY c.customerName;

-- Nomor 2
SELECT c.customerName, SUM(p.amount) AS total_payment,
	MAX(p.amount) AS max_single_payment
FROM customers AS c INNER JOIN payments AS p
	ON c.customerNumber = p.customerNumber
GROUP BY c.customerName HAVING SUM(p.amount) > 50000
ORDER BY total_payment DESC;

-- Nomor 3
SELECT c.customerName, COUNT(DISTINCT o.orderNumber) AS total_order,
	ROUND(AVG(od.quantityOrdered),2) AS avg_quantity_per_order
FROM customers AS c INNER JOIN orders AS o
	ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails AS od
	ON o.orderNumber = od.orderNumber
GROUP BY c.customerName
HAVING COUNT(DISTINCT o.orderNumber) > 3
	AND AVG(od.quantityOrdered) > 35
ORDER BY total_order DESC, avg_quantity_per_order DESC;

-- Nomor 4
SELECT p.productLine, SUM(od.quantityOrdered) AS total_terjual,
ROUND(AVG(od.priceEach),2) AS rata_rata_harga,
ROUND(AVG((p.msrp-od.priceEach)/p.msrp * 100),2)
	AS avg_discount_percentage
FROM products AS p INNER JOIN orderdetails AS od
	ON p.productCode = od.productCode
GROUP BY p.productLine HAVING SUM(od.quantityOrdered) > 3000
	AND ROUND(AVG(od.priceEach),2) > 80
ORDER BY total_terjual DESC;

-- Nomor 5
SELECT c.customerName,
SUM(od.quantityOrdered*od.priceEach) AS total_transaksi,
-- COUNT(DISTINCT o.status = 'Shipped') AS total_shipped_orders,
COUNT(DISTINCT o.orderNumber) AS total_shipped_orders,
ROUND(SUM(od.quantityOrdered * od.priceEach) /
COUNT(DISTINCT o.orderNumber), 2) AS avg_transaction_per_order
FROM customers AS c INNER JOIN orders AS o
	ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails AS od
	ON o.orderNumber = od.orderNumber
WHERE o.status = 'Shipped'
GROUP BY c.customerName
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM o.orderDate)) > 1
ORDER BY total_transaksi DESC LIMIT 5;

-- Nomor 6
-- SELECT city, territory FROM offices;
SELECT c.customerName,
	c.city AS customer_city,
	o.city AS office_city,
	SUM(od.quantityOrdered) AS total_unit_terjual,
	ROUND(SUM(od.quantityOrdered * od.priceEach)
	/ COUNT(DISTINCT r.orderNumber), 2) AS avg_nilai_per_order
FROM offices AS o INNER JOIN employees AS e
	ON o.officeCode = e.officeCode
INNER JOIN customers AS c
	ON e.employeeNumber = c.salesRepEmployeeNumber
INNER JOIN orders AS r
	ON c.customerNumber = r.customerNumber
INNER JOIN orderdetails AS od
	ON r.orderNumber = od.orderNumber
WHERE o.territory = 'EMEA'
GROUP BY c.customerName, c.city, o.city
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM r.orderDate)) > 2
	AND SUM(od.quantityOrdered) > 1000
	AND (SUM(od.quantityOrdered * od.priceEach)
		/ COUNT(DISTINCT r.orderNumber)) > 10000
ORDER BY avg_nilai_per_order DESC;

-- SOAL TAMBAHAN

-- Nomor 1
-- SELECT * FROM employees;
SELECT e.firstName || ' ' || e.lastName AS sales_rep_name,
COALESCE(STRING_AGG(DISTINCT c.customerName, ', '),
	'Belum ada pelanggan') AS customer_name,
COALESCE(SUM(od.quantityOrdered), 0) AS total_barang,
COALESCE(SUM(od.quantityOrdered * od.priceEach), 0) AS total_pendapatan
FROM employees AS e
LEFT JOIN customers AS c
	ON e.employeeNumber = c.salesRepEmployeeNumber
LEFT JOIN orders AS o
	ON c.customerNumber = o.customerNumber
LEFT JOIN orderdetails AS od
	ON o.orderNumber = od.orderNumber
WHERE e.jobTitle = 'Sales Rep'
GROUP BY e.firstName || ' ' || e.lastName;
ORDER BY total_pendapatan DESC;

-- Nomor 2
-- SELECT city FROM offices;

/* Case (1) */
SELECT o.city,
	COALESCE(STRING_AGG(DISTINCT CONCAT(e.firstName, ' ', e.lastName), ' - '),
		'Belum ada karyawan') AS daftar_karyawan,
	COALESCE(COUNT(DISTINCT c.customerNumber), 0) AS jumlah_pelanggan
FROM customers AS c
LEFT JOIN employees AS e
	ON c.salesRepEmployeeNumber = e.employeeNumber
RIGHT JOIN offices AS o
	ON e.officeCode = o.officeCode
-- WHERE o.city IS NOT NULL
GROUP BY o.city
ORDER BY jumlah_pelanggan DESC;

/* Case (2) */
SELECT o.city,
	COALESCE(STRING_AGG(CONCAT(e.firstName, ' ', e.lastName), ' - '),
		'Belum ada karyawan') AS daftar_karyawan,
	COALESCE(COUNT(DISTINCT c.customerNumber), 0) AS jumlah_pelanggan
FROM offices AS o
LEFT JOIN employees AS e
	ON o.officeCode = e.officeCode
LEFT JOIN customers AS c
	ON e.employeeNumber = c.salesRepEmployeeNumber
WHERE o.city IS NOT NULL
GROUP BY o.city
ORDER BY jumlah_pelanggan DESC;

-- Nomor 3
SELECT c.customerName,
COALESCE(STRING_AGG(DISTINCT p.productLine, ', '),
	'Belum berbelanja') AS kategori_lini_produk,
COALESCE(SUM(od.quantityOrdered), 0) AS total_belanja,
COALESCE(SUM(od.quantityOrdered * od.priceEach), 0) AS total_pengeluaran
FROM offices AS oc
JOIN employees AS e ON oc.officeCode = e.officeCode
JOIN customers AS c ON e.employeeNumber = c.salesRepEmployeeNumber
LEFT JOIN orders AS o ON c.customerNumber = o.customerNumber
LEFT JOIN orderdetails AS od ON o.orderNumber = od.orderNumber
LEFT JOIN products AS p ON od.productCode = p.productCode 
WHERE oc.city = 'Paris' GROUP BY c.customerName
ORDER BY total_pengeluaran DESC;