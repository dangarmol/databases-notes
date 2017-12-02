--------------------------------------------------------
-- Archivo creado  - jueves-abril-27-2017   
--------------------------------------------------------
-- No se ha podido presentar el DDL PROCEDURE para el objeto HECTOR.CURSOR3 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE HECTOR.cursor3 
as


--------  ======= SECCION Declaración Variables : si es un proc.,fun. o trigger
--      NO necesita poner "declare"

-- variables locales solo visibles dentro del procedimiento

      TDNICL CHAR(8) := '00000000'; -- sin valor tiene NULL por defecto
      TNombreCL CHAR(30);

      Tcoderror NUMBER;
      Ttexterror VARCHAR2(100);

  CURSOR cursor_ricos IS
      select dni, nombreC
      from cliente
      where dni in ( select dni from invierte
                     group by dni
                     having sum(cantidad) > 650000
                     )
      -- para actualizar una atrib. de tabla al recorrer el cursor añado:   
       FOR UPDATE OF nombreC NOWAIT;


      fila_rico cursor_ricos%ROWTYPE; -- variable de fila completa cursor_ricos
                                    -- se puede usar en el fetch
                                    -- no la usamos aquí, solo es un ejemplo

------- ======= SECCION  -- BEGIN sentencias procedimentales 
BEGIN

--- Abro cursor: el puntero se posiciona al principio
  OPEN cursor_ricos;

LOOP
  FETCH  cursor_ricos
    INTO TDNICL, TNombreCL;
  EXIT WHEN cursor_ricos%NOTFOUND; -- si el fetch no da ninguna fila

--            --> atencion  DBMS_output.put_line necesita "set serveroutput on"

--   Ejemplo de uso de IF
  IF TDNICL LIKE '%2' THEN
  DBMS_output.put_line('---- cursor3: sumando , DNI: '|| TDNICL);
      update invierte
          set cantidad = cantidad + 1
      where dni = TDNICL;
  END IF;
  IF TDNICL LIKE '%4' THEN
  DBMS_output.put_line('---- cursor3: restando , DNI: '|| TDNICL);
      update invierte
          set cantidad = cantidad - 1
      where dni = TDNICL;
  END IF;
END LOOP;

DBMS_output.put_line('--> cursor3: proceso acabado por EXIT loop');



--    EJEMPLO de BUCLE usando el FOR:
--        muestro todas las inversiones mayores de esa cantidad.
--    la variable invierte_rec es local al for y no se declara         


FOR invierte_rec in (select * from invierte
                      where cantidad > 300000)
 LOOP
     DBMS_output.put_line('-- buen inversor: ' || invierte_rec.dni || 
                         ' cantidad: ' ||  invierte_rec.cantidad  );
 END LOOP;

--- cierro cursor para volver a ponerlo en la fila primera 
IF cursor_ricos%ISOPEN 
   THEN  CLOSE cursor_ricos; 
END IF;

--- EJEMPLO de actualizar usando el cursor, FOR , CURRENT OF 

FOR r_ricos IN cursor_ricos 
 LOOP
  update cliente SET nombreC = RTRIM(nombreC) || ' es rico'
    WHERE CURRENT OF cursor_ricos;
 END LOOP;




------- SECCION --  EXCEPTION tratamiento de excepciones
--                  pueden ser automáticas de oracle o del usuario 

EXCEPTION
  WHEN NO_DATA_FOUND THEN
   DBMS_output.put_line('--> cursor3: proceso acabado por NODATAFOUND');
   IF cursor_ricos%ISOPEN 
     THEN  CLOSE cursor_ricos; 
   END IF;

  WHEN OTHERS THEN
	Tcoderror:= SQLCODE;
	Ttexterror:= SUBSTR(SQLERRM,1, 100);
  DBMS_output.put_line('--> cursor3: ERROR en DNI : '|| TDNICL );
  DBMS_output.put_line('--> cursor3: ERROR COD: '|| Tcoderror);
  DBMS_output.put_line('--> cursor3: ERROR texto: ' ||  Ttexterror );

