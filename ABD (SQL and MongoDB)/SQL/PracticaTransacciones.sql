CREATE SEQUENCE semaforo
INCREMENT BY 1
START WITH 0
MAXVALUE 1
MINVALUE 0
CYCLE
NOCACHE

---------------------------------------------------------------------------------------
create or replace 
PROCEDURE TRABAJANDO_T1 (segundos IN NUMBER) AS
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

----------------------------------------------------------------------------------------
create or replace 
PROCEDURE TRABAJANDO_T2 (segundos IN NUMBER) AS
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
---------------------------------------------------------------------------------------------
create or replace 
procedure probarMiT1 as
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
------------------------------------------------------------------------------------------------
create or replace 
procedure probarMiT2 as
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
--------------------------------------------------------------------------------------------

create or replace 
trigger inserto_compras
after insert on COMPRAS
for each row
declare
seq number;
BEGIN
select seq_log.nextval into seq from dual;
insert into logcompra values (seq, :new.dni, :new.numt, :new.numf, :new.fecha, :new.tienda, :new.importe);
END;