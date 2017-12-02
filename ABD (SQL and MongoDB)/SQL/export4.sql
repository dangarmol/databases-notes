--------------------------------------------------------
-- Archivo creado  - jueves-abril-27-2017   
--------------------------------------------------------
-- No se ha podido presentar el DDL PROCEDURE para el objeto ABD0309.ACTUALIZATOTALIMPORTE mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE ABD0309.actualizaTotalImporte 
(dniE in comprasacumuladas.dni%type, importeE in comprasacumuladas.totalcompra%type) as

existe number;

begin
select count(dni) into existe
from comprasAcumuladas ca
where dniE=ca.dni;

if( existe > 0) then
update comprasAcumuladas
set totalcompra = totalcompra + importeE
where dni = dniE;
else
insert into comprasacumuladas values(dniE, importeE);
end if;
end;
-- No se ha podido presentar el DDL PROCEDURE para el objeto ABD0309.CREA_SEC_INVERSION mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE ABD0309.CREA_SEC_INVERSION 
(NOMBREEMPRESA IN EMPRESA.NOMBREE%TYPE) AS
existe NUMBER;
plsql_block VARCHAR(500);
BEGIN
SELECT COUNT(*) INTO existe FROM USER_OBJECTS WHERE OBJECT_NAME='SEC_' || NOMBREEMPRESA;

IF existe = 0 THEN
  plsql_block:='CREATE SEQUENCE SEC_' || NOMBREEMPRESA;
  EXECUTE IMMEDIATE plsql_block;
END IF;

END;
-- No se ha podido presentar el DDL PROCEDURE para el objeto ABD0309.CREA_TABLA_INVERSIONES mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE ABD0309.CREA_TABLA_INVERSIONES 
(NOMBREEMPRESA IN EMPRESA.NOMBREE%TYPE) AS
existe NUMBER;
plsql_block VARCHAR(500);
BEGIN
SELECT COUNT(*) INTO existe FROM TABS WHERE TABLE_NAME='INVERSIONES_' || NOMBREEMPRESA;
IF existe = 0 THEN
  plsql_block:='CREATE TABLE INVERSIONES_' || NOMBREEMPRESA || ' (DNI VARCHAR(8), CANTIDAD FLOAT, TIPO VARCHAR(20), NUMSEC NUMBER, PRIMARY KEY(NUMSEC))';
  EXECUTE IMMEDIATE plsql_block;
END IF;

END;
-- No se ha podido presentar el DDL PROCEDURE para el objeto ABD0309.DORMIR mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE ABD0309.dormir 
(lapsus IN number) -- lapsus es en segundos
AS
BEGIN
DBMS_LOCK.SLEEP (lapsus); -- es un subprogrma del paquete DBMS_LOCK
-- da error si no tiene permiso, desde DBA:
-- grant execute on sys.dbms_lock to HECTOR;
END;
-- No se ha podido presentar el DDL PROCEDURE para el objeto ABD0309.GESTION_INVERSION mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE ABD0309.GESTION_INVERSION 
(DNINEW INVIERTE.DNI%TYPE, NOMBREEMPRESA EMPRESA.NOMBREE%TYPE, CANTIDADNEW INVIERTE.CANTIDAD%TYPE, TIPONEW INVIERTE.TIPO%TYPE) AS
plsql_block VARCHAR(500);
plsql_block2 VARCHAR(500);
sec NUMBER := 8;
BEGIN
CREA_SEC_INVERSION(NOMBREEMPRESA);
CREA_TABLA_INVERSIONES(NOMBREEMPRESA);
dbms_output.put_line(NOMBREEMPRESA);
plsql_block2:='SELECT SEC_' || NOMBREEMPRESA || ' INTO sec FROM DUAL;';
EXECUTE IMMEDIATE plsql_block2;
--plsql_block := 'INSERT INTO INVERSIONES_' || NOMBREEMPRESA || 'VALUES (:a, :b, :c, :d);';
--EXECUTE IMMEDIATE plsql_block USING IN DNINEW, CANTIDADNEW, TIPONEW, sec;
--dbms_output.put_line('Insertado en la tabla invierte_' || NOMBREEMPRESA || ' valores: ' || DNINEW || ' ' || TIPONEW || ' ' || CANTIDADNEW);
END;
-- No se ha podido presentar el DDL PROCEDURE para el objeto ABD0309.INSERTOCONSISTENTE mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE ABD0309.INSERTOCONSISTENTE 
(V_INVIERTE INVIERTE%ROWTYPE)
IS

