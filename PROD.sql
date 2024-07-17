CREATE PROC sp_GetTableList
AS
BEGIN
	SELECT * FROM dbo.BanAn
END

EXEC sp_GetTableList