------- SECCION -- END  Final del bloque,proc.,func. o trigger
END cursor3;
-- No se ha podido presentar el DDL PROCEDURE para el objeto HECTOR.DORMIR mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE HECTOR.dormir 
(lapsus IN number) -- lapsus es en segundos
AS
BEGIN
DBMS_LOCK.SLEEP (lapsus); -- es un subprogrma del paquete DBMS_LOCK
--- da error si no tiene permiso, desde DBA:
--- grant execute on sys.dbms_lock to HECTOR;
END;
-- No se ha podido presentar el DDL PROCEDURE para el objeto HECTOR.INSERTOCONSISTENTE mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE HECTOR.insertoConsistente 
(
DNI_p        invierte.DNI%TYPE,
NombreE_p    invierte.NombreE%TYPE,
Cantidad_p   invierte.Cantidad%TYPE,
Tipo_p       invierte.Tipo%TYPE
)  AS


/* ------ empiezo un bloque sin nombre para las pruebas -----------

DECLARE 

-- vars. de prueba que luego serán los parámetros del procedimiento

DNI_p        invierte.DNI%TYPE := '00000002';
NombreE_p    invierte.NombreE%TYPE := 'Empresa XX' ;
Cantidad_p   invierte.Cantidad%TYPE := 9999999;
Tipo_p       invierte.Tipo%TYPE := 'bono99';
--- SE comenta cuando funcionan todas los CASOS 
--- y se pone la definición del procedimeinto y las vars. de prueba se ponen como parámetros
------- */

-- vars de trabajo

Cantidad_old   invierte.Cantidad%TYPE;

es_tipo_nuevo int := 0;  -- tendra un 0 si el tipo es nuevo
es_empresa_nueva int := 0;    -- tendra un 0 si la empresa es nueva

-- Decido si es Tipo nuevo para ese cliente: si 0 es nuevo
Cursor c_tipo_nuevo IS
       select count(*)   -- 0 si no hay, 1 si hay una o más
       from dual
       where EXISTS ( select null from invierte 
                      where DNI= DNI_p and Tipo= Tipo_p );
 
-- Decido si es empresa nueva para ese cliente: si 0 es nuevo
Cursor c_empresa_nueva IS

       select count(*)   -- 0 si no hay, 1 si hay una o más
       from dual
       where EXISTS ( select null from invierte 
                      where DNI= DNI_p and NombreE= NombreE_p );


-- para excepcion 
      Tcoderror NUMBER;
      Ttexterror VARCHAR2(100);



BEGIN

--------- muestro los datos de entrada (parámetros) con los que trabajo

 DBMS_output.put_line('-------    Inversion: DNI: ' ||  DNI_p || ' NombreE_p:  ' || NombreE_p);
 DBMS_output.put_line('            Cantidad: ' || Cantidad_p ||   '  TIPO: ' || Tipo_p );
 DBMS_output.put_line('-------------------');

-- EN que CASO estoy?
       open  c_tipo_nuevo;
       fetch c_tipo_nuevo   into  es_tipo_nuevo;
       close  c_tipo_nuevo; 


       open  c_empresa_nueva;
       fetch c_empresa_nueva   into  es_empresa_nueva;
       close  c_empresa_nueva; 

-- imprimo en el caso que estamos
       DBMS_output.put_line('--- CASO: TIPO: ' ||   es_tipo_nuevo || '  NOMBREE ' || es_empresa_nueva );


-- CASO 1.-  Ya existe una fila con los dos Tipo (1) y Empresa (1) : es un error, no se lo permito 

 IF  es_tipo_nuevo = 1 and es_empresa_nueva = 1 THEN 
       DBMS_output.put_line('--- CASO: ya existe una inversión con ese cliente,empresa y tipo');
       DBMS_output.put_line('         está prohibido por la dependencia multivalorada');
ELSIF
   es_tipo_nuevo = 0 and es_empresa_nueva = 1 THEN 
-- CASO 2.-  tipo nuevo para una  Empresa que ya hay inversiones: debo insertar filas con ese tipo para todas sus empresas

    for cada_emp in
            (select distinct NombreE from invierte where DNI= DNI_p)
    LOOP
       insert into Invierte VALUES (DNI_p, cada_emp.NombreE, Cantidad_p, Tipo_p );
    -- Imprimo cada fila nueva
        DBMS_output.put_line('====== Inversion NUEVA para: DNI: ' ||  DNI_p || ' NombreE_p:  ' || cada_emp.NombreE);
        DBMS_output.put_line('            Cantidad: ' || Cantidad_p ||   '  TIPO: ' || Tipo_p );
        DBMS_output.put_line('======='); 
    END LOOP;

