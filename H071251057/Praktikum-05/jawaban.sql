--nomor 1
SELECT c.contactfirstname, c.customername, o.city, 
CONCAT(e.firstname, ' ', e.lastname) AS sales_rep_name
FROM customers c
JOIN employees e
ON e.employeeNumber = c.salesRepEmployeeNumber
JOIN offices o
ON o.officeCode = e.officeCode
WHERE c.contactfirstname ILIKE 'A%' 
AND o.city != 'NYC'
ORDER BY c.customername ASC;

--nomor 2
SELECT c.customername, 
SUM(p.amount) AS total_payment, 
MAX(p.amount) AS max_single_payment
FROM customers c
JOIN payments p
ON p.customernumber = c.customernumber
GROUP BY c.customernumber, c.customername
HAVING SUM(p.amount) > 50000
ORDER BY total_payment DESC;

--nomor 3
SELECT c.customername, 
COUNT(DISTINCT o.ordernumber) AS total_order,
ROUND(AVG(od.quantityordered), 2) AS avg_quantity_per_order
FROM customers c
JOIN orders o
ON o.customername = c.customername
JOIN orderdetails od
ON od.ordernumber = o.ordernumber
GROUP BY c.customername
HAVING COUNT(DISTINCT o.ordernumber) > 3
AND AVG(od.quantityordered) > 35
ORDER BY total_order DESC, avg_quantity_per_order DESC;

--nomor 4
SELECT p.productline, SUM(od.quantityordered) AS total_terjual, 
ROUND(AVG(od.priceeach),2) AS rata_rata_harga, 
ROUND(AVG((p.MSRP - od.priceeach) / p.MSRP * 100),2) AS avg_discount_percentage
FROM products p
JOIN orderdetails od
ON od.productcode = p.productcode
GROUP BY p.productline
HAVING SUM(od.quantityordered) > 3000 
AND AVG(priceeach) > 80
ORDER BY total_terjual DESC;

--nomor 5
SELECT c.customername, 
SUM(od.quantityordered * od.priceeach) AS total_transaksi,
COUNT(DISTINCT o.ordernumber) AS total_shipped_orders,
ROUND(SUM(od.quantityordered * od.priceeach)/ COUNT(DISTINCT O.ordernumber),2) AS avg_transaction_per_order
FROM customers c
JOIN orders o 
ON o.customernumber = c.customernumber
JOIN orderdetails od
ON od.ordernumber = o.ordernumber
WHERE o.status = 'Shipped'
GROUP BY c.customername
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM o.orderdate)) > 1
ORDER BY total_transaksi DESC
LIMIT 5;

--nomor 6
SELECT c.customerName,
c.city AS customer_city,
ofc.city AS office_city,
SUM(od.quantityOrdered) AS total_unit_terjual,
ROUND(SUM(od.quantityOrdered * od.priceEach)/ COUNT(DISTINCT o.orderNumber),2) AS avg_nilai_per_order
FROM customers c
INNER JOIN employees e
ON c.salesRepEmployeeNumber = e.employeeNumber
INNER JOIN offices ofc
ON e.officeCode = ofc.officeCode
INNER JOIN orders o
ON c.customerNumber = o.customerNumber
INNER JOIN orderdetails od
ON o.orderNumber = od.orderNumber
WHERE ofc.territory = 'EMEA'
GROUP BY c.customerNumber, c.customerName, c.city, ofc.city
HAVING COUNT(DISTINCT EXTRACT(YEAR FROM o.orderDate)) > 2
AND SUM(od.quantityOrdered) > 1000
AND SUM(od.quantityOrdered * od.priceEach)/ COUNT(DISTINCT o.orderNumber) > 10000
ORDER BY avg_nilai_per_order DESC;

--soal tambahan
--1
SELECT 
CONCAT(e.firstname, ' ', e.lastname) AS tenaga_penjual,
COALESCE(STRING_AGG(c.customername, ', '),'Belum ada pelanggan') AS nama_pelanggan_yg_ditangani,
COALESCE(SUM(od.quantityOrdered),0) AS total_barang,
COALESCE(SUM(od.quantityordered * od.priceeach),0) AS total_pendapatan
FROM employees e
LEFT JOIN customers c
ON c.salesrepemployeenumber = e.employeenumber
LEFT JOIN orders o
ON o.customernumber = c.customernumber
LEFT JOIN orderdetails od
ON od.ordernumber = o.ordernumber
WHERE jobtitle ILIKE '%Sales Rep%'
GROUP BY e.firstname, e.lastname
ORDER BY total_pendapatan DESC;

--2
SELECT o.city, 
COALESCE(STRING_AGG(CONCAT(e.firstname, ' ', e.lastname), ' - '), 'Belum ada karyawan') AS daftar_karyawan,
COALESCE(COUNT(DISTINCT c.customernumber),0) AS jumlah_pelanggan
FROM offices o
LEFT JOIN employees e
ON e.officecode = o.officecode
LEFT JOIN customers c
ON c.salesrepemployeenumber = e.employeenumber
GROUP BY o.city
ORDER BY jumlah_pelanggan DESC;

--3
SELECT 
c.customername AS nama_pelanggan, 
COALESCE(STRING_AGG(DISTINCT p.productline, ', '), 'Belum berbelanja') AS nama_kategori_produk,
COALESCE(SUM(od.quantityordered),0) AS total_jumlah_barang,
COALESCE(SUM(od.quantityordered * od.priceeach),0) AS total_pengeluaran
FROM offices ofc
JOIN employees e
	ON e.officeCode = ofc.officecode
JOIN customers c
	ON c.salesrepemployeenumber = e.employeenumber
LEFT JOIN orders o
	ON o.customernumber = c.customernumber
LEFT JOIN orderdetails od
	ON o.orderNumber = od.orderNumber
LEFT JOIN products p
	ON od.productCode = p.productCode
WHERE ofc.city = 'Paris'
GROUP BY c.customername
ORDER BY total_pengeluaran DESC;





