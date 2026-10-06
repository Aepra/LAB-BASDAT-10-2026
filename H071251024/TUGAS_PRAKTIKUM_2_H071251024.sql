CREATE TABLE prodi (
	id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	nama_prodi VARCHAR(100) NOT NULL
);


CREATE TABLE mahasiswa (
	nim VARCHAR(10) PRIMARY KEY,
	nama VARCHAR(100) NOT NULL,
	ipk NUMERIC(3,2) DEFAULT 0.00,
	email VARCHAR(150) UNIQUE,
	id_prodi INT,
	CONSTRAINT fk_mahasiswa_prodi
		FOREIGN KEY (id_prodi)
		REFERENCES prodi(id)
);

insert into prodi (nama_prodi)
values ('Sistem Informasi'),
('gizi');

-- soal 1
INSERT INTO mahasiswa (nim, nama, email, id_prodi)
VALUES
('H071251024', 'El Kutang', 'kutanganda@gmail.com', 1),
('H071251022', 'Dg Syahda', NULL, 2),
('H071251021', 'Aren Gentong', 'gentong@gmail.com', 1)
returning *;

-- soal 2
update mahasiswa
set nim = 3.75
where nim = 3.50;

delete from mahasiswa
where email is not null
returning *;

-- soal 3
select customernumber as "Nomor Pelanggan", customername as "Nama Pelanggan", phone as "Telepon", country as "Negara" from classicmodels.customers;

-- soal 4
select productcode, productname,buyprice from classicmodels.products
where buyprice > 50
order by buyprice desc
limit 7;

-- soal 5
select distinct country as "Negara Pelanggan" from classicmodels.customers
order by country 
limit 5 offset 5;