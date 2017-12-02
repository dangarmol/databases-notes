--------------------------------------------------------
-- Archivo creado  - jueves-abril-27-2017   
--------------------------------------------------------
-- No se ha podido presentar el DDL TRIGGER para el objeto ABD0309.INSERTO_COMPRAS mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE trigger ABD0309.inserto_compras after insert on COMPRAS
for each row
declare
seq number;
BEGIN
select seq_log.nextval into seq from dual;
insert into logcompra values (seq, :new.dni, :new.numt, :new.numf, :new.fecha, :new.tienda, :new.importe);
END;
