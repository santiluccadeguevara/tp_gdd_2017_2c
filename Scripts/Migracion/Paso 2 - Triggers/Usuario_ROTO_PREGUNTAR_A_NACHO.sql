CREATE TRIGGER dbo.HashUsuariosPassword
ON dbo.Usuario
INSTEAD OF INSERT
AS
BEGIN

	INSERT dbo.Usuario(username, contraseņa, habilitadx)
		SELECT username, HASHBYTES('SHA2_256', contraseņa), habilitadx
		FROM inserted;

END