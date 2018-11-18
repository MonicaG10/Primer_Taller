/*1. Crear una vista llamada “MEDIOS_PAGO_CLIENTES” que contenga las siguientes columnas:          
CLIENTE_ID, NOMBRE_CLIENTE (Si tiene el nombre y el apellido separados en columnas, deberán             
estar unidas en una sola), MEDIO_PAGO_ID, TIPO (TDC, Android, Paypal, Efectivo),           
DETALLES_MEDIO_PAGO, EMPRESARIAL (FALSO o VERDADERO), NOMBRE_EMPRESA 
(Si la columna Empresarial es falso, este campo aparecerá Nulo) ?(0.25) */


CREATE OR REPLACE VIEW MEDIOS_PAGO_CLIENTES AS
SELECT A.ID AS CLIENTE_ID,concat(A.NOMBRES ,A.APELLIDOS) AS NOMBRE_CLIENTE
,B.ID AS MEDIO_PAGO_ID, B.METODOS_PAGOS AS TIPO,
B.VALOR AS DETALLE_MEDIO_PAGO,
CASE A.TIPO_CLIENTE 
    WHEN 'EMPRESA' THEN 'VERDADERO'
    ELSE 'FALSO' END  AS EMPRESARIAL, 
CASE A.TIPO_CLIENTE 
    WHEN 'EMPRESA' THEN concat(A.NOMBRES ,A.APELLIDOS)
    ELSE null END  AS NOMBRE_EMPRESA 
FROM CLIENTES A 
INNER JOIN METODOS_PAGOS B ON A.ID=B.cliente_id ;


/*2. Cree una vista que permita listar los viajes de cada cliente ordenados cronológicamente. El nombre               
de la vista será “VIAJES_CLIENTES”, los campos que tendrá son: FECHA_VIAJE,           
NOMBRE_CONDUCTOR, PLACA_VEHICULO, NOMBRE_CLIENTE, VALOR_TOTAL,    
TARIFA_DINAMICA (FALSO O VERDADERO), TIPO_SERVICIO (UberX o UberBlack),CIUDAD_VIAJE. ?(0.25) */

CREATE OR REPLACE VIEW VIAJES_CLIENTES as 
SELECT 
A.FECHA_INICIO_RECORRIDO AS FECHA_VIAJE, concat(B.NOMBRES ,B.APELLIDOS) AS NOMBRE_CONDUCTOR,
C.PLACA AS PLACA_VEHICULO, concat(D.NOMBRES ,D.APELLIDOS) AS NOMBRE_CLIENTE, E.VALOR_FACTURA AS VALOR_TOTAL,
CASE G.CONCEPTO 
WHEN 'COSTO_RECARGO' THEN 'VERDADERO'
ELSE 'FALSO' END  AS TARIFA_DINAMICA, 
C.VEHICULO AS TIPO_SERVICIO,
H.DESCRIPCION AS CIUDAD_VIAJE
FROM SERVICIOS A 
INNER JOIN CONDUCTORES B ON A.CONDUCTOR_ID= B.ID 
INNER JOIN VEHICULOS C ON A.VEHICULO_ID=C.ID 
INNER JOIN CLIENTES D ON A.CLIENTE_ID=D.ID 
INNER JOIN FACTURAS E ON A.ID=E.SERVICIO_ID 
INNER JOIN DETALLE_FACTURAS G ON E.ID=G.FACTURA_ID
INNER JOIN CIUDADES H ON A.CIUDAD_ID=H.ID
ORDER BY FECHA_INICIO_RECORRIDO
;
/*3. Cree y evidencie el plan de ejecución de la vista VIAJES_CLIENTES. Cree al menos un índice donde                 
mejore el rendimiento del query y muestre el nuevo plan de ejecución. ?(0.25) 
*/

EXPLAIN PLAN SET STATEMENT_ID = 'EXPLAIN_PLAN_VIAJES_CLIENTES' FOR
SELECT * FROM VIAJES_CLIENTES;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY); 


/*5. Crear una función llamada VALOR_DISTANCIA que reciba la distancia en kilómetros y el nombre de              
la ciudad donde se hizo el servicio. Con esta información deberá buscar el valor por cada kilómetro                 
dependiendo de la ciudad donde esté ubicado el viaje. Deberá retornar el resultado de multiplicar la               
distancia recorrida y el valor de cada kilómetro dependiendo de la ciudad. Si la distancia es menor a 0                   
kilómetros o la ciudad no es válida deberá levantar una excepción propia. Ejemplo: Viaje_ID: 342 que                
fue hecho en Medellín y la distancia fue 20.68km. En este caso deberá retornar 20.68 * 764.525994 =15810.3976. ?(0.25) */