ELSIF
   es_tipo_nuevo = 1 and es_empresa_nueva = 0 THEN 
-- CASO 3.- EMpresa nueva para un tipo que ya hay inversiones: debo insertar filas con ese empresa para todos sus tipos
 
    -- AVISO: Invierto la cantidad original en DB, en el caso de que sea distinta a la inverion actual
    select cantidad into Cantidad_old
    from invierte
    where DNI = DNI_p and Tipo =Tipo_p;
    IF Cantidad_old <> Cantidad_P  THEN
               DBMS_output.put_line('Cantidad nueva: ' || Cantidad_p ||   '  diferente de la irginal en DB' || Cantidad_old );
                DBMS_output.put_line(' >>>>> invertiré la original' ); 
    END IF;
    
    for cada_tipo in
            (select distinct Tipo, Cantidad from invierte where DNI= DNI_p)
    LOOP
       insert into Invierte VALUES (DNI_p, NombreE_p, cada_tipo.Cantidad, cada_tipo.Tipo );
    -- Imprimo cada fila nueva
        DBMS_output.put_line('====== Inversion NUEVA para: DNI: ' ||  DNI_p || ' NombreE_p:  ' || NombreE_p);
        DBMS_output.put_line('            Cantidad: ' || cada_tipo.Cantidad ||   '  TIPO: ' || cada_tipo.Tipo);
        DBMS_output.put_line('=======');
     END LOOP;

ELSIF
   es_tipo_nuevo = 0 and es_empresa_nueva = 0 THEN 
-- 4.- El tipo y la empresa son nuevos: insert la fila y termino: no tengo obligaciones de crear otras filas

       insert into Invierte VALUES (DNI_p, NombreE_p, Cantidad_p, Tipo_p );
--- imprimo la fila nueva
       DBMS_output.put_line('====== Inversion NUEVA para: DNI: ' ||  DNI_p || ' NombreE_p:  ' || NombreE_p);
       DBMS_output.put_line('            Cantidad: ' || Cantidad_p ||   '  TIPO: ' || Tipo_p);
       DBMS_output.put_line('=======');

 
      
END IF;    




EXCEPTION

  WHEN OTHERS THEN
	Tcoderror:= SQLCODE;
	Ttexterror:= SUBSTR(SQLERRM,1, 100);


END;
-- No se ha podido presentar el DDL PROCEDURE para el objeto HECTOR.PEDIDOS_CLIENTE mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE HECTOR.PEDIDOS_CLIENTE 
(DNI CLIENTES.DNI%TYPE) AS
  CURSOR CURSORPEDIDOS IS
		SELECT CODIGO,
			   TO_CHAR(FECHA_HORA_PEDIDO, 'DD-MM-YYYY HH24:MI')  AS FECHA,
			   TO_CHAR(FECHA_HORA_ENTREGA, 'DD-MM-YYYY HH24:MI') AS FECHAENTREGA,
			   ESTADO, IMPORTE_TOTAL
		FROM PEDIDOS
		WHERE CLIENTE = DNI
		ORDER BY FECHA_HORA_PEDIDO DESC;
	
	DATOS_CLIENTE VARCHAR(300);
	SUMA_PEDIDOS PEDIDOS.IMPORTE_TOTAL%TYPE;
	SIN_PEDIDOS EXCEPTION;
BEGIN
	DBMS_OUTPUT.PUT_LINE('*************************************************************');
	
	SELECT 'DNI: ' || DNI || ', Nombre: ' || TRIM(NOMBRE) || ', Apellidos: '
                                   || TRIM(APELLIDO) INTO DATOS_CLIENTE
	FROM CLIENTES
	WHERE DNI = PEDIDOS_CLIENTE.DNI;
	
	DBMS_OUTPUT.PUT_LINE(DATOS_CLIENTE);
  DBMS_OUTPUT.PUT_LINE('*******************************************************************');
    	
	FOR PEDIDO IN CURSORPEDIDOS LOOP
		DBMS_OUTPUT.PUT_LINE('Codigo: ' || PEDIDO.CODIGO ||', Fecha: ' || PEDIDO.FECHA ||
                 ', Fecha entrega: ' || PEDIDO.FECHAENTREGA || chr(13) || '    Estado: ' || 
                 TRIM(PEDIDO.ESTADO) || ', Importe total: ' || PEDIDO.IMPORTE_TOTAL);
                 
    IF SUMA_PEDIDOS IS NULL THEN 
       SUMA_PEDIDOS := PEDIDO.IMPORTE_TOTAL;
    ELSE 
       SUMA_PEDIDOS := SUMA_PEDIDOS + PEDIDO.IMPORTE_TOTAL;
    END IF;
    
	END LOOP;

