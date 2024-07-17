/* Doi mat khau*/
CREATE OR ALTER PROCEDURE DoiMatKhau @email varchar(50), @matkhauCu nvarchar(250), @matkhauMoi nvarchar(250)
AS 
BEGIN
	DECLARE @op	NVARCHAR(250)
	SELECT @op = MatKhau FROM NhanVien WHERE Email = @email
	IF @op = @matkhauCu
	BEGIN
		UPDATE NhanVien
		SET MatKhau=@matkhauMoi 
		WHERE Email = @email
		RETURN 1
	END
	ELSE
		RETURN -1
END

/*ThemXoaSuaBanAn*/
CREATE OR ALTER PROCEDURE DanhSachBanAn
AS
BEGIN
	SET NOCOUNT ON;
	SELECT MaBan, SoNguoi, MonAn, TrangThai, id FROM tblKhachHang
END

CREATE OR ALTER PROCEDURE Insert_BanAn @maban varchar(20), @songuoi int, @monan nvarchar(200), @trangthai varchar(20), @email varchar(150)
AS
BEGIN 
	DECLARE @ID INT
	SELECT @ID = id FROM NhanVien WHERE @email = Email
	INSERT INTO BanAn(MaBan, SoNguoi, MonAn, TrangThai)
	VALUES(@maban, @songuoi, @monan, @trangthai)
END
GO

CREATE OR ALTER PROCEDURE Delete_BanAn @maban varchar(20)
AS
BEGIN
	DELETE FROM BanAn
	WHERE MaBan = @maban
END
GO

CREATE OR ALTER PROCEDURE Update_BanAn @maban varchar(20), @songuoi int, @monan nvarchar(200), @trangthai varchar(20)
AS
BEGIN
	UPDATE BanAn
	SET SoNguoi = @songuoi, MonAn = @monan, TrangThai = @trangthai
	WHERE MaBan = @maban
END
GO

CREATE OR ALTER PROCEDURE Search_BanAn @maban varchar(20)
AS
BEGIN
	SELECT * FROM BanAN
	WHERE MaBan LIKE '%' + @maban + '%'
END
GO