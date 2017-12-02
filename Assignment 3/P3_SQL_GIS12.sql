--DANIEL GARC�A MOLERO y MARIO RODR�GUEZ SALINERO.

--1. Listado los nombres de los productos que tengan �HD� en el nombre ordenados
--alfab�ticamente por nombre.
SELECT product_name
FROM PRODUCT_INFORMATION
WHERE product_name
LIKE '%HD%'
ORDER BY product_name
--25 filas

--2. Listado de pedidos en los que aparecen productos obsoletos. Lista los identificadores y el
--nombre del producto. Debes usar reuniones para obtener el listado.
SELECT DISTINCT ORDERS.order_id, PRODUCT_INFORMATION.product_name
FROM ORDERS, ORDER_ITEMS, PRODUCT_INFORMATION
WHERE product_status = 'obsolete'
AND ORDERS.order_id = ORDER_ITEMS.order_id
AND ORDER_ITEMS.product_id = PRODUCT_INFORMATION.product_id
--21 filas

--3. Listado de aquellos productos que tengan un nombre diferente del nombre traducido. Lista
--ambos nombres que se encuentran en las tablas product_information y product_descriptions.
--Usa una reuni�n natural para ello.
SELECT DISTINCT PRODUCT_INFORMATION.product_name, PRODUCT_DESCRIPTIONS.translated_name
FROM PRODUCT_INFORMATION, PRODUCT_DESCRIPTIONS
WHERE PRODUCT_INFORMATION.product_name <> PRODUCT_DESCRIPTIONS.translated_name
AND PRODUCT_DESCRIPTIONS.product_id = PRODUCT_INFORMATION.product_id
--12 filas

--4. Listado de las localizaciones de los departamentos de la empresa (identificador del pa�s,
--ciudad, identificador de la localizaci�n y nombre del departamento, en este orden) en la que
--se encuentra alg�n departamento, incluyendo aquellas localizaciones en las que no hay
--departamento. El listado debe estar ordenado por el identificador de la localizaci�n.
SELECT DISTINCT LOCATIONS.country_id, LOCATIONS.city, LOCATIONS.location_id, DEPARTMENTS.department_name
FROM DEPARTMENTS, LOCATIONS
WHERE DEPARTMENTS.location_id = LOCATIONS.location_id
ORDER BY LOCATIONS.location_id
--27 filas

--5. Listado de las localizaciones de los departamentos y los almacenes de la empresa
--(identificador del pa�s, ciudad, identificador de la localizaci�n, nombre del departamento y
--del almac�n, en este orden) de la empresa en la que se encuentra alg�n departamento o alg�n
--almac�n, sin incluir aquellas localizaciones en las que no hay ninguno de ellos. El listado
--debe estar ordenado por el c�digo del pa�s descendente y el nombre de la ciudad (ascendente).
SELECT DISTINCT LOCATIONS.country_id, LOCATIONS.city, LOCATIONS.location_id, DEPARTMENTS.department_name, WAREHOUSES.warehouse_name
FROM LOCATIONS, DEPARTMENTS, WAREHOUSES
WHERE DEPARTMENTS.location_id = LOCATIONS.location_id OR WAREHOUSES.location_id = LOCATIONS.location_id
ORDER BY LOCATIONS.country_id DESC, LOCATIONS.city ASC
--PENDIENTE

--6. Listado de las localizaciones de los departamentos y los almacenes de la empresa
--(identificador del pa�s, ciudad, identificador de la localizaci�n, nombre del departamento y
--del almac�n, en este orden) de la empresa en la que se encuentra alg�n departamento o alg�n
--almac�n, incluyendo aquellas localizaciones en las que no hay ninguno de ellos. El listado
--debe estar ordenado por el c�digo del pa�s descendente y el nombre de la ciudad (ascendente).
SELECT DISTINCT LOCATIONS.country_id, LOCATIONS.city, LOCATIONS.location_id, DEPARTMENTS.department_name, WAREHOUSES.warehouse_name
FROM LOCATIONS, DEPARTMENTS, WAREHOUSES
WHERE DEPARTMENTS.location_id = LOCATIONS.location_id OR WAREHOUSES.location_id = LOCATIONS.location_id
ORDER BY LOCATIONS.country_id DESC, LOCATIONS.city ASC
--PENDIENTE

--7. Elabora un listado (sin repeticiones) con los nombres completos de los clientes de la empresa
--que hayan hecho alg�n pedido junto con el nombre completo del empleado que gestiona su
--cuenta (atributo account_mgr_id). Muestra en el listado primero el nombre del empleado y
--luego el nombre del cliente, y haz que el listado se encuentre ordenado por apellido y nombre,
--primero del empleado y luego del cliente. Usa reuniones para ello.
SELECT DISTINCT EMPLOYEES.first_name, EMPLOYEES.last_name, CUSTOMERS.cust_first_name, CUSTOMERS.cust_last_name
FROM EMPLOYEES, CUSTOMERS, ORDERS
WHERE CUSTOMERS.account_mgr_id = EMPLOYEES.employee_id AND CUSTOMERS.customer_id = ORDERS.customer_id
ORDER BY EMPLOYEES.last_name, EMPLOYEES.first_name, CUSTOMERS.cust_last_name, CUSTOMERS.cust_first_name
--37 filas

