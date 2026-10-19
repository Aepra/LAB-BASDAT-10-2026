SELECT customerNumber AS "Nomor Pelanggan",
customerName AS "Nama Pelanggan",
phone AS "Telepon",
country AS "Negara"
FROM customers;

SELECT productCode, productName, buyPrice FROM products
WHERE buyprice > 50
ORDER BY buyprice DESC
LIMIT 7;

SELECT DISTINCT country AS "Negara Pelanggan" FROM customers
ORDER BY country ASC
LIMIT 5 OFFSET 5;

SELECT DISTINCT country AS "Negara Pelanggan" FROM customers
ORDER BY country DESC
LIMIT 3 OFFSET 18;