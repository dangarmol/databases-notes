--Examen Junio 2014-2015 BD
--d)
SELECT idComp, nombreC, COUNT(*)
FROM COMPETICION JOIN PARTICIPA USING (idComp)
GROUP BY idComp, nombreC --Al poner dos parámetros aquí se agrupan uno dentro de otro, para que luego lo puedas mostrar arriba
HAVING COUNT(*) >= ALL(SELECT COUNT(*) --Usas having porque estás comparando dentro del grupo creado
                       FROM PARTICIPA  --Además compara con todos, por lo que sólo la cogerá si no hay ninguna mayor
                       GROUP BY idComp)
                       
--e)
SELECT nom, apell, COUNT(*), pais 
FROM (PATINADOR NATURAL JOIN PARTICIPA)J --Natural join quita atributos duplicados
WHERE PATINADOR.sexo = 'Mujer' AND NOT EXIST (SELECT *
                                              FROM PARTICIPA P2
                                              WHERE P2.idComp = J.idComp AND P2.clasif > J.clasif)
GROUP BY PARTICIPA.dni
HAVING COUNT(*) >= 10