SET search_path TO classicmodels; 

-- NO 1

SELECT ordernumber, UPPER (productcode) AS "Kode Produk", quantityordered, priceeach FROM orderdetails
WHERE (quantityordered BETWEEN 20 AND 50 OR priceeach <30 )
AND LEFT(productcode,3) LIKE 'S18%'
ORDER By quantityordered DESC;

-- NO 2
SELECT customerNumber,customerName,country,creditlimit, CONCAT(contactFirstName,' ',contactLastName) AS "Nama Kontak", Creditlimit - 10000 AS "Selisih Kredit" FROM customers
WHERE (country ilike 'USA' 
or country ilike 'Canada'
or country ilike 'France')
AND creditlimit > 30000
ORDER BY creditlimit DESC;

-- NO 3
SELECT productCode,productname ,buyPrice,msrp,GREATEST(buyprice,msrp) AS "Harga Tertinggi", LEAST(buyprice,msrp) AS "Harga Terendah" FROM products
WHERE productName ILIKE '%car%';
-- NO 3 +
SELECT productCode,substring(productName, 6, 100) ,buyPrice,msrp,GREATEST(buyprice,msrp) AS "Harga Tertinggi", LEAST(buyprice,msrp) AS "Harga Terendah" FROM products
WHERE productName ILIKE '%car%';

-- NO 4
SELECT orderNumber,orderDate,shippedDate,EXTRACT(YEAR FROM orderDate) AS "Tahun",EXTRACT(MONTH FROM orderDate) AS "Bulan",shippedDate-orderDate AS "Lama Pengiriman", AGE (shippedDate,orderDate) AS "Interval Pengiriman", CURRENT_DATE AS "Tanggal Laporan", CURRENT_TIME AS "Waktu Laporan" FROM orders
WHERE shippedDate IS NOT NULL;

-- NO 5
SELECT orderNumber,
orderDate,
shippedDate, 
orderDate + INTERVAL '10 days'AS "Estimasi Kirim",
COALESCE(shippedDate, (orderDate + INTERVAL '10 days')) AS "Tanggal Aktual", 
AGE (shippedDate,orderDate) AS "Selisih Waktu" FROM orders
WHERE comments ILIKE '%customer%' AND EXTRACT(MONTH FROM orderDate) BETWEEN 10 AND 12 AND (orderNumber % 2) !=0
ORDER BY orderDate DESC;

select * from products;

-- soal tambahan 1
select productcode, productname, upper(substring(productname, 6, 15)) as short_name, (buyprice*0.7+quantityinstock%10) as promo_price from products
where productname ilike '%v%'
and (quantityinstock between 1000 and 4000)
and (quantityinstock & 4 = 4);

-- soal tambahan 2
select ordernumber, orderdate, coalesce(shippeddate, current_date) as tanggalPenyelesaian, greatest(requireddate, shippeddate) as toleransiAkhir, age(requireddate,orderdate) as targetHari from orders
where extract(year from orderdate) = '2003'
and comments is not null
order by requireddate-orderdate desc;