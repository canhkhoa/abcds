CREATE DATABASE DA1
CREATE TABLE NhanVien
(
  IdNV INT IDENTITY(1,1) NOT NULL,
  HoTen NVARCHAR(50) NOT NULL, -- 
  SDT VARCHAR(15) NOT NULL, 
  NgaySinh DATE NOT NULL, --
  Email NVARCHAR(100) NOT NULL, 
  MatKhau NVARCHAR(50) NOT NULL, 
  ChucVu NVARCHAR(50) not null,
  phai nvarchar(20) not null,
  MaNV NVARCHAR(20) NOT NULL,
  PRIMARY KEY (IdNV)
);

CREATE TABLE BanAn
(
  id INT NOT NULL,
  name INT NOT NULL,
  status NVARCHAR(50) NOT NULL, -- Dùng NVARCHAR cho trạng thái để hỗ trợ Unicode và có thể mở rộng độ dài
  PRIMARY KEY (id)
);

CREATE TABLE HoaDon
(
  idHD INT IDENTITY(1,1) ,
  TrangThai NVARCHAR(50) NOT NULL, -- Dùng NVARCHAR cho trạng thái để hỗ trợ Unicode và có thể mở rộng độ dài
  TongTien DECIMAL(18, 2) NOT NULL, -- Dùng DECIMAL cho số tiền để lưu trữ tiền tệ chính xác
  IdNV INT NOT NULL,
  NgayXuatHD DATE not null,
  TenKH nvarchar(50) not null,
  PRIMARY KEY (idHD),
  FOREIGN KEY (IdNV) REFERENCES NhanVien(IdNV)
);

CREATE TABLE MonAn
(
  IdMon INT NOT NULL,
  TenMon NVARCHAR(100) NOT NULL, -- Dùng NVARCHAR cho tên món để hỗ trợ Unicode và độ dài lớn hơn
  Gia DECIMAL(18, 2) NOT NULL, -- Dùng DECIMAL cho giá để lưu trữ tiền tệ chính xác
  PRIMARY KEY (IdMon)
);

CREATE TABLE SPNhapKho
(
  IdNhapKho INT IDENTITY(1,1) NOT NULL,
  HSD DATE NOT NULL, -- Dùng DATE cho ngày hết hạn để lưu trữ ngày tháng
  NgayNhap DATE NOT NULL, -- Dùng DATE cho ngày nhập kho để lưu trữ ngày tháng
  SoLuong INT NOT NULL,
  
  TenSP NVARCHAR(100) NOT NULL, -- Dùng NVARCHAR cho tên sản phẩm để hỗ trợ Unicode và độ dài lớn hơn
  MaLoai VARCHAR(20) NOT NULL,
  NhaCungCap NVARCHAR(100) NOT NULL, -- Dùng NVARCHAR cho nhà cung cấp để hỗ trợ Unicode và độ dài lớn hơn
  IdNV INT NOT NULL,
  PRIMARY KEY (IdNhapKho),
  FOREIGN KEY (IdNV) REFERENCES NhanVien(IdNV)
);

CREATE TABLE DonDatHang -- Đổi tên bảng "order" thành "DonDatHang" vì "order" là từ khóa trong SQL
(
  Ngay DATE NOT NULL, -- Dùng DATE cho ngày để lưu trữ ngày tháng
  IdNV INT NOT NULL,
  MaBan INT NOT NULL,
  PRIMARY KEY (IdNV, MaBan),
  FOREIGN KEY (IdNV) REFERENCES NhanVien(IdNV),
  FOREIGN KEY (MaBan) REFERENCES BanAn(MaBan)
);

CREATE TABLE HoaDonChiTiet
(
  SoLuong INT NOT NULL,
  ThanhTien DECIMAL(18, 2) NOT NULL, -- Dùng DECIMAL cho thành tiền để lưu trữ tiền tệ chính xác
  idHD INT NOT NULL,
  IdMon INT NOT NULL,
  PRIMARY KEY (idHD, IdMon),
  FOREIGN KEY (idHD) REFERENCES HoaDon(idHD),
  FOREIGN KEY (IdMon) REFERENCES MonAn(IdMon)
);
-------------------------------------------------------------------------------
------------------------------------------------


----- NHAN VIEN

-- Danh sách nhân viên
create or ALTER proc DSNV
as
begin
	select * from NhanVien
end
-- thực thi
exec DSNV
go




-- Thêm danh sách nhân viên---- them nv
go
CREATE or ALTER PROCEDURE AddNhanVien
    @HoTen NVARCHAR(50),
    @SDT VARCHAR(15),
    @NgaySinh DATE,
    @Email NVARCHAR(100),
    @MatKhau NVARCHAR(50),
    @ChucVu NVARCHAR(50),
    @Phai NVARCHAR(20)
