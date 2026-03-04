CREATE PROCEDURE dbo.update_watermark
 @lastload DATETIME2(3)
AS
BEGIN
    UPDATE [dbo].[watermark_table]
	SET last_watermark = SYSDATETIME(),
	    last_load = @lastload
END;