DNI_ENC NUMBER;
EMP_ENC NUMBER;
AUX NUMBER;
TT INVIERTE.TIPO%TYPE;
--CURSOR TIPOSE IS SELECT UNIQUE TIPO FROM INVIERTE WHERE DNI = V_INVIERTE.DNI;
--CURSOR TIPOSE IS SELECT UNIQUE DNI FROM CLIENTE WHERE DNI = V_INVIERTE.DNI;

BEGIN
/*SELECT COUNT(*) INTO DNI_ENC FROM CLIENTE WHERE DNI = V_INVIERTE.DNI;
  IF DNI_ENC > 0 THEN 
    SELECT COUNT(*) INTO EMP_ENC FROM EMPRESA WHERE NOMBREE = V_INVIERTE.NOMBREE;
    IF EMP_ENC > 0 THEN 
      --INSERT INTO INVIERTE VALUES (V_INVIERTE.DNI, V_INVIERTE.NOMBREE, V_INVIERTE.CANTIDAD, V_INVIERTE.TIPO);
      SELECT COUNT(*) INTO AUX FROM INVIERTE WHERE NOMBREE = V_INVIERTE.NOMBREE;
      IF AUX = 0 THEN*/
        --FOR TIPOEMPRESA IN (SELECT UNIQUE TIPO FROM INVIERTE WHERE DNI = V_INVIERTE.DNI)
       -- LOOP
       -- dmbs_output.put_line('rrr es: ' || TIPOEMPRESA);
        --INSERT INTO INVIERTE VALUES (V_INVIERTE.DNI, V_INVIERTE.NOMBREE, V_INVIERTE.CANTIDAD, 3);
       -- END LOOP;
       FOR TIPOEMPRESA IN (SELECT UNIQUE INVIERTE.TIPO FROM INVIERTE WHERE INVIERTE.DNI = V_INVIERTE.DNI)
       LOOP
       dmbs_output.put_line('rrr es: ' || TIPOEMPRESA);
       END LOOP;
      /*END IF;
    ELSE dbms_output.put_line('No se ha encontrado la empresa');
    END IF;
  ELSE dbms_output.put_line('No se ha encontrado el cliente');
  END IF;*/
END;
-- No se ha podido presentar el DDL PROCEDURE para el objeto ABD0309.PONE_LINEA_AUTONOMA mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE ABD0309.pone_linea_autonoma 
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
-- No se ha podido presentar el DDL PROCEDURE para el objeto ABD0309.PRAC22_D mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE ABD0309.PRAC22_D 
AS

CONTADOR NUMBER DEFAULT 0;
TOT NUMBER DEFAULT 0;
FIJA NUMBER DEFAULT 10000;
IDD varchar(15);

BEGIN
  LOOP
    EXIT WHEN TOT > 50000;
    CONTADOR:=CONTADOR + 1;
    TOT:= FIJA * CONTADOR;
    INSERT INTO Compras VALUES ('00000005', '50000400',1, 0501,'tienda1',10000);
    ACTUALIZATOTALIMPORTE('00000005', 10000);
  END LOOP;
  SELECT dbms_transaction.local_transaction_id into idd FROM dual;
  DBMS_output.put_line(idd);
  ROLLBACK;
  SELECT dbms_transaction.local_transaction_id into idd FROM dual;
  DBMS_output.put_line(idd);
END;
-- No se ha podido presentar el DDL PROCEDURE para el objeto ABD0309.PRAC22_E mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE ABD0309.PRAC22_E 
AS

CONTADOR NUMBER DEFAULT 0;
TOT NUMBER DEFAULT 0;
FIJA NUMBER DEFAULT 10000;
IDD number;

