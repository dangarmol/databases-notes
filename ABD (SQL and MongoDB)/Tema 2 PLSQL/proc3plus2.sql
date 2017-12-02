CREATE  OR REPLACE PROCEDURE proc3plus2 (
	dnibusca cliente.DNI%TYPE, 
	NombreCL   cliente.NombreC%TYPE,
	TelCL 	cliente.Telefono%TYPE ,
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
		values (dnibusca,NombreCL,DirCL,TelCL);
  END IF;
TDNICL := dnibusca;
IF TDNICL = '00000005' THEN
      DBMS_output.put_line('--- proc3plus, en el IF: '|| TDNICL);
   ELSE
      TDNICL := ':ELSE ';
      DBMS_output.put_line('--- proc3plus, otro cliente: '|| TDNICL);
   END IF;

END proc3plus2;

/

show errors

---------- para ejecutarlo en SQL*PLUS -----------------
--   begin
--     proc3plus('00000005','nombre 5 nuevo', '5550055','dir 5 nueva');
--   end;
