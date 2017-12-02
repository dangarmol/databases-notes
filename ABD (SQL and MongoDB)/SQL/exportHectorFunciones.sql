--------------------------------------------------------
-- Archivo creado  - jueves-abril-27-2017   
--------------------------------------------------------
-- No se ha podido presentar el DDL FUNCTION para el objeto HECTOR.CREATRAZAPLATOS mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE FUNCTION HECTOR.creaTrazaPlatos 
return NUMBER 
  AS
  
     existe_ya NUMERIC;  
 
    Tcoderror NUMBER;
    Ttexterror VARCHAR2(100);

  
BEGIN

-- Si no existe la tabla "trazaplatos", la crea igual que tabla "contiene"

select count(table_name) into existe_ya from tabs where table_name ='TRAZAPLATOS';

-- DBMS_OUTPUT.PUT_LINE( 'existe si es 1: ' || existe_ya);

IF existe_ya = 0 THEN -- si no existe la tabla, la crea 
   execute immediate 'create table TRAZAPLATOS as select * from CONTIENE where 1=0';
END IF;

return 0;
 
 EXCEPTION
    WHEN OTHERS THEN
    	Tcoderror:= SQLCODE;
    	Ttexterror:= SUBSTR(SQLERRM,1, 100);
      DBMS_OUTPUT.PUT_LINE('--, ERROR '|| Tcoderror || ' -- ' || Ttexterror);

      return 1;
      
      
END;
-- No se ha podido presentar el DDL FUNCTION para el objeto HECTOR.GUARDAPLATO mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE FUNCTION HECTOR.guardaPlato 
(plato contiene%ROWTYPE)
    return NUMBER 
  AS
  
 existe_ya VARCHAR2(30);  
  
BEGIN

-- Funcion CREATRAZAPLATOS: Si no existe la tabla "trazaplatos", la crea igual que "contiene"

IF (CREATRAZAPLATOS = 0) THEN
   INSERT INTO trazaplatos VALUES plato;
   return 0;
ELSE
   return 1;
END IF;
  
EXCEPTION
      WHEN OTHERS THEN
      return 1;
  END;