DBMS_OUTPUT.PUT_LINE('*******************************************************************');
		
/*	SELECT SUM(IMPORTE_TOTAL) INTO SUMA_PEDIDOS
	FROM PEDIDOS
	WHERE CLIENTE = DNI;*/
	
	IF SUMA_PEDIDOS IS NULL THEN
		RAISE SIN_PEDIDOS;
	END IF;
	
	DBMS_OUTPUT.PUT_LINE('Suma de importes de todos los pedidos realizados: ' || SUMA_PEDIDOS);
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			DBMS_OUTPUT.PUT_LINE('El cliente ' || DNI || ' no existe');
		WHEN SIN_PEDIDOS THEN
			DBMS_OUTPUT.PUT_LINE('El cliente ' || DNI || ' no ha hecho pedidos');
END;
-- No se ha podido presentar el DDL PROCEDURE para el objeto HECTOR.PONE_LINEA_AUTONOMA mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE HECTOR.pone_linea_autonoma 
(milinea IN varchar)
  as
-- vars de trabajo
 numeroT varchar(50);
 valor_secuencia INT;
 old_valor_secuencia INT := -2;
 
--- en origen: milinea varchar(100) :=  ' ';
 
 -- Hacemos transacción autónoma 
 PRAGMA AUTONOMOUS_TRANSACTION;
 
BEGIN 

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    NAME 'Trans-Principal';

SELECT dbms_transaction.local_transaction_id into numeroT
 FROM dual ;

DBMS_OUTPUT.PUT_LINE(milinea || ' Num.Trans.Secun: ' || numeroT);

commit;  -- termina transacción, es obligatorio

end pone_linea_autonoma;
-- No se ha podido presentar el DDL PROCEDURE para el objeto HECTOR.PROC3 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE HECTOR.proc3 
(
	dnibusca cliente.DNI%TYPE, -- el tipo del atributo de tabla cliente
	NombreCL   cliente.NombreC%TYPE, -- el modo por defecto es "IN"
	DirCL      cliente.Direccion%TYPE
        -- si fuera un tipo como CHAR(10), solo se pone CHAR
      ) as    -- también se usa "IS"

-- variable solo visible dentro del procedimiento

-- vars de trabajo
      TDNICL CHAR(8);
      TNombreCL CHAR(30);

      Tcoderror NUMBER;
      Ttexterror VARCHAR2(100);
-- vars para leer datos
	
-- excepción del usuario
	cliente_listillo EXCEPTION;

BEGIN

-- la SELECT necesita variables para almacenar el resultado.
-- Si no devuelve nada o devuelve varias filas: salta una excepcion

  SELECT DNI, NombreC
    INTO TDNICL, TNombreCL  -- es OBLIGATORIO tener el INTO 
    FROM Cliente
    WHERE DNI = dnibusca;

DBMS_OUTPUT.PUT_LINE('selecciona cliente: ' || TDNICL);

IF TDNICL = '00000005' THEN
      DBMS_OUTPUT.PUT_LINE('Activa EXCEPCION cliente_listillo: ' || TDNICL);
      RAISE cliente_listillo;
   ELSE
      TDNICL := 'PROC3: -- ELSE ';
   END IF;

-------------- instrucciones DML de SQL y PL/SQL --------
-- quiero poner todos los clientes en morosos
-- pero debo evitar incluir los que ya estaban

insert into moroso
  select * from cliente where dni not in (select dni from moroso);
 

-- quiero poner todos los clientes en morosos
insert into moroso
  select * from cliente where dni not in (select dni from moroso);

-- quiero quitar de moroso aquellos clientes que están en cliente
-- porque son buenos clientes (excepto el 3 para probar después)

delete from moroso 
where moroso.dni IN (select dni from cliente)
    and moroso.dni <> '00000003';

