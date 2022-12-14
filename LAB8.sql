
/* CAU 3.1 */
GO
SELECT MASP, TENSP
FROM SANPHAM
WHERE NUOCSX LIKE 'Trung Quoc'

/* CAU 3.2 */
GO
SELECT MASP, TENSP
FROM SANPHAM
WHERE DVT LIKE 'cay' OR DVT LIKE 'quyen'

/* CAU 3.3 */
GO
SELECT MASP, TENSP
FROM SANPHAM
WHERE MASP LIKE 'B%01'

/* CAU 3.4 */
GO
SELECT MASP, TENSP, GIA
FROM SANPHAM
WHERE NUOCSX LIKE 'Trung Quoc'
AND GIA BETWEEN 30000 AND 40000

/* CAU 3.5 */
GO
SELECT MASP, TENSP, GIA, NUOCSX
FROM SANPHAM
WHERE (NUOCSX LIKE 'Trung Quoc' OR NUOCSX LIKE 'Thai Lan')
AND (GIA BETWEEN 30000 AND 40000)

/* CAU 3.6 */
GO
SELECT *
FROM HOADON
WHERE NGHD = '2007/1/1' OR NGHD = '2007/1/2'

/* CAU 3.7 */
GO 
SELECT SOHD, TRIGIA 
FROM HOADON 
WHERE YEAR (NGHD) = 2007 AND MONTH (NGHD) = 1 
ORDER BY NGHD, TRIGIA DESC

/* CAU 3.8 */
GO
SELECT KHACHHANG.MAKH, HOTEN 
FROM KHACHHANG, HOADON
WHERE KHACHHANG.MAKH = HOADON.MAKH AND HOADON.NGHD = '2007/1/1'

/* CAU 3.9 */
GO
SELECT SOHD, TRIGIA
FROM HOADON, NHANVIEN
WHERE HOADON.MANV = NHANVIEN.MANV AND NHANVIEN.HOTEN LIKE 'Nguyen Van B'

/* CAU 3.10 */
SELECT SANPHAM.MASP, SANPHAM.TENSP 
FROM SANPHAM, HOADON, CTHD, KHACHHANG 
WHERE SANPHAM.MASP = CTHD.MASP AND CTHD.SOHD = HOADON.SOHD 
AND HOADON.MAKH = KHACHHANG.MAKH AND KHACHHANG.HOTEN = 'NGUYEN VAN A' 
AND YEAR(HOADON.NGHD) = 2006 AND MONTH(HOADON.NGHD) = 10

SELECT * FROM SANPHAM,KHACHHANG
GO
UPDATE SANPHAM SET GIA = GIA + GIA / (100/5)
WHERE NUOCSX = 'Thai Lan'

GO
UPDATE SANPHAM SET GIA = GIA / (100/5) + GIA
WHERE NUOCSX = 'Trung Quoc'

GO
UPDATE KHACHHANG SET LOAIKH ='VIP' 
WHERE (NGDK<cast('2011/1/1' as date) AND DOANHSO>=10000000) 
OR (NGDK>cast('2011/1/1' as date) AND DOANHSO >=2000000)