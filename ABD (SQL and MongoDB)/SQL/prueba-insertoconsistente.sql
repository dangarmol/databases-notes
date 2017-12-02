-------------  SCRIPT AUTOCONTENIDO PARA PROBAR TODOS LOS CASOS  -----------

DROP TABLE Invierte CASCADE CONSTRAINTS;

create table Invierte (
DNI		CHAR(8)  not null, 
NombreE	CHAR(20) not null,
Cantidad	FLOAT,
Tipo		CHAR(10) not null
);


REM ...             Invierte: I(DNI, NombreE,Cantidad,Tipo)

INSERT INTO Invierte VALUES ('00000002', 'Empresa 55',210000, 'bono1');
INSERT INTO Invierte VALUES ('00000002', 'Empresa 55',220000, 'bono2');
INSERT INTO Invierte VALUES ('00000002', 'Empresa 55',230000, 'bono3');
INSERT INTO Invierte VALUES ('00000002', 'Empresa 44',240000, 'bono4');
INSERT INTO Invierte VALUES ('00000003', 'Empresa 55',310000, 'bono1');
INSERT INTO Invierte VALUES ('00000003', 'Empresa 33',320000, 'bono2');
INSERT INTO Invierte VALUES ('00000004', 'Empresa 22',410000, 'bono1');
INSERT INTO Invierte VALUES ('00000004', 'Empresa 22',420000, 'bono2');



BEGIN

-- CASO 1 --
DBMS_output.put_line('    %%%%%%%%% Prueba   CASO  1   %%%%%%%%%%%%%%     ');
insertoConsistente('00000002', 'Empresa 55',210000, 'bono1');
-- CASO 2 --
DBMS_output.put_line('    %%%%%%%%% Prueba   CASO  2   %%%%%%%%%%%%%%     ');
insertoConsistente('00000002', 'Empresa 55',222222, 'bonoC-2');
-- CASO 3 --
DBMS_output.put_line('    %%%%%%%%% Prueba   CASO  3   %%%%%%%%%%%%%%     ');
insertoConsistente('00000002', 'Empresa 11',3333333, 'bono1');
-- CASO 4 --
DBMS_output.put_line('    %%%%%%%%% Prueba   CASO  4   %%%%%%%%%%%%%%     ');
insertoConsistente('00000002', 'Empresa XX',9999999, 'bono99');

END;
