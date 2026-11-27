--soal tambahan 
INSERT INTO kurir(id_kurir, nama_kurir, no_telepon, status_aktif)
VALUES(002 , 'rahuul', '08299', false);

SELECT * FROM kurir

INSERT INTO pengiriman(id_pengiriman, nomor_resi, id_kurir, tanggal_kirim, ongkos_kirim, status_pengiriman)
VALUES(9, 'XYZ', 1, NOW(), 1.00, 'Di Bontojolong');

SELECT * FROM pengiriman