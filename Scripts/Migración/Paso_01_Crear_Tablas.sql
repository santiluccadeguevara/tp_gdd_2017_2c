/* Se crean las entidades del sistema en funci�n del DER realizado */

CREATE TABLE SQL_BOYS.Funcionalidad (
	id_funcionalidad INT IDENTITY(1, 1) PRIMARY KEY,
	nombre NVARCHAR(255) NOT NULL
)

CREATE TABLE SQL_BOYS.Rol (
	id_rol INT IDENTITY(1, 1) PRIMARY KEY,
	nombre NVARCHAR(255) NOT NULL,
	habilitadx BIT NOT NULL
)

CREATE TABLE SQL_BOYS.Funcionalidad_Por_Rol (
	id_funcionalidad INT FOREIGN KEY REFERENCES SQL_BOYS.Funcionalidad(id_funcionalidad) NOT NULL,
	id_rol INT FOREIGN KEY REFERENCES SQL_BOYS.Rol(id_rol) NOT NULL,
	CONSTRAINT id_funcionalidad_por_rol PRIMARY KEY(id_funcionalidad, id_rol)
)

CREATE TABLE SQL_BOYS.Usuario (
	id_usuario INT IDENTITY(1, 1) PRIMARY KEY,
	username NVARCHAR(255) UNIQUE NOT NULL,
	contrase�a NVARCHAR(255) NOT NULL,
	habilitadx BIT NOT NULL
)

CREATE TABLE SQL_BOYS.Sucursal (
	cp_sucursal NUMERIC(18, 0) PRIMARY KEY,
	nombre NVARCHAR(50) NOT NULL,
	domicilio NVARCHAR(50) NOT NULL,
	habilitadx BIT NOT NULL
)

CREATE TABLE SQL_BOYS.Rol_De_Usuario_Por_Sucursal (
	id_rol INT FOREIGN KEY REFERENCES SQL_BOYS.Rol(id_rol) NOT NULL,
	id_usuario INT FOREIGN KEY REFERENCES SQL_BOYS.Usuario(id_usuario) NOT NULL,
	cp_sucursal NUMERIC(18, 0) FOREIGN KEY REFERENCES SQL_BOYS.Sucursal(cp_sucursal) NOT NULL,
	CONSTRAINT id_rol_de_usuario_por_sucursal PRIMARY KEY(id_rol, id_usuario, cp_sucursal)
)

CREATE TABLE SQL_BOYS.Cliente (
	dni_cliente NUMERIC(18,0) PRIMARY KEY,
	nombre NVARCHAR(255) NOT NULL,
	apellido NVARCHAR(255) NOT NULL,
	nacimiento DATETIME NOT NULL,
	mail NVARCHAR(255) NOT NULL UNIQUE, 
	domicilio NVARCHAR(255) NOT NULL,
	codigo_postal NVARCHAR(255) NOT NULL,
	telefono INT NOT NULL,
	habilitadx BIT NOT NULL
)

CREATE TABLE SQL_BOYS.Rubro (
	id_rubro NUMERIC(18,0) IDENTITY(1, 1) PRIMARY KEY,
	descripcion NVARCHAR(50) NOT NULL 
)

CREATE TABLE SQL_BOYS.Empresa (
	id_empresa INT IDENTITY(1, 1) PRIMARY KEY,
	nombre NVARCHAR(255) NOT NULL,
	cuit NVARCHAR(50) NOT NULL UNIQUE,
	domicilio NVARCHAR(255) NOT NULL,
	dia_rendicion INT NOT NULL CHECK (dia_rendicion BETWEEN 1 AND 28),
	porcentaje_comision INT NOT NULL CHECK (porcentaje_comision BETWEEN 1 AND 100),
	habilitadx BIT NOT NULL,
	id_rubro NUMERIC(18,0) FOREIGN KEY REFERENCES SQL_BOYS.Rubro(id_rubro) NOT NULL
)

