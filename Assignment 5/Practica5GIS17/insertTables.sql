--PRODUCTO (CÓDIGO, DESCRIPCIÓN, PRECIO, ALMACÉN)
insert into producto values('83-26-4338-3445', 'El principito', 70, 'ES_021');
insert into producto values('1123342', 'Lavadora Bosch', 695, 'ES_026');
insert into producto values('234523199', 'Vestido vintage moderno', 20, 'DE_005');

--LIBROS (ISBN)
insert into libros values('83-26-4338-3445');

--HOGAR (MARCA, MODELO, CÓDIGO_IDENTIFICADOR)
insert into hogar values('Bosch', 'Lavaplus', '1123342');

--TEXTIL (COLOR, TALLA, MODELO, CÓDIGO_IDENTIFICADOR)
insert into textil values('Blanco', 'S', 'Vestido Vintage', '234523199');

--ASOCIADO (CODIGO_TEXTIL, IDENTIFICADOR_FOTO)
insert into asociado values('234523199', '001');

--FOTOGRAFÍA (ID, DESCRIPCIÓN)
insert into fotografia values('001', 'Vestido por delante');

--ALMACEN (NOMBRE, LATITUD, LONGITUD, CÓDIGO_ALMACÉN)
insert into almacen values('Villaverde', '86º 22" 50N', '47º 54" 14W', 'ES_021');
insert into almacen values('Vistalegre', '84º 56" 40N', '43º 74" 22W', 'ES_026');
insert into almacen values('Dieter Bahnhof Inc', '25º 42" 30N', '46º 21" 84W', 'DE_005');

--USUARIO (NOMBRE, APELLIDO, CORREO, FECHA, NICKNAME, REFERIDO*, NUMERO_REFERIDOS, CREDITO_BONO)
insert into usuario values('Lance', 'Fergusson', 'lancef04@gmail.com', '02/05/2016', 'LFERGUS', NULL, 1, 10);
insert into usuario values('Megan', 'Williams', 'meganw23@gmail.com', '08/05/2016', 'MWILLIAMS', 'LFERGUS', 0, 0);

--DIRECCION (CÓDIGO_POSTAL, DIRECCIÓN, POBLACIÓN, LONGITUD, LATITUD, NICKNAME)
insert into direccion values('28026', 'Paseo de la Castellana, 22, 2ºA', 'Madrid', '42º 66" 13N', '14º 65" 75W', 'LFERGUS');
insert into direccion values('28099', 'Calle de Atocha, 122, 3ºC', 'Madrid', '41º 65" 14N', '12º 45" 65W', 'MWILLIAMS');

--PALABRAS_CLAVE (PALABRA)
insert into palabras_clave values('Vestido');
insert into palabras_clave values('Blanco');
insert into palabras_clave values('Cultura');
insert into palabras_clave values('Lectura');
insert into palabras_clave values('Electrodomestico');

--CONTIENE (CÓDIGO_PRODUCTO, PALABRA)
insert into contiene values('1123342', 'Electrodomestico');
insert into contiene values('234523199', 'Vestido');
insert into contiene values('234523199', 'Blanco');
insert into contiene values('83-26-4338-3445', 'Cultura');
insert into contiene values('83-26-4338-3445', 'Lectura');

--ESTA_EN (CODIGO_PRODUCTO, CODIGO_ALMACEN, STOCK)
insert into esta_en values('83-26-4338-3445', 'ES_021', 4);
insert into esta_en values('1123342', 'ES_026', 3);
insert into esta_en values('234523199', 'DE_005', 26);

--BUSQUEDA (NICKNAME, PALABRA, FECHA_HORA)
insert into busqueda values('LFERGUS', 'Zapatos', 'Elegantes', '06/06/2016 21:22:23');
insert into busqueda values('MWILLIAMS', 'Libros', 'Cocina', '09/05/2016 12:15:48');

--COMPRA (PRODUCTO, DIRECCIÓN, COMENTARIO*, VALORACIÓN*, UNIDADES, GASTOS_ENVIO, NICKNAME, FECHA_HORA)
insert into compra values('83-26-4338-3445', 'Paseo de la Castellana, 22, 2ºA', 'Muy buen servicio', '10/10', 1, 2.25, 'LFERGUS', '05/06/2016');
insert into compra values('1123342', 'Calle de Atocha, 122, 3ºC', NULL, '8/10', 2, 1.50, 'MWILLIAMS', '08/06/2016');