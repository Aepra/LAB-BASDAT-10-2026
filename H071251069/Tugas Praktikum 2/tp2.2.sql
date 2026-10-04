set search_path TO classicmodels;

SELECT customerNumber as "Nomor Pelanggan",
customerName as "Nama Pelanggan", 
phone as "Telepon", 
country as "Negara" FROM customers;

SELECT productCode,productName,buyPrice FROM products
WHERE buyPrice > 50
ORDER BY buyPrice DESC
LIMIT 7;

SELECT DISTINCT country AS "Negara Pelanggan" FROM customers
ORDER BY country ASC
LIMIT 5 OFFSET 5

SELECT DISTINCT country FROM customers
WHERE country IN ('Ireland','Hong Kong','Germany');
