set search_path to classicmodels;

-- soal 1
select 
	c.contactfirstname as "nama depan kontak pelanggan",
	c.customername as "nama lengkap pelanggan",
	of.city as "kota tempat kantor cabang",
	e.firstname || ' ' || e.lastname as "nama lengkap sales"
	
from customers as c
join employees as e
	on c.salesrepemployeenumber = e.employeenumber
join offices as of 
	on of.officecode = e.officecode
where c.contactfirstname ilike 'A%'
	and of.city not like 'NYC'
order by c.customername;




-- soal 2
select
	c.customername,
	sum(p.amount) as total_payment,
	max(p.amount) as max_single_payment
from customers as c
join payments as p
	on c.customernumber = p.customernumber
group by c.customernumber
having sum(p.amount) > 50000
order by total_payment desc;




-- soal 3
select 
	c.customername,
	count(distinct o.ordernumber) as total_order,
	round(avg(od.quantityordered),2) as avg_quantity_per_order
from customers as c
join orders as o
	on c.customernumber = o.customernumber
join orderdetails as od
	on o.ordernumber = od.ordernumber
group by c.customername
having count(distinct o.ordernumber) > 3
and round(avg(od.quantityordered),2) > 35
order by total_order desc, avg_quantity_per_order desc;




-- soal 4
select
	p.productline,
	sum(od.quantityordered) as total_terjual,
	round(avg(od.priceeach),2) as rata_rata_harga,
	round(avg((p.msrp-od.priceeach)/p.msrp*100),2) as avg_discount_persentage
from orderdetails as od
join products as p
	on od.productcode = p.productcode
group by p.productline
having sum(od.quantityordered) > 3000
and round(avg(od.priceeach),2) > 80
order by total_terjual desc;
 



-- soal 5
select 
	c.customername,
	sum(od.priceeach*od.quantityordered) as total_transaksi,
	count(distinct o.ordernumber),
	round(
		sum(od.priceeach*od.quantityordered)
		/count(distinct o.ordernumber),2
	) as avg_transaction_per_order
from customers as c
join orders as o
	on c.customernumber = o.customernumber
join orderdetails as od
	on o.ordernumber = od.ordernumber
where o.status = 'Shipped'
group by c.customername, c.customernumber
having count(distinct extract(year from o.orderdate)) > 1
order by total_transaksi desc
limit 5;




-- soal 6
select
	c.customername,
	c.city as customer_city,
	of.city as office_city,
	sum(od.quantityordered) as total_unit_terjual,
	round(sum(od.priceeach*od.quantityordered)/count(distinct o.ordernumber),2) as avg_nilai_per_order
from customers as c
join employees as e
	on c.salesrepemployeenumber = e.employeenumber
join offices as of
	on e.officecode = of.officecode
join orders as o
	on c.customernumber = o.customernumber
join orderdetails as od
	on o.ordernumber = od.ordernumber
where of.territory = 'EMEA'
group by c.customernumber,c.customername,c.city,of.city
having 
	count(distinct extract(year from o.orderdate)) > 2
	and sum(od.quantityordered) > 1000
	and sum(od.priceeach*od.quantityordered)/count(distinct o.ordernumber) > 10000
order by avg_nilai_per_order desc;




-- soal tambahan 1
select
	e.firstname || ' ' || e.lastname,
	coalesce((String_Agg(distinct c.customername, ', ')), 'belum ada pelanggan') daftar_pelanggan,
	coalesce((count(od.quantityordered)),0) as jumlah_barang,
	coalesce((sum(od.quantityordered*od.priceeach)),0) as total_pendapatan
from employees as e
left join customers as c
on c.salesrepemployeenumber = e.employeenumber
left join orders as o
on c.customernumber = o.customernumber
left join orderdetails as od
on o.ordernumber = od.ordernumber
where e.jobtitle = 'Sales Rep'
group by e.firstname || ' ' || e.lastname
order by total_pendapatan desc;

-- soal tambahan 2
select 
	of.city,
	coalesce((string_agg(distinct (e.firstname || ' ' || e.lastname), '-')),'belum ada karyawan'),
	coalesce((count(distinct customername)),0)
from offices as of
join employees as e
on of.officecode = e.officecode
join customers as c
on c.salesrepemployeenumber = e.employeenumber
group by of.city

-- soal tambahan 3
select 
	c.customername,
	coalesce((string_agg(distinct productline, ', ')), 'belum berbelanja'),
	coalesce((sum(od.quantityordered)),0) as total_barang,
	coalesce((sum(od.quantityordered*od.priceeach)),0) as total_pengeluaran
from offices as of
join employees as e
on of.officecode = e.officecode
join customers as c
on c.salesrepemployeenumber = e.employeenumber
left join orders as o
on c.customernumber = o.customernumber
left join orderdetails as od
on o.ordernumber = od.ordernumber
left join products as p
on od.productcode = p.productcode
where of.city = 'Paris'
group by c.customername
order by total_pengeluaran desc;

