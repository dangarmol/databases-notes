create table producto
(
	CODIGO_UNICO varchar(40) primary key,
	PRECIO_UNITARIO varchar(6) is not null,
	DESCRIPCION varchar(30) is not null
);

create table libros
(
	ISBN varchar(40) primary key,
	foreign key (ISBN) references producto(CODIGO_UNICO)
);
 
create table hogar
(
	CODIGO_IDENTIFICADOR varchar(40) primary key,
	MARCA varchar(10) is not null,
	MODELO varchar(10) is not null,
	foreign key (CODIGO_IDENTIFICADOR) references producto(CODIGO_UNICO)
);

create table textil
(
	CODIGO_IDENTIFICADOR varchar(40) primary key,
	FORMA varchar(10) is not null,
	TALLA varchar(4) is not null,
	COLOR varchar(10) is not null,
	foreign key (CODIGO_IDENTIFICADOR) references producto(CODIGO_UNICO)
);

create table fotografia
(
	ID_FOTO varchar(10) primary key,
	DESCRIPCION varchar(50) is not null
);
  
create table almacen
(
	CODIGO_ALMACEN varchar(4) primary key,
	NOMBRE varchar(10) is not null,
	LATITUD varchar(10) is not null,
	LONGITUD varchar(10) is not null
);

create table usuario
(
	NICKNAME varchar(10) primary key,
	NOMBRE varchar(10) is not null,
	APELLIDO varchar(10) is not null,
	FECHA_ALTA varchar(10) is not null,
	CREDITO_BONO varchar(10),
	NUMERO_REFERIDOS varchar(10),
	NICK_REFERIDO varchar(10),
	CORREO varchar(30) is not null	
);
 
create table direccion
(
	NICKNAME varchar(10) is not null,
	POBLACION varchar(10) is not null,
	DIRECCION varchar(10) is not null,
	CODIGO_POSTAL varchar(10) is not null,
	LONGITUD varchar(10) is not null,
	LATITUD varchar(10) is not null,
	primary key (DIRECCION, POBLACION, CODIGO_POSTAL, NICKNAME),
	foreign key (NICKNAME) references usuario(NICKNAME)
);
 
create table palabra_clave
(
	PALABRA varchar(40) primary key
);
 
create table esta_en
(
	CODIGO_PRODUCTO varchar(10),
	CODIGO_ALMACEN varchar(10), 
	STOCK varchar(10) is not null,
	primary key(CODIGO_PRODUCTO, CODIGO_ALMACEN),
	foreign key (CODIGO_PRODUCTO) references producto(CODIGO_UNICO),
	foreign key (CODIGO_ALMACEN) references almacen(CODIGO_ALMACEN)
);

create table contiene
(
	PALABRA_CLAVE varchar(4),
	CODIGO_PRODUCTO varchar(4),
	primary key (PALABRA_CLAVE, CODIGO_PRODUCTO),
	foreign key (PALABRA_CLAVE) references palabra_clave(PALABRA),
	foreign key (CODIGO_PRODUCTO) references producto(CODIGO_UNICO)
);
 
 
create table busqueda
(
	NICK_USUARIO varchar(10),
	CODIGO_PRODUCTO varchar(10),
	PALABRA_CLAVE varchar(10),
	FECHA_HORA varchar(10) is not null,
	primary key (NICK_USUARIO, CODIGO_PRODUCTO, PALABRA_CLAVE),
	foreign key (NICK_USUARIO) references usuario(NICKNAME),
	foreign key (CODIGO_PRODUCTO) references producto(CODIGO_UNICO),
	foreign key (PALABRA_CLAVE) references palabra_clave(PALABRA)
);
 
create table asociado
(
	CODIGO_TEXTIL varchar(10),
	IDENTIFICADOR_FOTO varchar(20),
	primary key (CODIGO_TEXTIL, IDENTIFICADOR_FOTO),
	foreign key (CODIGO_TEXTIL) references textil(CODIGO_IDENTIFICADOR),
	foreign key (IDENTIFICADOR_FOTO) references fotografia(ID_FOTO)
);
  
create table compra
(
	NICK_USUARIO varchar(10) is not null,
	PRODUCTO varchar(10) is not null,
	FECHA varchar(10),
	DIRECCION varchar(10) is not null,
	GASTOS_ENVIO varchar(10),
	UNIDADES varchar(10) is not null,
	COMENTARIO varchar(10) is not null,
	VALORACION varchar(10) is not null,
	primary key (NICK_USUARIO, PRODUCTO, FECHA, UNIDADES),
	foreign key (NICK_USUARIO) references usuario(NICKNAME),
	foreign key (PRODUCTO) references producto(CODIGO_UNICO),
	foreign key (DIRECCION) references direccion(DIRECCION)	
);