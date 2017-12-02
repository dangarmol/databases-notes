CREATE  OR REPLACE PROCEDURE proc3 (
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
	

	cliente_listillo EXCEPTION;

BEGIN

  SELECT DNI, NombreC
    INTO TDNICL, TNombreCL 
    FROM Cliente
    WHERE DNI = dnibusca;

IF TDNICL = '00000005' THEN
      RAISE cliente_listillo;
   ELSE
      TDNICL := 'PROC3: -- ELSE ';
   END IF;

EXCEPTION
  WHEN NO_DATA_FOUND THEN
	Tcoderror:= SQLCODE;
	Ttexterror:= SUBSTR(SQLERRM,1, 100);

	insert into cliente values (dnibusca,NombreCL,DirCL,TelCL);

  WHEN cliente_listillo THEN
	Tcoderror:= SQLCODE;
	Ttexterror:= '----- PROC3: CLIENTE PELIGROSO ------';


  WHEN OTHERS THEN
	Tcoderror:= SQLCODE;
	Ttexterror:= SUBSTR(SQLERRM,1, 100);

END proc3;

/

show errors

---------- para ejecutarlo en SQL*PLUS -----------------
--   begin
--     proc3('00000005','nombre 5 nuevo', '5550055','dir 5 nueva');
--   end;
