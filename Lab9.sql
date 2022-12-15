-- Viết hàm diemtb dạng Scarlar function tính điểm trung bình của một sinh viên bất kỳ
CREATE FUNCTION DIEMTB (@MSV CHAR(5))
RETURNS FLOAT
AS
BEGIN
DECLARE @TB FLOAT
SET @TB = (SELECT AVG(DIEMTHI)
FROM KETQUA
WHERE MASV=@MSV)
RETURN @TB
END
GO
SELECT DBO.DIEMTB ('01')GO
-- Viết hàm bằng 2 cách (table – value fuction và multistatement value function) 
-- tính điểm trung bình của cả lớp, thông tin gồm MaSV, Hoten, ĐiemTB, 
-- sử dụng hàm diemtb ở câu 1

-- CACH 1
CREATE FUNCTION TRBINHLOP(@MALOP CHAR(5))
RETURNS TABLE
AS
RETURN
SELECT S.MASV, HOTEN, TRUNGBINH=DBO.DIEMTB(S.MASV)
FROM SINHVIEN S JOIN KETQUA K ON S.MASV = K.MASV
WHERE MALOP = @MALOP
GROUP BY S.MASV, HOTEN

-- CACH 2
GO
CREATE FUNCTION TRBINHLOP1(@MALOP CHAR(5))
RETURNS @DSDIEMTB TABLE (MASV CHAR(5), TENSV NVARCHAR(20), DTB FLOAT)
AS
BEGIN
INSERT @DSDIEMTB
SELECT S.MASV, HOTEN, TRUNGBINH = DBO.DIEMTB(S.MASV)
FROM SINHVIEN S JOIN KETQUA K ON S.MASV = K.MASV
WHERE MALOP = @MALOP
GROUP BY S.MASV, HOTEN
RETURN
END
GO
SELECT*FROM TRBINHLOP1('A')-- Viết một thủ tục kiểm tra một sinh viên đã thi bao nhiêu môn, tham số là MaSV,
-- (VD sinh viên có MaSV = 01 thi 3 môn) kết quả trả về chuỗi thông báo 
-- “Sinh viên 01 thi 3 môn” hoặc “Sinh viên 01 không thi môn nào”
GO
CREATE PROC KTRA @MSV CHAR(5)
AS
BEGIN
DECLARE @N INT
SET @N = (SELECT COUNT(*) FROM KETQUA WHERE MASV = @MSV)
IF @N = 0
	PRINT 'SINH VIEN ' + @MSV + 'KHONG THI MON NAO'
ELSE
	PRINT 'SINH VIEN ' + @MSV + 'THI ' + CAST(@N AS CHAR(2)) + 'MON'
END
GO
EXEC KTRA '01'


-- Viết một trigger kiểm tra sỉ số lớp khi thêm một sinh viên mới vào danh sách 
-- sinh viên thì hệ thống cập nhật lại siso của lớp, mỗi lớp tối đa 10SV, 
-- nếu thêm vào &gt;10 thì thông báo lớp đầy và hủy giao dịch
GO
CREATE TRIGGER UPDATESSLOP
ON SINHVIEN
FOR INSERT
AS
BEGIN
DECLARE @SS INT
SET @SS = (SELECT COUNT(*) FROM SINHVIEN S
WHERE MALOP IN(SELECT MALOP FROM INSERTED))
IF @SS > 10
BEGIN
PRINT 'LOP DAY'
ROLLBACK TRAN
END
ELSE
BEGIN
UPDATE LOP
SET SISO = @SS
WHERE MALOP IN (SELECT MALOP FROM INSERTED)
END
