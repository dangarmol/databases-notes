--------------------------------------------------------
-- Archivo creado  - jueves-abril-27-2017   
--------------------------------------------------------
-- No se ha podido presentar el DDL VIEW para el objeto HECTOR.MISMOROSOS mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE VIEW HECTOR.MISMOROSOS AS select CL.DNI "clienteDNI", CL.NOMBREC
from cliente CL
where EXISTS (select dni from moroso where moroso.dni = CL.dni) WITH READ ONLY
-- No se ha podido presentar el DDL VIEW para el objeto HECTOR.MOROSOSMODFICABLES mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE VIEW HECTOR.MOROSOSMODFICABLES AS select CL.DNI , CL.NOMBREC
from cliente CL
where EXISTS (select dni from moroso where moroso.dni = CL.dni) WITH CHECK OPTION
-- No se ha podido presentar el DDL VIEW para el objeto HECTOR.TUSMOROSOS mientras que DBMS_METADATA intenta utilizar el generador interno.
CREATE VIEW HECTOR.TUSMOROSOS AS select CL.DNI , CL.NOMBREC
from cliente CL
where EXISTS (select dni from moroso where moroso.dni = CL.dni) WITH CHECK OPTION
REM INSERTING into HECTOR.MISMOROSOS
SET DEFINE OFF;
Insert into HECTOR.MISMOROSOS (DNI,NOMBREC) values ('00000003','Client B                      ');
Insert into HECTOR.MISMOROSOS (DNI,NOMBREC) values ('00000005','Client A                      ');
Insert into HECTOR.MISMOROSOS (DNI,NOMBREC) values ('00000006','Client D                      ');
REM INSERTING into HECTOR.MOROSOSMODFICABLES
SET DEFINE OFF;
Insert into HECTOR.MOROSOSMODFICABLES (DNI,NOMBREC) values ('00000003','Client B                      ');
Insert into HECTOR.MOROSOSMODFICABLES (DNI,NOMBREC) values ('00000005','Client A                      ');
Insert into HECTOR.MOROSOSMODFICABLES (DNI,NOMBREC) values ('00000006','Client D                      ');
REM INSERTING into HECTOR.TUSMOROSOS
SET DEFINE OFF;
Insert into HECTOR.TUSMOROSOS (DNI,NOMBREC) values ('00000003','Client B                      ');
Insert into HECTOR.TUSMOROSOS (DNI,NOMBREC) values ('00000005','Client A                      ');
Insert into HECTOR.TUSMOROSOS (DNI,NOMBREC) values ('00000006','Client D                      ');