--8. Listado de categor�as con m�s de 4 productos obsoletos. Lista la categor�a y el n�mero de
--productos obsoletos.
SELECT DISTINCT PRODUCT_INFORMATION.category_id, COUNT(*)
FROM PRODUCT_INFORMATION
WHERE PRODUCT_INFORMATION.product_status = 'obsolete'
GROUP BY PRODUCT_INFORMATION.category_id
HAVING COUNT(*) > 4
--1 fila

--9. Listado los pedidos que contienen alg�n producto obsoleto. El listado debe incluir el
--identificador del pedido y el nombre del producto y estar ordenado primero por el
--identificador y luego por el nombre.
SELECT DISTINCT ORDER_ITEMS.order_id, PRODUCT_INFORMATION.product_name
FROM ORDER_ITEMS, PRODUCT_INFORMATION
WHERE PRODUCT_INFORMATION.product_id = ORDER_ITEMS.product_id AND PRODUCT_INFORMATION.product_status = 'obsolete'
ORDER BY ORDER_ITEMS.order_id, PRODUCT_INFORMATION.product_name
--21 filas

--10. Listado de pedidos en los que aparecen m�s de dos productos obsoletos. El listado debe
--incluir el identificador del pedido y el n�mero de productos obsoletos que inclu�a dicho
--pedido.


--11. Se quiere generar un �ranking� de los productos m�s vendidos en el a�o 2000. Para ello nos
--piden mostrar el nombre de producto y el n�mero de unidades vendidas para cada producto
--vendido en el a�o 2000 (ordenado por n�mero de unidades vendidas de forma descendente).


--12. Muestra los puestos en la empresa que tienen un salario m�nimo superior al salario medio de
--los empleados de la compa��a. El listado debe incluir el puesto y su salario m�nimo, y estar
--ordenado por salario m�nimo.


--13. Mostrar el c�digo, nombre y precio m�nimo de productos que no aparecen en ning�n pedido.
--Usa para ello una subconsulta no correlacionada.


--14. Recuerda el �ranking� de productos m�s vendidos en el a�o 2000 que elaboraste en una
--consulta anterior. Muestra el producto m�s vendido de dicho ranking y el n�mero de unidades
--vendidas. Para ello necesitar�s usar subconsultas.


--15. Elabora un listado con los puestos de la compa��a cuyo salario medio es superior al salario
--medio de los empleados de la compa��a. El listado debe incluir tambi�n el n�mero de
--empleados que ejercen cada puesto y debe estar ordenado de forma descendente seg�n el
--salario medio del puesto.


--16. Mostrar el c�digo de cliente, nombre, apellidos y nacionalidad de aquellos clientes que no
--han realizado ning�n pedido. Usa para ello una consulta correlacionada.


--17. Mostrar el c�digo de cliente, nombre, apellidos y n�mero de pedidos de aquellos clientes que
--han realizado alg�n pedido en el a�o 2000. Ordenar los resultados por n�mero de pedidos.
SELECT DISTINCT
FROM CUSTOMERS, ORDERS
WHERE ORDERS.order_date LIKE '%/00'

--18. Mostrar el c�digo de cliente, nombre, apellidos y nacionalidad de aquellos clientes (sin
--repetici�n) que han realizado al menos un pedido de tipo (order_mode) �online� y otro
--�direct�.


--19. Mostrar el c�digo de cliente, nombre, apellidos y direcci�n de correo-e de aquellos clientes
--que, habiendo realizado alg�n pedido, nunca han realizado pedidos de tipo �online�.


--20. Se pretende lanzar una nueva campa�a de fidelizaci�n de clientes. Para ello se quiere regalar
--el producto m�s barato (distinto de 0) de cada pedido, siempre y cuando el importe a facturar
--resulte positivo. Generar un listado de pedidos con el precio total del pedido sin el descuento
--y el precio final que se le facturar� al cliente (precio total del pedido � importe del producto
--m�s barato). Por ejemplo, si el producto que se va a descontar tiene precio unitario 100� y
--se han pedido 3 unidades, se descontar�n 300�. En el listado tambi�n debe aparecer el nombre
--del cliente, el correo electr�nico y el descuento aplicado, el cual debe ser una cantidad
--positiva.


--21. Se quiere generar un listado de los productos que generan mayor beneficio. Mostrar el c�digo
--de producto, su precio m�nimo, su precio de venta al p�blico y el porcentaje de incremento
--de precio y c�digo de pedido. En el listado deben aparecer solo aquellos cuyo precio de venta
--al p�blico ha superado en un 20 % al precio m�nimo (min_price).


--22. Mostrar el nombre y apellido de los empleados que ganen un 35% m�s del salario medio de
--su puesto. El listado debe incluir el salario del empleado y su puesto.
