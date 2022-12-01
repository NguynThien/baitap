CREATE TRIGGER checkSalary ON NHANVIEN
FOR INSERT, UPDATE
AS
IF((SELECT LUONG FROM inserted) < 15000)
BEGIN
	PRINT N'Lương > 15000'
	ROLLBACK TRANSACTION
END
SELECT * FROM NHANVIEN
INSERT INTO [dbo].[NHANVIEN] ([HONV], [TENLOT], [TENNV],
[MANV], [NGSINH], [DCHI], [PHAI], [LUONG], [MA_NQL], [PHG])
VALUES(N'Nguyen', N'Ngoc', N'Thien', 
'140', '2002-03-10', 'TP HCM', 'Nam', 40000, '001', 1)

GO

CREATE TRIGGER checkAge ON NHANVIEN
FOR INSERT
AS
DECLARE @age INT
SELECT @age = DATEDIFF(YEAR, NGSINH, GETDATE()) + 1 FROM inserted
IF(@age < 18 or @age > 65)
BEGIN
	PRINT N'Tuổi nhân viên không hợp lệ! (18 - 65)'
	ROLLBACK TRANSACTION
END

INSERT INTO [dbo].[NHANVIEN] ([HONV], [TENLOT], [TENNV],
[MANV], [NGSINH], [DCHI], [PHAI], [LUONG], [MA_NQL], [PHG])
VALUES(N'Nguyen', N'Ngoc', N'Thien', 
'140', '2002-03-10', 'TP HCM', 'Nam', 40000, '001', 1)

GO

CREATE TRIGGER checkHCM ON NHANVIEN
FOR UPDATE
AS
IF EXISTS(SELECT DCHI FROM inserted where DCHI LIKE '%HCM%')
BEGIN
	PRINT N'Không thể cập nhật nhân viên ở HCM';
	ROLLBACK TRANSACTION
END

INSERT INTO [dbo].[NHANVIEN] ([HONV], [TENLOT], [TENNV],
[MANV], [NGSINH], [DCHI], [PHAI], [LUONG], [MA_NQL], [PHG])
VALUES(N'Nguyen', N'Ngoc', N'Thien', 
'140', '2002-03-10', 'TP HCM', 'Nam', 40000, '001', 1)

GO




CREATE TRIGGER TONGNV_I ON NHANVIEN
AFTER INSERT
AS
DECLARE @MALE INT, @FEMALE INT
SELECT @FEMALE = count(Manv) FROM NHANVIEN WHERE PHAI = N'Nữ'
SELECT @MALE = count(Manv) FROM NHANVIEN WHERE PHAI = N'Nam'
PRINT N'Tổng số nhân viên là nữ: ' + cast(@FEMALE as varchar)
PRINT N'Tổng số nhân viên là nam: ' + cast(@MALE as varchar)

INSERT INTO [dbo].[NHANVIEN] ([HONV], [TENLOT], [TENNV],
[MANV], [NGSINH], [DCHI], [PHAI], [LUONG], [MA_NQL], [PHG])
VALUES(N'Nguyen', N'Ngoc', N'Thien', 
'140', '2002-03-10', 'TP HCM', 'Nam', 40000, '001', 1)

GO

CREATE TRIGGER TONGNV_U
ON NHANVIEN
AFTER UPDATE
AS
IF((select top 1 PHAI FROM deleted) != (select top 1 PHAI FROM inserted))
BEGIN
Declare @MALE int, @FEMALE int;
SELECT @FEMALE = count(Manv) from NHANVIEN where PHAI = N'Nữ'
SELECT @MALE = count(Manv) from NHANVIEN where PHAI = N'Nam'
PRINT N'Tổng số nhân viên là nữ: ' + cast(@FEMALE as varchar)
PRINT N'Tổng số nhân viên là nam: ' + cast(@MALE as varchar)
END

INSERT INTO [dbo].[NHANVIEN] ([HONV], [TENLOT], [TENNV],
[MANV], [NGSINH], [DCHI], [PHAI], [LUONG], [MA_NQL], [PHG])
VALUES(N'Nguyen', N'Ngoc', N'Thien', 
'140', '2002-03-10', 'TP HCM', 'Nam', 40000, '001', 1)

GO

CREATE TRIGGER TONGNV_D ON DEAN
AFTER DELETE
AS
SELECT MA_NVIEN, COUNT(MADA) as 'Tổng số đề án đã tham gia' from PHANCONG
GROUP BY MA_NVIEN

GO



CREATE TRIGGER NhanThanNhanVien_D ON NHANVIEN
INSTEAD OF DELETE 
AS
BEGIN
DELETE FROM THANNHAN WHERE MA_NVIEN IN (SELECT MANV FROM deleted)
DELETE FROM NHANVIEN WHERE MANV IN (SELECT MANV FROM deleted)
END

DELETE NHANVIEN WHERE MANV='001'
SELECT * FROM THANNHAN
