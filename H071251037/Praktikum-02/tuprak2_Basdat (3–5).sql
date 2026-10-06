SET search_path TO classicmodels;

-- Soal nomor 3
SELECT customernumber as "Nomor Pelanggan", customername as "Nama Pelanggan",
phone as "Telepon", country as "Negara" FROM customers;

-- Soal nomor 4
SELECT productcode, productname, buyprice FROM products
WHERE buyprice > 50 ORDER BY buyprice DESC
LIMIT 7;

-- SELECT country FROM customers;
-- Soal nomor 5
SELECT DISTINCT country as "Negara Pelanggan" FROM customers
ORDER BY country ASC OFFSET 5 LIMIT 5;

-- Soal tambahan
SELECT DISTINCT country as "Negara Pelanggan" FROM customers
ORDER BY country DESC OFFSET 18 LIMIT 3;