AS
BEGIN
    -- Khai báo biến
    DECLARE @MaNV NVARCHAR(20), @id INT;

    -- Lấy giá trị IdNV lớn nhất hiện có và tăng lên 1
    SELECT @id = ISNULL(MAX(IdNV), 0) + 1 FROM NhanVien;

    -- Tạo giá trị MaNV
    SET @MaNV = 'NV' + RIGHT('0000' + CAST(@id AS NVARCHAR(4)), 4);

    -- Thêm bản ghi mới vào bảng NhanVien
    INSERT INTO NhanVien (MaNV, HoTen, NgaySinh, Email, SDT, ChucVu , Phai , MatKhau) 
    VALUES (@MaNV, @HoTen, @NgaySinh, @Email, @SDT, @ChucVu, @Phai , @MatKhau);
END
GO

EXEC AddNhanVien
    @HoTen = 'Vu',
    @SDT = '098677566',
    @NgaySinh = '2024-07-10',
    @Email = 'vu@gmaisjd',
    @MatKhau = 'abc53',
    @ChucVu = 'xyz',
    @phai = 'Nam';
    GO
-- Danh sách nhân viên



-- Cập nhật nhân viên 

create proc CapNhatDSNV @MaNV NVARCHAR(50), 
					  @HoTen NVARCHAR(100), 
					  @NgaySinh DATE, 
					  @SDT VARCHAR(20),  
					  @Phai NVARCHAR(20), 
					  @Chucvu NVARCHAR(50), 
					  @Email NVARCHAR(150), 
					  @MatKhau NVARCHAR(50) 
as
begin
	update NhanVien
	set HoTen = @HoTen,
		NgaySinh = @NgaySinh,
		SDT = @SDT,
		Phai = @Phai,
		Chucvu = @Chucvu,
		Email = @Email,
		MatKhau = @MatKhau
	 where MaNV = @MaNV;
end

go

-- Tìm kiếm nhân viên 
create proc TimKiemNV (@tukhoa nvarchar(100))
as
begin
	select * from NhanVien where 
	MaNV like '%' + @tukhoa + '%'
	or HoTen like '%' + @tukhoa + '%'
	or NgaySinh like '%' + @tukhoa + '%'
	or SDT like '%' + @tukhoa + '%'
	or Phai like '%' + @tukhoa + '%'
	or Chucvu like '%' + @tukhoa + '%'
	or Email like '%' + @tukhoa + '%'
	or MatKhau like '%' + @tukhoa + '%'
end

-- thực thi 
Exec TimKiemNV 'NV0001';

GO
-- Xóa nhân viên 
create proc XoaDSNV (@MaNV varchar(100))
as
begin
	delete from NhanVien where MaNV = @MaNV;
end
GO






---------------------------------------------------------------------------


-------------------HOA DƠN-------------------------------------------------

-- load dữ liệu
GO
CREATE OR ALTER PROCEDURE LoadHoaDon
AS
BEGIN
    SELECT idHD, TrangThai, TongTien, IdNV, TenKH
    FROM HoaDon;
END
GO

EXEC LoadHoaDon;
GO


-- THÊM-------
CREATE OR ALTER PROCEDURE LoadHoaDon
AS
BEGIN
    SELECT idHD, TrangThai, TongTien, IdNV, TenKH
    FROM HoaDon;
END
GO


CREATE OR ALTER PROCEDURE AddHoaDon
    @TrangThai NVARCHAR(50),
    @TongTien DECIMAL(18, 2),
    @IdNV INT,
    @TenKH NVARCHAR(50)
    AS
BEGIN
    
    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE IdNV = @IdNV)
    BEGIN
        PRINT 'Nhân viên với IdNV này không tồn tại.';
        RETURN;
    END

   
    INSERT INTO HoaDon (TrangThai, TongTien, IdNV, TenKH)
    VALUES (@TrangThai, @TongTien, @IdNV, @TenKH);

   
    PRINT 'Hóa đơn đã được thêm thành công.';
END
GO

EXEC AddHoaDon
    @TrangThai = N'Chờ xử lý',
    @TongTien = 500000.00,
    @IdNV = 1, -- 
    @TenKH = N'Nguyễn Văn B';
GO

-- SỬA -------
CREATE OR ALTER PROCEDURE UpdateHoaDon
    @idHD INT,
    @TrangThai NVARCHAR(50),
    @TongTien DECIMAL(18, 2),
    @IdNV INT,
    @TenKH NVARCHAR(50)
AS
BEGIN
    -- Kiểm tra nếu IdNV tồn tại trong bảng NhanVien
    IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE IdNV = @IdNV)
    BEGIN
        PRINT 'Nhân viên với IdNV này không tồn tại.';
        RETURN;
    END

   
    UPDATE HoaDon
    SET 
        TrangThai = @TrangThai, 
        TongTien = @TongTien, 
        IdNV = @IdNV, 
        TenKH = @TenKH
    WHERE idHD = @idHD;

    PRINT N'Hóa đơn đã được cập nhật thành công.';
END
GO



-----Xóa-------------
CREATE OR ALTER PROCEDURE DeleteHoaDon
    @idHD INT
AS
BEGIN
    DELETE FROM HoaDon
    WHERE idHD = @idHD;