CREATE OR REPLACE FUNCTION VALOR_DISTANCIA (DIS_KILOMETRO NUMBER, CIUDAD VARCHAR) 
RETURN NUMBER
IS
VALOR_KILOMETRO NUMBER;
BEGIN
IF DIS_KILOMETRO > 0 THEN
SELECT TARIFA_KILOMETRO INTO VALOR_KILOMETRO FROM CIUDADES WHERE DESCRIPCION = CIUDAD;
RETURN (DIS_KILOMETRO * VALOR_KILOMETRO) ;
ELSE 
DBMS_OUTPUT.PUT_LINE('Distancia no valida');
END IF;
END;
--Ejecutamos la consulta funcion
SELECT VALOR_DISTANCIA(10,'Bogota') AS Valor FROM DUAL;

/*6. Crear una función llamada VALOR_TIEMPO que reciba la cantidad de minutos del servicio y el               
nombre de la ciudad donde se hizo el servicio. Con esta información deberá buscar el valor por cada
minuto dependiendo de la ciudad donde esté ubicado el viaje. Deberá retornar el resultado de               
multiplicar la distancia recorrida y el valor de cada minuto dependiendo de la ciudad. Si la cantidad de                  
minutos es menor a 0 o la ciudad no es válida deberá levantar una excepción propia. Ejemplo:                 
Viaje_ID: 342 que fue hecho en Medellín y el tiempo fue 28 minutos. En este caso deberá retornar 28* 178.571429 = 5000.00001 ?(0.25) */

CREATE OR REPLACE FUNCTION VALOR_TIEMPO (CANT_MINUTOS NUMBER, CIUDAD VARCHAR) 
RETURN NUMBER
IS
VALOR_MINUTO NUMBER;
BEGIN
IF CANT_MINUTOS > 0  THEN
SELECT TARIFA_MINUTO INTO VALOR_MINUTO FROM CIUDADES WHERE DESCRIPCION = CIUDAD;
RETURN(CANT_MINUTOS * VALOR_MINUTO);
ELSE
DBMS_OUTPUT.PUT_LINE('Distancia no valida');
END IF;
END;
--Ejecutamos la consulta funcion
SELECT VALOR_TIEMPO(60,'Medellin') AS Valor FROM DUAL;

/*7. Crear un procedimiento almacenado que se llame CALCULAR_TARIFA, deberá recibir el ID del viaje.              
Para calcular la tarifa se requiere lo siguiente ?(0.5)??: 
a. Si el estado del viaje es diferente a REALIZADO, deberá insertar 0 en el valor de la tarifa.
b. Buscar el valor de la tarifa base dependiendo de la ciudad donde se haya hecho el servicio. 
c. Invocar la función VALOR_DISTANCIA 
d. Invocar la función VALOR_TIEMPO 
e. Deberá buscar todos los detalles de cada viaje y sumarlos.  
f. Sumar la tarifa base más el resultado de la función VALOR_DISTANCIA más el resultado de 
    la función VALOR_TIEMPO y el resultado de la sumatoria de los detalles del viaje. 
g. Actualizar el registro del viaje con el resultado obtenido. 
h. Si alguna de las funciones levanta una excepción, esta deberá ser controlada y actualizar el valor del viaje con 0.*/

CREATE OR REPLACE PROCEDURE CALCULAR_TARIFA (ID_VIAJE NUMBER, DIS_KILOMETRO NUMBER, CANT_MINUTOS NUMBER) AS

ESTADO_FIN VARCHAR(255);
CIUDAD VARCHAR(255);
TARIFA_BASE1 NUMBER;
VALOR_KILOMETROS NUMBER;
VALOR_MINUTOS NUMBER;
VALOR_TOTAL NUMBER;
BEGIN
SELECT ESTADO INTO ESTADO_FIN 
FROM SERVICIOS    
WHERE ID= ID_VIAJE;    
IF ESTADO_FIN = 'FINALIZADO'  AND DIS_KILOMETRO > 0 THEN
SELECT B.TARIFA_BASE, B.DESCRIPCION INTO TARIFA_BASE1,CIUDAD 
FROM SERVICIOS A      
INNER JOIN CIUDADES B ON A.CIUDAD_ID=B.ID        
WHERE A.ID = ID_VIAJE;        
SELECT VALOR_DISTANCIA( DIS_KILOMETRO, CIUDAD ) INTO VALOR_KILOMETROS FROM DUAL;
SELECT VALOR_TIEMPO( CANT_MINUTOS, CIUDAD ) INTO VALOR_MINUTOS FROM DUAL;        
VALOR_TOTAL := VALOR_KILOMETROS + VALOR_MINUTOS + TARIFA_BASE1;        
UPDATE SERVICIOS
SET COSTO_SERVICIO = VALOR_TOTAL
WHERE ID = ID_VIAJE;        
ELSE
UPDATE SERVICIOS
SET COSTO_SERVICIO = 0
WHERE ID = ID_VIAJE;
END IF;    
END;

--Ejecutamos el procedimiento
EXEC CALCULAR_TARIFA(2,0,30);

--validamos el resultado
SELECT * FROM SERVICIOS 
WHERE ID =2;