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
)
-------------------------1-------------------------
INSERT INTO mahasiswa (nim, nama, email, id_prodi)
VALUES 
    ('H071251001', 'Andi Pratama', 'andi@gmail.com', 1),
    ('230101000', 'Budi Santoso', NULL, 1),
    ('2301010003', 'Citra Dewi', 'citra@gmail.com', 2)
RETURNING *;
--------------------------2----------------------------
UPDATE mahasiswa 
SET ipk = 3.75 
WHERE ipk = 3.50
RETURNING *;

DELETE FROM mahasiswa 
WHERE email IS NULL
RETURNING *;

-----------------------------------------------------
CREATE TABLE IF NOT EXISTS ClassicModels.Customers (
  customerNumber INTEGER PRIMARY KEY,
  customerName VARCHAR(50) NOT NULL,
  contactLastName VARCHAR(50) NOT NULL,
  contactFirstName VARCHAR(50) NOT NULL,
  phone VARCHAR(50) NOT NULL,
  addressLine1 VARCHAR(50) NOT NULL,
  addressLine2 VARCHAR(50),
  city VARCHAR(50) NOT NULL,
  state VARCHAR(50),
  postalCode VARCHAR(15),
  country VARCHAR(50) NOT NULL,
  salesRepEmployeeNumber INTEGER NULL,
  creditLimit NUMERIC,
  customerLocation VARCHAR(100) NOT NULL,
  CONSTRAINT fk_fk_Customers_Employees
  	FOREIGN KEY (salesRepEmployeeNumber)
	REFERENCES ClassicModels.Employees (employeeNumber)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
);

CREATE INDEX IF NOT EXISTS fk_Customers_Employees_idx ON ClassicModels.Customers
(
    salesRepEmployeeNumber ASC
);


CREATE TABLE IF NOT EXISTS ClassicModels.Products (
  productCode VARCHAR(15) PRIMARY KEY,
  productName VARCHAR(70) NOT NULL,
  productScale VARCHAR(10) NOT NULL,
  productVendor VARCHAR(50) NOT NULL,
  productDescription TEXT NOT NULL,
  quantityInStock SMALLINT NOT NULL,
  buyPrice NUMERIC NOT NULL,
  MSRP NUMERIC NOT NULL,
  productLine VARCHAR(50) NULL,
  CONSTRAINT fk_Products_ProductLines
  	FOREIGN KEY (productLine)
	REFERENCES ClassicModels.ProductLines (productLine)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION
);

CREATE INDEX IF NOT EXISTS fk_Products_ProductLines_idx ON ClassicModels.Products
(
    productLine ASC
);

---------------------3------------------
SELECT 
    customerNumber AS "Nomor Pelanggan",
    customerName AS "Nama Pelanggan",
    phone AS "Telepon",
    country AS "Negara"
FROM ClassicModels.Customers;

--------------------4--------------------
SELECT 
    productCode,
    productName,
    buyPrice
FROM ClassicModels.Products
WHERE buyPrice > 50
ORDER BY buyPrice DESC
LIMIT 7;

--------------------5---------------------
SELECT DISTINCT 
    country AS "Negara Pelanggan"
FROM ClassicModels.Customers
ORDER BY country ASC
LIMIT 5 OFFSET 5;


--------------------testing-------------
UPDATE mahasiswa
SET ipk = 3.50
WHERE nama = 'Citra Dewi'
RETURNING *;

SELECT DISTINCT 
    country AS "Negara Pelanggan"
FROM ClassicModels.Customers
ORDER BY country DESC
LIMIT 3 OFFSET 18;
