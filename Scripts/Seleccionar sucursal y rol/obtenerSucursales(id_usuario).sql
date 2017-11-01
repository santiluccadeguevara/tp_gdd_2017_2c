CREATE FUNCTION dbo.obtenerSucursales(@id_usuario int)
RETURNS table

	return (

		select s.* from Rol_De_Usuario_Por_Sucursal as rus join Sucursal s on rus.cp_sucursal = s.cp_sucursal
			where @id_usuario = rus.id_usuario

	)