BEGIN
 INSERT INTO Compras VALUES ('00000005', '50000400',1, 0501,'tienda1',10000);
 SAVEPOINT CH_PUNTO1;
 ACTUALIZATOTALIMPORTE('00000005', 10000);
 SELECT dbms_transaction.local_transaction_id into idd FROM dual;
  DBMS_output.put_line(idd);
  ROLLBACK TO SAVEPOINT CH_PUNTO1;
  SELECT dbms_transaction.local_transaction_id into idd FROM dual;
  DBMS_output.put_line(idd);
  COMMIT;
  SELECT TOTALCOMPRA INTO TOT FROM COMPRASACUMULADAS WHERE DNI = '00000005';
  DBMS_output.put_line(TOT);
  
END;
-- No se ha podido presentar el DDL PROCEDURE para el objeto ABD0309.PROBARMIT1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE ABD0309.probarMiT1 
as
begin
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
INSERT INTO Compras VALUES ('00000005', '50000500',1, 0521,'tienda4',50);
INSERT INTO Compras VALUES ('00000005', '50000600',1, 0501,'tienda5',5);
INSERT INTO Compras VALUES ('00000005', '50000700',2, 0502,'tienda6',500);
trabajando_t1(5);
INSERT INTO Compras VALUES ('00000005', '50000505',1, 0521,'tienda7',50);
INSERT INTO Compras VALUES ('00000005', '50000605',1, 0501,'tienda8',5);
INSERT INTO Compras VALUES ('00000005', '50000705',2, 0502,'tienda9',500);
trabajando_t1(5);
end;
-- No se ha podido presentar el DDL PROCEDURE para el objeto ABD0309.PROBARMIT2 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE ABD0309.probarMiT2 
as
begin
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
INSERT INTO Compras VALUES ('00000005', '50000550',1, 0521,'tienda40',50);
INSERT INTO Compras VALUES ('00000005', '50000650',1, 0501,'tienda50',5);
INSERT INTO Compras VALUES ('00000005', '50000750',2, 0502,'tienda60',500);
trabajando_t2(5);
INSERT INTO Compras VALUES ('00000005', '50000555',1, 0521,'tienda70',50);
INSERT INTO Compras VALUES ('00000005', '50000655',1, 0501,'tienda80',5);
INSERT INTO Compras VALUES ('00000005', '50000755',2, 0502,'tienda90',500);
trabajando_t2(5);
end;
-- No se ha podido presentar el DDL PROCEDURE para el objeto ABD0309.TRAB_T_1_LINEA_AUTONOMA mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE ABD0309.trab_T_1_linea_autonoma 
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
-- No se ha podido presentar el DDL PROCEDURE para el objeto ABD0309.TRABAJANDO_T1 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE ABD0309.TRABAJANDO_T1 
(segundos IN NUMBER) AS
salir number;
aux number;
aux1 number;
begin
loop
select seq_t1.nextval into aux from dual;
hector.dormir(segundos);
DBMS_OUTPUT.PUT_LINE('se ha dormido -> ' || segundos || ' segundos');
select seq_t1.nextval into salir from dual;
select seq_t1.nextval into aux1 from dual;
if salir = aux then exit;
end if;
end loop;
DBMS_OUTPUT.PUT_LINE('He terminado de trabajar');
end;
-- No se ha podido presentar el DDL PROCEDURE para el objeto ABD0309.TRABAJANDO_T2 mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE PROCEDURE ABD0309.TRABAJANDO_T2 
(segundos IN NUMBER) AS
salir number;
aux number;
aux1 number;
begin
loop
select seq_t2.nextval into aux from dual;
hector.dormir(segundos);
DBMS_OUTPUT.PUT_LINE('se ha dormido -> ' || segundos || ' segundos');
select seq_t2.nextval into salir from dual;
select seq_t2.nextval into aux1 from dual;
if salir = aux then exit;
end if;
end loop;
DBMS_OUTPUT.PUT_LINE('He terminado de trabajar');
end;