END
GO
-------Tìm Kiếm -----------------
CREATE OR ALTER PROCEDURE tkHoaDon
    @TenKH NVARCHAR(50),
    @NgayXuatHD date 

AS
BEGIN
    SELECT idHD, TrangThai, TongTien, IdNV, TenKH, NgayXuatHD
    FROM HoaDon
    WHERE TenKH = @TenKH or NgayXuatHD = @NgayXuatHD;
END
GO


------------------------------------------------------------------------------------------------
-----------------------------------------------NHAP KHO---------------------------------------





--load list
create or alter proc sp_nhkh_load
as begin
	select IdNhapKho, MaLoai, TenSP, SoLuong, NgayNhap, NhaCungCap, HSD, IdNV from SPNhapKho
end
go

-- Thêm
CREATE OR ALTER PROC sp_nhkh_insert
    @maloai varchar(20),
    @tensp nvarchar(100),
    @soluong int,
    @ngaynh date,
    @ncc varchar(100),
	@hsd date,
    @email varchar(100)
AS
BEGIN
    DECLARE @idnv nvarchar(20)
    SELECT @idnv = IdNV FROM NhanVien WHERE Email = @email

    DECLARE @max_maloai NVARCHAR(20);
    SELECT @max_maloai = MAX(MaLoai) FROM SPNhapKho;

    IF @max_maloai IS NULL
    BEGIN
        SET @maloai = 'SP001';
    END
    ELSE
    BEGIN
        SET @maloai = 'SP' + RIGHT('000' + CAST(CAST(SUBSTRING(@max_maloai, 3, LEN(@max_maloai) - 2) AS INT) + 1 AS NVARCHAR(20)), 3);
    END;

    INSERT INTO SPNhapKho(MaLoai, TenSP, SoLuong, NgayNhap, NhaCungCap, HSD, IdNV) 
    VALUES (@maloai, @tensp, @soluong, @ngaynh, @ncc, @hsd, @idnv)
END
GO

create or alter trigger trig_nhkh_insert on SPNhapKho
after insert
as begin
	update nk
	set HSD = DATEADD(day, 7, i.NgayNhap)
	from SPNhapKho nk
	inner join inserted i on nk.MaLoai = i.MaLoai
end
go

-- xóa
create or alter proc sp_nhkh_del
@maloai varchar(20)
as begin
	delete from SPNhapKho where MaLoai = @maloai
end
go

-- sửa
create or alter proc sp_nhkh_upd
	@maloai varchar(20),
    @tensp nvarchar(100),
    @soluong int,
    @ngaynh date,
    @ncc varchar(100),
	@hsd date,
	@email varchar (150)
as begin
	declare @idnv varchar(50)
	select @idnv = IdNV from NhanVien where Email = @email
	update SPNhapKho
	set TenSP = @tensp, SoLuong = @soluong, NgayNhap = @ngaynh, NhaCungCap = @ncc, HSD = @hsd
	where MaLoai = @maloai
end
go

create or alter trigger trig_nhkh_update on SPNhapKho
after update
as begin
	update nk
	set nk.HSD = DATEADD(day, 7, i.NgayNhap)
	from SPNhapKho nk
	inner join inserted i on nk.MaLoai = i.MaLoai
end
go
--- tìm kiếm
create or alter proc sp_nhkh_find
@ten nvarchar(100)
as begin
	select IdNhapKho, MaLoai, TenSP, SoLuong, NgayNhap, NhaCungCap, HSD, IdNV from SPNhapKho
	where TenSP = @ten
end
go

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
----------------------------------------ĐĂNG NHẬP------------------------------------------------------------
------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE sp_DangNhap
    @Email VARCHAR(100),
    @MatKhau VARCHAR(50)
AS
BEGIN
    -- Set NOCOUNT ON để ngăn chặn việc trả về số hàng bị ảnh hưởng
    SET NOCOUNT ON;

    -- Kiểm tra thông tin đăng nhập
    IF EXISTS (SELECT 1 FROM NhanVien WHERE Email = @Email AND MatKhau = @MatKhau)
    BEGIN
        SELECT 'Dang nhap thanh cong' AS ThongBao, IdNV, MaNV, HoTen, SDT, Phai, ChucVu, Email
        FROM NhanVien
        WHERE Email = @Email AND MatKhau = @MatKhau;
    END
    ELSE
    BEGIN
        SELECT 'Email hoac MatKhau khong dung' AS ThongBao;
    END
END;



---------------------đổi mk-------------------------------------------
--------------------------------------------------------------------------
GO
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
GO
/*ThemXoaSuaBanAn*/
CREATE OR ALTER PROCEDURE DanhSachBanAn
AS
BEGIN
	SET NOCOUNT ON;
	SELECT MaBan, SoNguoi,  TrangThai FROM BanAn
END
go
---- thêm-----------------------
CREATE OR ALTER PROCEDURE Insert_BanAn @maban varchar(20), @songuoi int, @trangthai varchar(20), @email varchar(150)
AS
BEGIN 
	DECLARE @ID INT
	
	INSERT INTO BanAn(MaBan, SoNguoi,TrangThai)
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
