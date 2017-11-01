CREATE FUNCTION clientesConMasPagos(@anio int, @trimestre int)
RETURNS TABLE
AS 

	RETURN (

		select top 5 c.* from Cliente c join Pago p on c.dni_cliente = p.dni_cliente
			where dbo.esFechaValida(p.fecha_pago, @anio, @trimestre) = 1
			group by c.dni_cliente, c.nombre, c.apellido, c.mail, c.nacimiento, c.telefono, c.codigo_postal, c.habilitadx, c.domicilio
			order by count(p.dni_cliente) DESC

	)