-- Quiero poner a 'basura' el tipo de bono en las inversiones
--  de los morosos cuya cantidad es menor de 320000 euros

update invierte 
  set Tipo = 'basura'
where invierte.dni in (select dni from moroso)
   and cantidad < 320000;
    




EXCEPTION
  WHEN NO_DATA_FOUND THEN   -- automática: tiene un código y un texto largo 
	Tcoderror:= SQLCODE;
	Ttexterror:= SUBSTR(SQLERRM,1, 100);
  DBMS_OUTPUT.PUT_LINE( Tcoderror || ' -- ' || Ttexterror);
	insert into cliente values (dnibusca,NombreCL,DirCL);

  WHEN cliente_listillo THEN   -- del usuario o programador
	Tcoderror:= SQLCODE;
	Ttexterror:= '----- PROC3: CLIENTE PELIGROSO ------';
  DBMS_OUTPUT.PUT_LINE( Tcoderror || ' -- ' || Ttexterror);

  WHEN OTHERS THEN       -- en cualquier otro caso 
	Tcoderror:= SQLCODE;
	Ttexterror:= SUBSTR(SQLERRM,1, 100);

END proc3;
-- No se ha podido presentar el DDL PROCEDURE para el objeto HECTOR.PROC3PLUS2 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE HECTOR.proc3plus2 
(
	dnibusca cliente.DNI%TYPE, 
	NombreCL   cliente.NombreC%TYPE,
	DirCL      cliente.Direccion%TYPE
      ) as

-- variable solo visible dentro del procedimiento

-- vars de trabajo
      TDNICL CHAR(8);
      TNombreCL CHAR(30);

      Tcoderror NUMBER;
      Ttexterror VARCHAR2(100);
-- vars para leer datos
	


BEGIN

  DBMS_output.put_line('--- proc3plus, begin '|| dnibusca);
  update cliente 
       set NombreC = NombreCL  
  WHERE DNI = dnibusca;


 IF SQL%NOTFOUND THEN
  DBMS_output.put_line('--- proc3plus, no encuentra '|| dnibusca);
	insert into cliente 
		values (dnibusca,NombreCL,DirCL);
  END IF;
TDNICL := dnibusca;
IF TDNICL = '00000005' THEN
      DBMS_output.put_line('--- proc3plus, en el IF: '|| TDNICL);
   ELSE
      TDNICL := ':ELSE ';
      DBMS_output.put_line('--- proc3plus, otro cliente: '|| TDNICL);
   END IF;

END proc3plus2;
-- No se ha podido presentar el DDL PROCEDURE para el objeto HECTOR.REVISA_PRECIO_CON_COMISION mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE HECTOR.revisa_precio_con_comision 
IS 
-- vars de trabajo
    datos_contiene contiene%ROWTYPE;
    datos_plato platos%ROWTYPE;
    datos_restaurante restaurantes%ROWTYPE;
 
    calculo_precio_comision  NUMBER(8,2);
    nombre_plato_V CHAR(25);
    comision_rest_V NUMBER(8,2);
    precio_plato_V NUMBER(8,2);
    nFilas NUMBER;
    exito NUMBER ;

 -- cursor para los platos que hay en contiene      
 CURSOR cursor_contiene
      is  SELECT * FROM contiene;
        
 -- cursor para los precios de los platos 
 CURSOR cursor_platos is  select * from platos;
      
 -- cursor para la comision que tienen los restaurantes   
  CURSOR cursor_restaurante is  select * from restaurantes; 
  
