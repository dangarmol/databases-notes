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