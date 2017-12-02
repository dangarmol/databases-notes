create or replace 
PROCEDURE trabajando_trans_1 (lapsus IN number)
  as
-- vars de trabajo
 numeroT varchar(50);
 valor_secuencia INT;
 old_valor_secuencia INT := -2;
 
BEGIN 

  LOOP
   SELECT  sec_trans_1.NEXTVAL into valor_secuencia
    FROM dual ; 
   IF  valor_secuencia =  old_valor_secuencia THEN exit;
   ELSE
   old_valor_secuencia := valor_secuencia;
   
    hector.dormir(5); -- en segundos   
   END IF;
  END LOOP;
  
SELECT dbms_transaction.local_transaction_id into numeroT
 FROM dual ;
DBMS_OUTPUT.PUT_LINE('se ha dormido ->' || numeroT || 'antes:  '|| 
old_valor_secuencia || 'despues: ' || valor_secuencia);
end trabajando_trans_1;


/*   
------- PREPARAR

--------- cada vez que empecemos 
set serveroutput on
set autocommit off
                       
SET TRANSACTION ISOLATION LEVEL READ COMMITTED 
    NAME 'TuTro';

SELECT dbms_transaction.local_transaction_id -- into numeroT
 FROM dual ; 

-------- solo cuando queramos empezar en cero
                                    
drop sequence  sec_trans_1;

CREATE SEQUENCE sec_trans_1
 START WITH 0 INCREMENT BY 1 minvalue 0 MAXVALUE 1 CYCLE NOCACHE;

commit;

------ la primera vez que te refieres en esta sesión



------ PROBAR 


begin
  trabajando_trans_1 (5);
end;

- - SIgue hasta que en otra session:

  SELECT  sec_trans_1.NEXTVAL    FROM dual ;    



*/