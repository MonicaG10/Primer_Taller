/*1.Crear una vista llamada â€œMEDIOS_PAGO_CLIENTESâ€? que contenga las siguientes columnas:
CLIENTE_ID, NOMBRE_CLIENTE (Si tiene el nombre y el apellido separados en columnas, deberÃ¡n
estar unidas en una sola), MEDIO_PAGO_ID, TIPO (TDC, Android, Paypal, Efectivo),
DETALLES_MEDIO_PAGO, EMPRESARIAL (FALSO o VERDADERO), NOMBRE_EMPRESA (Si la
columna Empresarial es falso, este campo aparecerÃ¡ Nulo) (0.25)*/


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


/*2. Cree una vista que permita listar los viajes de cada cliente ordenados cronolÃ³gicamente. El nombre
de la vista serÃ¡ â€œVIAJES_CLIENTESâ€?, los campos que tendrÃ¡ son: FECHA_VIAJE,
NOMBRE_CONDUCTOR, PLACA_VEHICULO, NOMBRE_CLIENTE, VALOR_TOTAL,
TARIFA_DINAMICA (FALSO O VERDADERO), TIPO_SERVICIO (UberX o UberBlack),
CIUDAD_VIAJE. (0.25)*/


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
/*3 Cree y evidencie el plan de ejecución de la vista VIAJES_CLIENTES. Cree al menos un índice donde                 
mejore el rendimiento del query y muestre el nuevo plan de ejecución. ?(0.25) 
*/
EXPLAIN PLAN SET STATEMENT_ID = 'EXPLAIN_PLAN_VIAJES_CLIENTES' FOR
SELECT * FROM VIAJES_CLIENTES;
SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY); 


/*5 Crear una función llamada VALOR_DISTANCIA que reciba la distancia en kilómetros y el nombre de              
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

/*6Crear una función llamada VALOR_TIEMPO que reciba la cantidad de minutos del servicio y el               
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

CREATE OR REPLACE PROCEDURE CALCULAR_TARIFA (ID_VIAJE NUMBER , VALOR_VIAJE NUMBER)
IS
   ESTADO_VIAJE VARCHAR2;
   TARIFA_KILOMETRO NUMBER;
   TARIFA_MINUTO NUMBER;
   DISTANCIA EXCEPTION; -- variable de distancia a la cual se le aplicaria el control de excepciones
   TIEMPO EXCEPTION; --variable de tiempo a la cual se le aplicaria el control de excepciones
BEGIN
  SELECT REPLACE(S.ESTADO,'EXITOSO','REALIZADO') AS ESTADO,
         C.TARIFA_BASE, S.ID AS SERVICIO, D.VALOR,C.TARIFA_KILOMETRO,C.TARIFA_MINUTO
   FROM SERVICIOS S 
        INNER JOIN CIUDADES C ON S.CIUDAD_ID = C.ID
        INNER JOIN FACTURAS F ON F.SERVICIO_ID =S.ID
        INNER JOIN (SELECT FACTURA_ID, SUM(VALOR) AS VALOR
        FROM DETALLE_FACTURAS GROUP BY FACTURA_ID) D ON  D.FACTURA_ID=F.ID
   WHERE ID_VIAJE=S.ID;
   IF ESTADO_VIAJE != 'REALIZADO' THEN -- Si el estado del viaje es diferente a REALIZADO, deberá insertar 0 en el valor de la tarifa.
      VALOR_VIEJE := 0; 
      RAISE VALOR_VIEJE;
   ELSE
      DISTANCIA := VALOR_DISTANCIA(TARIFA_KILOMETRO); -- Invocar la función VALOR_DISTANCIA
      TIEMPO := FUNCION(TARIFA_MINUTO); -- Invocar la función VALOR_TIEMPO
      VALOR_VIEJE :=C.TARIFA_BASE +DISTANCIA +TIEMPO + D.VALOR;
      UPDATE SERVICOS SET COSTO_SERVICIO = VALOR_VIEJE  WHERE ID_VIAJE=S.ID;
      UPDATE FACTURAS SET VALOR_FACTURA = VALOR_VIEJE WHERE ID_VIAJE=F.SERVICIO_ID;
   END IF;
      EXCEPTION
	    WHEN DISTANCIA THEN
	    RAISE_APPLICATION_ERROR(-20010,'NO TIENE DISTANCIA CALCULADA');
        VALOR_VIEJE := 0; -- Si alguna de las funciones levanta una excepción, esta deberá ser controlada y actualizar el
                                --valor del viaje con 0.
        WHEN TIEMPO THEN
	    RAISE_APPLICATION_ERROR(-20011,'NO TIENE TIEMPO CALCULADO');
        VALOR_VIEJE := 0; --Si alguna de las funciones levanta una excepción, esta deberá ser controlada y actualizar el
                            --valor del viaje con 0.
END VALOR_VIEJE;

