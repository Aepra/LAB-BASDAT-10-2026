set search_path to classicmodels;

-- soal1


-- soal2
select
    productcode,
    sum(quantityordered) as total_unit_terjual,
    count(distinct ordernumber) as jumlah_pesanan
from orderdetails
group by productcode
having sum(quantityordered) > (
    select avg(quantityordered)
    from orderdetails
)
and count(distinct ordernumber) > 10
order by total_unit_terjual desc;

-- soal3
select
    productcode,
    productname,
    quantityinstock,
    msrp
from products
where quantityinstock > (
    select avg(quantityinstock)
    from products
)
and msrp > (
    select avg(msrp)
    from products
)
order by quantityinstock desc;

-- soal4
begin;

update orders
set status = 'Pengiriman'
where ordernumber = 10100;

savepoint status_pengiriman;

update orders
set status = 'Batal'
where ordernumber = 10100;

rollback to savepoint status_pengiriman;

commit;

-- soal5
create table anggota (
    id integer generated always as identity primary key,
    nama_anggota varchar(50) not null,
    kota_domisili varchar(20) not null
);

create table buku (
    id integer generated always as identity primary key,
    judul_buku varchar(100) not null,
    genre varchar(20) not null,
    stok integer default 1
);

create table peminjaman (
    id integer generated always as identity primary key,
    id_anggota integer references anggota(id),
    id_buku integer references buku(id),
    tanggal_pinjam date not null,
    tanggal_kembali date,
    denda integer default 0
);

create index idx_buku_genre
on buku(genre);

create index idx_anggota_kota_domisili
on anggota(kota_domisili);

-- soal tambahan no 3
select
    productcode,
    productname,
    productline,
    buyprice
from products
where productline = 'Classic Cars'
and buyprice > (
    select max(buyprice)
    from products
    where productline = 'Vintage Cars'
)
order by buyprice desc;
