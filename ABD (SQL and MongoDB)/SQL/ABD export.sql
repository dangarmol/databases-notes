ABD0310
create or replace 
PROCEDURE CREA_SEC_INVERSION(NOMBREE IN VARCHAR2)
IS
NUM INT;
BEGIN
SELECT COUNT(*) INTO NUM FROM USER_OBJECTS WHERE OBJECT_NAME = 'SEC_' || NOMBREE;
IF NUM = 0 THEN
  execute immediate 'create sequence SEC_' || NOMBREE || ' start with 1 increment by 1 nomaxvalue NOCACHE NOCYCLE';
END IF;
END;

create or replace 
PROCEDURE CREA_TABLA_INVERSIONES(NOMBREE IN VARCHAR2)
IS
NUM INT;
BEGIN
SELECT COUNT(*) INTO NUM FROM TABS WHERE TABLE_NAME = 'INVERSIONES_' || NOMBREE;
IF NUM = 0 THEN
  execute immediate 'create TABLE INVERSIONES_' || NOMBREE || ' (
DNI		CHAR(8)  not null, 
NombreE	CHAR(20) not null,
Cantidad	FLOAT,
Tipo		CHAR(10) not null,
NUMSEQ INT
)';
END IF;
END;

create or replace 
PROCEDURE GESTION_INVERSION(DNIp VARCHAR2, NombreEp	VARCHAR2, Cantidadp FLOAT, Tipop VARCHAR2)
AS
plsql_block VARCHAR2 (2000);
numSec integer;
BEGIN
  plsql_block := 'SEC_' || NombreEp || '.NEXTVAL';
  crea_sec_inversion(NombreEp);
  crea_tabla_inversiones(NombreEp);
  select plsql_block into numSec from dual;
  execute immediate 'insert into INVERSIONES_' || NombreEp || ' values('||DNIp||', '||NombreEp||', '||CantidadP||', '||Tipop||', numSec)';
END;


ABD0119

create or replace 
procedure crea_sec_inversion (
  nombreEmp varchar) as
  
  contSeq integer;
  nombreSeq varchar(30):= 'SEC_'||nombreEmp ;
  
  begin 
   select count(*) into contSeq from user_objects where object_name = 'SEC_'||nombreEmp;
  
  if contSeq = 0 then
  execute immediate 'create sequence ' ||nombreSeq|| ' start with 1 increment by 1';
  end if ;
  end;
  
  create or replace 
procedure crea_tabla_inversiones(
  nombreEmp varchar) as
  
  cont integer;
 -- nombreTable varchar(30) := 'INVERSIONES_'||nombreEmp;
  
  begin
   select count(*) into cont from tabs where table_name = 'INVERSIONES_'||nombreEmp;
  
  if cont = 0 then
  execute immediate 'create table INVERSIONES_' ||nombreEmp|| '(
  DNI VARCHAR(8),
  NOMBRE VARCHAR (20),
  CANTIDAD FLOAT,
  TIPO VARCHAR(10),
  NUMSEC int,
  primary key(dni, tipo)
  )';
  end if;
  end;
  
  create or replace 
PROCEDURE inserta_fila_inversiones(
  nombreEmp VARCHAR,
  dniN VARCHAR,
  nombreN VARCHAR,
  cantidadN FLOAT,
  tipoN VARCHAR) as
  
   nombreSec VARCHAR(30):= '''SEC_' || nombreEmp || '''';
   nombreTabla varchar(30):= 'INVERSIONES_'||nombreEmp;
   
  
  begin
  crea_sec_inversion(nombreEmp);
  crea_tabla_inversiones(nombreEmp);  
 
  EXECUTE IMMEDIATE '
  declare numsec number;
  BEGIN 
   select SEC_' || nombreEmp ||'.nexval into numsec from user_objects where object_name = ' || nombreSec || ';
   insert into ' || nombreTabla || ' values (:b, :c, :d, :e, numsec); END;' 
  USING IN dniN, nombreN, cantidadN, tipoN;
  
  commit;
END inserta_fila_inversiones;

ABD0323

create or replace 
PROCEDURE CREA_SEC_INVERSION (NomEmpresa EMPRESA.NOMBREE%TYPE) AS 

INDICADOR INTEGER;
SQL_STATEMENT VARCHAR(500);

BEGIN

INDICADOR := 0;

    SELECT COUNT (*) INTO INDICADOR
    From User_Objects
    WHERE UPPER(OBJECT_NAME) LIKE 'SEC_'||NomEmpresa;

    IF INDICADOR = 0 THEN SQL_STATEMENT := 'CREATE SEQUENCE SEC_' || NomEmpresa || ' 
        MINVALUE 1
        START WITH 1
        INCREMENT BY 1
        CACHE 20';
        
    EXECUTE IMMEDIATE SQL_STATEMENT;
        
     END IF;

END CREA_SEC_INVERSION;

create or replace 
PROCEDURE CREA_TABLA_INVERSIONES(NomEmpresa EMPRESA.NOMBREE%TYPE) AS 

INDICADOR NUMBER;
SQL_STATEMENT VARCHAR(500);

--PRAGMA AUTONOMOUS_TRANSACTION;

BEGIN

    SELECT COUNT (*) INTO INDICADOR
    From TABS
    WHERE UPPER(TABLE_NAME) LIKE 'INVERSIONES_'||NomEmpresa;
    
    IF INDICADOR = 0 THEN
    
    SQL_STATEMENT := 'CREATE TABLE INVERSIONES_' || NomEmpresa || ' (
        DNI CHAR(9),
        NOMBRE CHAR(20),	
        CANTIDAD FLOAT,	
        TIPO CHAR(10),
        NUMSEC NUMBER(8)
        )';
        
    EXECUTE IMMEDIATE SQL_STATEMENT;
    
     ELSE
      DBMS_output.put_line('YA EXISTE LA TABLA ' || NomEmpresa);
     END IF;
END CREA_TABLA_INVERSIONES;

create or replace 
PROCEDURE Gestion_inversion(fila invierte%rowtype) as

consulta varchar(200);
nom varchar(50);

BEGIN

  nom := REPLACE(UPPER(fila.nombree), ' ', '');
  
  crea_sec_inversion(nom);
  crea_tabla_inversiones(nom);
  
  consulta := 'insert into inversiones_' || nom ||' values (''' || fila.dni|| ''', '''
              || nom ||''', ''' || fila.cantidad ||''', ''' || fila.tipo || ''', sec_' || nom || '.nextval)'; 
            
  EXECUTE IMMEDIATE consulta;

END;