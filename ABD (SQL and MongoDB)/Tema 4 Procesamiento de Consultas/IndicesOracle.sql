Diapositiva 39 tema 4:
CLIENTE(numCli, nomCli, dirCli, país)
ARTICULO(numArt, descr, precio)

1.-
SELECT *
FROM CLIENTE
WHERE UPPER(nomCli)='PEPITO S.A.';

2.-
SELECT *
FROM CLIENTE
WHERE nomCli IS NULL;
//O bien...
WHERE nomCli = 'miValorNull'

3.-
SELECT *
FROM CLIENTE
WHERE numCli != 1000;

4.-
SELECT *
FROM CLIENTE
WHERE nomCli LIKE '%EPITO';