/****** Script for SelectTopNRows command from SSMS  ******/
SELECT Id_Empresa, COUNT(ID) as Cantidad_De_Rendiciones FROM [GD2C2017].[dbo].[Rendicion]

  group by Id_Empresa