DECLARE @i INT = 0
WHILE @i <= 10
BEGIN
	INSERT dbo.BanAn (TenBan) VALUES (N'Bàn ' + CAST(@i AS nvarchar(100)))
	SET @i = @i + 1
END