CREATE TABLE SQL_BOYS.Rendicion (
	numero_rendicion NUMERIC(18, 0) IDENTITY(1, 1) PRIMARY KEY,
	importe_comision NUMERIC(18,2) NOT NULL,
	fecha_rendicion DATETIME NOT NULL
)

CREATE TABLE SQL_BOYS.Factura (
	numero_factura NUMERIC(18, 0) PRIMARY KEY,
	factura_monto_total NUMERIC(18, 2) NOT NULL,
	factura_fecha_alta DATETIME NOT NULL,
	factura_fecha_vencimiento DATETIME NOT NULL,
	dni_cliente NUMERIC(18, 0) FOREIGN KEY REFERENCES SQL_BOYS.Cliente(dni_cliente) NOT NULL,
	id_empresa INT FOREIGN KEY REFERENCES SQL_BOYS.Empresa(id_empresa) NOT NULL,
	numero_rendicion NUMERIC(18, 0) FOREIGN KEY REFERENCES SQL_BOYS.Rendicion(numero_rendicion)
)

CREATE TABLE SQL_BOYS.Devolucion (
	id_devolucion INT IDENTITY(1, 1) PRIMARY KEY,
	fecha_devolucion DATETIME NOT NULL,
	motivo NVARCHAR(255) NOT NULL,
	numero_factura NUMERIC(18, 0) FOREIGN KEY REFERENCES SQL_BOYS.Factura(numero_factura)
)

CREATE TABLE SQL_BOYS.Medio_De_Pago (
	id_medio_de_pago INT IDENTITY(1, 1) PRIMARY KEY,
	descripcion nvarchar(50) NOT NULL
)

CREATE TABLE SQL_BOYS.Pago (
	numero_pago NUMERIC(18, 0) IDENTITY(1, 1) PRIMARY KEY,
	monto_total NUMERIC(18,2) NOT NULL,
	fecha_pago DATETIME NOT NULL,
	id_medio_de_pago INT FOREIGN KEY REFERENCES SQL_BOYS.Medio_De_Pago(id_medio_de_pago) NOT NULL,
	dni_cliente NUMERIC(18, 0) FOREIGN KEY REFERENCES SQL_BOYS.Cliente(dni_cliente) NOT NULL,
	cp_sucursal NUMERIC(18, 0) FOREIGN KEY REFERENCES SQL_BOYS.Sucursal(cp_sucursal) NOT NULL
)

CREATE TABLE SQL_BOYS.Item (
	id_item INT IDENTITY(1, 1) PRIMARY KEY,
	nombre NVARCHAR(255) NOT NULL,
	monto NUMERIC(18, 2) NOT NULL,
	cantidad INT NOT NULL,
	numero_factura NUMERIC(18, 0) FOREIGN KEY REFERENCES SQL_BOYS.Factura(numero_factura) NOT NULL
)

CREATE TABLE SQL_BOYS.Item_Pago (
	id_item INT FOREIGN KEY REFERENCES SQL_BOYS.Item(id_item) NOT NULL,
	numero_factura NUMERIC(18, 0) FOREIGN KEY REFERENCES SQL_BOYS.Factura(numero_factura) NOT NULL,
	numero_pago NUMERIC(18, 0) FOREIGN KEY REFERENCES SQL_BOYS.Pago(numero_pago) NOT NULL,
	CONSTRAINT id_item_pago PRIMARY KEY(id_item, numero_factura, numero_pago)
)

CREATE TABLE SQL_BOYS.Item_Rendicion (
	id_item INT FOREIGN KEY REFERENCES SQL_BOYS.Item(id_item) NOT NULL,
	numero_rendicion NUMERIC(18, 0) FOREIGN KEY REFERENCES SQL_BOYS.Rendicion(numero_rendicion) NOT NULL,
	CONSTRAINT id_item_rendicion PRIMARY KEY(id_item, numero_rendicion)
)