BEGIN
  dbms_output.put_line('---- proc revisa_precio_con_comision----');
  nFilas := 0;
  OPEN cursor_contiene;
     
      LOOP
           FETCH cursor_contiene
           into datos_contiene;
           exit  when cursor_contiene%NOTFOUND;
          
          --BUSCAMOS PRECIO DEL PLATO
          OPEN cursor_platos;
     
                LOOP
                     FETCH cursor_platos
                     into datos_plato;
                     exit  when cursor_platos%NOTFOUND or (
                     datos_plato.nombrePlato = datos_contiene.plato and 
                     datos_plato.restaurante = datos_contiene.restaurante
                     ) ;
                END LOOP;
                precio_plato_V := datos_plato.precio;
                
          IF cursor_platos%ISOPEN
              THEN CLOSE  cursor_platos;
          END IF;
          
          --BUSCAMOS COMISION DEL RESTAURANTE
          OPEN cursor_restaurante;
          
                LOOP
                     FETCH cursor_restaurante
                     into datos_restaurante;
                     exit  when cursor_restaurante%NOTFOUND or 
                           datos_restaurante.codigo = datos_contiene.restaurante;
                     
                END LOOP;
                comision_rest_V := datos_restaurante.comision;
                
          IF cursor_restaurante%ISOPEN
              THEN CLOSE  cursor_restaurante;
          END IF;
          
          calculo_precio_comision := precio_plato_V + (comision_rest_V/100 *precio_plato_V);

          IF datos_contiene.precio_con_comision <> calculo_precio_comision or comision_rest_V is NULL
              THEN  
                    --ACTUALIZAMOS TABLA CONTIENE
                     update contiene
                     set precio_con_comision = calculo_precio_comision
                     where restaurante = datos_contiene.restaurante and plato = datos_contiene.plato and pedido = datos_contiene.pedido;
                    
                    --GUARDAMOS PLATO
                    exito := guardaPlato(datos_contiene );
                    nFilas := nFilas + 1;
  
                    IF exito <> 0 THEN
                      DBMS_output.put_line('Error al guardar el plato.');
                    END IF;
          END IF;
      END LOOP;
      
  IF cursor_contiene%ISOPEN
      THEN CLOSE  cursor_contiene;
  END IF;
  
  IF nFilas = 0 THEN 
   DBMS_output.put_line('Ningun cambio en los datos de la tabla contiene.');
  ELSE 
   DBMS_output.put_line('Numero de filas modificadas :' || nFilas);
  END IF;
END revisa_precio_con_comision;
-- No se ha podido presentar el DDL PROCEDURE para el objeto HECTOR.TRAB_T_1_LINEA_AUTONOMA mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE HECTOR.trab_T_1_linea_autonoma 
(lapsus IN number)
  as
-- vars de trabajo
 numeroT varchar(50);
 valor_secuencia INT;
 old_valor_secuencia INT := -2;
 
 milinea varchar(100) :=  ' ';
 
BEGIN 

SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    NAME 'Trans-Principal-nueva';

SELECT dbms_transaction.local_transaction_id into numeroT
 FROM dual ;

DBMS_OUTPUT.PUT_LINE(' Trans. Principal Empieza: ' || numeroT);

  LOOP
   SELECT  sec_trans_1.NEXTVAL into valor_secuencia
    FROM dual ; 
   IF  valor_secuencia =  old_valor_secuencia THEN exit;
   ELSE
   old_valor_secuencia := valor_secuencia;   
    hector.dormir(5); -- en segundos   
   END IF;
   
   milinea := ' se ha dormido -> ' || ' antes:  '|| 
        old_valor_secuencia || ' despues: ' || valor_secuencia;
 --- para ver la línea cada vez que pasa por aquí       
        pone_linea_autonoma (milinea);

  END LOOP;
  
SELECT dbms_transaction.local_transaction_id into numeroT
 FROM dual ;

DBMS_OUTPUT.PUT_LINE(' Trans. Principal TERMINA: ' || numeroT);
 
end trab_T_1_linea_autonoma;
-- No se ha podido presentar el DDL PROCEDURE para el objeto HECTOR.TRABAJANDO_TRANS_1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE HECTOR.trabajando_trans_1 
(lapsus IN number)
  as
-- vars de trabajo
 numeroT varchar(50);
 valor_secuencia INT;
 old_valor_secuencia INT := -2;
 
BEGIN 

  LOOP
   SELECT  sec_trans_1.NEXTVAL into valor_secuencia
    FROM dual ; 
   IF  valor_secuencia =  old_valor_secuencia THEN exit;
   ELSE
   old_valor_secuencia := valor_secuencia;
   
    hector.dormir(5); -- en segundos   
   END IF;
  END LOOP;
  
SELECT dbms_transaction.local_transaction_id into numeroT
 FROM dual ;
DBMS_OUTPUT.PUT_LINE(' se ha dormido -> ' || numeroT || ' antes:  '|| 
old_valor_secuencia || ' despues: ' || valor_secuencia);
end trabajando_trans_1;
