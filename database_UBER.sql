CREATE TABLE CIUDADES
(
ID INTEGER NOT NULL,
DESCRIPCION VARCHAR2(50) NOT NULL,
CONSTRAINT CIUDADES_PK PRIMARY KEY (ID)
);
CREATE TABLE PAISES
(
ID INTEGER NOT NULL,
CIUDAD_ID INTEGER NOT NULL,
DESCRIPCION VARCHAR2(50) NOT NULL,
MONEDA VARCHAR2(50) NOT NULL,
CONSTRAINT PAIS_PK PRIMARY KEY (ID),
CONSTRAINT FK_CIUDADES_PAIS FOREIGN KEY (CIUDAD_ID)
REFERENCES CIUDADES(ID)
);
CREATE TABLE VEHICULOS 
(
ID INTEGER NOT NULL,
TIPO_VEHICULO INTEGER NOT NULL,
TARJETA_PROPIEDAD NUMBER (38,0) NOT NULL,
MODELO VARCHAR2(50) NOT NULL,
MARCA VARCHAR2(50) NOT NULL,
AÑO VARCHAR2(10) NOT NULL,
PLACA VARCHAR2(10) NOT NULL,
VEHICULO VARCHAR2(50) NOT NULL,
FECHA_CREACION TIMESTAMP NOT NULL,
CONSTRAINT VEHICULOS_PK PRIMARY KEY (ID),
CONSTRAINT CHK_TIPO_VEHICULOS CHECK (VEHICULO IN ('UBERX','UBER BLACK'))
);
CREATE TABLE CLIENTES 
(
ID INTEGER NOT NULL,
PAIS_ID INTEGER NOT NULL,
TIPO_DOCUMENTO VARCHAR2(50) NOT NULL,
IDENTIFICACION VARCHAR2(20) NOT NULL,
NOMBRES VARCHAR2(50) NOT NULL,
APELLIDOS VARCHAR2(50) NOT NULL,
FOTO_URL VARCHAR2(150) NOT NULL,
CORREO VARCHAR2(50) NOT NULL,
CORREO_ALTERNATIVO VARCHAR2(50) NOT NULL,
CELULAR NUMBER(10,0) NOT NULL,
FECHA_CREACION TIMESTAMP NOT NULL,
CONSTRAINT CLIENTES_PK PRIMARY KEY (ID),
CONSTRAINT FK_PAIS_CLI FOREIGN KEY (PAIS_ID)
REFERENCES PAISES(ID),
CONSTRAINT CHK_TIPO_DOCUMENTO CHECK (TIPO_DOCUMENTO IN ('CEDULA DE CIUDADANÃ?A','PASAPORTE','CEDULA DE EXTRANJERÃ?A'))
);
CREATE TABLE CONDUCTORES 
(
ID INTEGER NOT NULL,
VEHICULO_ID INTEGER NOT NULL,
PAIS_ID INTEGER NOT NULL,
LICENCIA_CONDUCCION NUMBER (10,0) NOT NULL,
TIPO_DOCUMENTO VARCHAR2(50) NOT NULL,
IDENTIFICACION VARCHAR2(50) NOT NULL,
NOMBRES VARCHAR2(50)NOT NULL,
APELLIDOS VARCHAR2(50) NOT NULL,
FOTO_URL VARCHAR2(150) NOT NULL,
CORREO VARCHAR2(50) NOT NULL,
CORREO_ALTERNATIVO VARCHAR2(50) NOT NULL,
CELULAR NUMBER(10,0) NOT NULL,
FECHA_CREACION TIMESTAMP NOT NULL,
CONSTRAINT CONDUCTORES_PK PRIMARY KEY (ID),
CONSTRAINT FK_PAIS_CONDUCTOR FOREIGN KEY (PAIS_ID)
REFERENCES PAISES (ID),
CONSTRAINT FK_VEHICULO_CONDUCTOR FOREIGN KEY (VEHICULO_ID)
REFERENCES VEHICULOS(ID),
CONSTRAINT CHK_TIPO_DOCUMENTO_CONDUCTOR CHECK (TIPO_DOCUMENTO IN ('CEDULA DE CIUDADANÃ?A','PASAPORTE','CEDULA DE EXTRANJERÃ?A '))
);
CREATE TABLE TIPO_VEHICULOS 
(
ID INTEGER NOT NULL,
CONDUCTOR_ID INTEGER NOT NULL,
VEHICULOS_ID INTEGER NOT NULL,
CONSTRAINT TIPO_VEHICULOS_PK PRIMARY KEY (ID),
CONSTRAINT FK_TIPOV_CONDUCTOR FOREIGN KEY (CONDUCTOR_ID)
REFERENCES CONDUCTORES(ID),
CONSTRAINT FK_TIPOV_VEHICULO FOREIGN KEY (VEHICULOS_ID)
REFERENCES VEHICULOS(ID)
);

CREATE TABLE EMPRESA 
(
ID INTEGER NOT NULL,
PAIS_ID INTEGER NOT NULL,
TIPO_DOCUMENTO VARCHAR2(3) NOT NULL,
IDENTIFICACION VARCHAR2(20) NOT NULL,
NOMBRES VARCHAR2(50) NOT NULL,
FOTO_URL VARCHAR2(150) NOT NULL,
CORREO VARCHAR2(50) NOT NULL,
CORREO_ALTERNATIVO VARCHAR2(50) NOT NULL,
CELULAR NUMBER(10,0) NOT NULL,
FECHA_CREACION TIMESTAMP NOT NULL,
CONSTRAINT EMPRESA_PK PRIMARY KEY (ID),
CONSTRAINT FK_PAIS_EMPRESA FOREIGN KEY (PAIS_ID)
REFERENCES PAISES(ID),
CONSTRAINT CHK_TIPO_DOCUMENTO_EMPRESA CHECK (TIPO_DOCUMENTO IN ('NIT'))
); 
CREATE TABLE METODOS_PAGOS
(
ID INTEGER NOT NULL,
CLIENTE_ID INTEGER NOT NULL,
EMPRESA_ID INTEGER NOT NULL,
METODOS_PAGOS VARCHAR2(50) NOT NULL,
ESTADO VARCHAR2(50) NOT NULL,
VALOR NUMBER NOT NULL,
ENVIO_FACTURA VARCHAR2(50) NOT NULL,
CONSTRAINT METODOS_PAGOS_PK PRIMARY KEY (ID),
CONSTRAINT FK_METODOS_CLIENTES FOREIGN KEY (CLIENTE_ID)
REFERENCES CLIENTES(ID),
CONSTRAINT FK_METODOS_EMPRESA FOREIGN KEY (EMPRESA_ID)
REFERENCES EMPRESA(ID),
CONSTRAINT CHK_ESTADO_METODOS CHECK (ESTADO IN ('ACTIVO','INACTIVO')),
CONSTRAINT CHK_ENVIO_METODOS CHECK (ENVIO_FACTURA IN ('SI','NO'))
);
CREATE TABLE CODIGOS_INVITACION
(
ID INTEGER NOT NULL,
CLIENTE_ID INTEGER NOT NULL,
CODIGO VARCHAR2(50) NOT NULL,
FECHA_APLICACION TIMESTAMP NOT NULL,
ESTADO VARCHAR2(50) NOT NULL,
CONSTRAINT CODIGOS_PK PRIMARY KEY (ID),
CONSTRAINT FK_CODIGO_CLIENTES FOREIGN KEY (CLIENTE_ID)
REFERENCES CLIENTES(ID),
CONSTRAINT CHK_CODIGO_ESTADO CHECK (ESTADO IN ('LIBRE','APLICADO'))
);

CREATE TABLE SERVICIOS
(
ID INTEGER NOT NULL,
CLIENTE_ID INTEGER NOT NULL,
EMPRESA_ID INTEGER NOT NULL,
CONDUCTOR_ID INTEGER NOT NULL,
METODOPAGO_ID INTEGER NOT NULL,
VEHICULO_ID INTEGER NOT NULL,
CIUDAD_ID INTEGER NOT NULL,
ESTADO VARCHAR2(50) NOT NULL,
COSTO_SERVICIO NUMBER NOT NULL,
FECHA_INICIO_RECORRIDO TIMESTAMP NOT NULL,
FECHA_FIN_RECORRIDO TIMESTAMP NOT NULL,
DIRECCION_ORIGEN VARCHAR2(50) NOT NULL,
DIRECCION_DESTINO VARCHAR2(50) NOT NULL,
CONSTRAINT SERVICIOS_PK PRIMARY KEY (ID),
CONSTRAINT FK_CLIENTE_SERVICIO FOREIGN KEY (CLIENTE_ID)
REFERENCES CLIENTES (ID),
CONSTRAINT FK_EMPRESA_SERVICIO FOREIGN KEY (EMPRESA_ID)
REFERENCES EMPRESA (ID),
CONSTRAINT FK_CONDUCTOR_SERVICIO FOREIGN KEY (CONDUCTOR_ID)
REFERENCES CONDUCTORES (ID),
CONSTRAINT FK_METODOPAGO_SERVICIO FOREIGN KEY (METODOPAGO_ID)
REFERENCES METODOS_PAGOS (ID),
CONSTRAINT FK_CIUDADES_SERVICIO FOREIGN KEY (CIUDAD_ID)
REFERENCES CIUDADES (ID),
CONSTRAINT FK_VEHICULO_SERVICIO FOREIGN KEY (VEHICULO_ID)
REFERENCES VEHICULOS(ID),
CONSTRAINT CHK_SERVICIO_ESTADO CHECK (ESTADO IN ('EXITOSO','CANCELADO','FINALIZADO'))
);

CREATE TABLE RECORRIDOS
(
ID INTEGER NOT NULL,
SERVICIO_ID INTEGER NOT NULL,
CIUDAD_ID INTEGER NOT NULL,
LONGITUD VARCHAR2(50)NOT NULL,
LATITUD VARCHAR2(50)NOT NULL,
CONSTRAINT RECORRIDOS_PK PRIMARY KEY (ID),
CONSTRAINT FK_RECORRIDO_SERVICIO FOREIGN KEY (SERVICIO_ID)
REFERENCES SERVICIOS (ID),
CONSTRAINT FK_RECORRIDO_PAISES FOREIGN KEY (CIUDAD_ID)
REFERENCES CIUDADES(ID)
);
CREATE TABLE FACTURAS
(
ID INTEGER NOT NULL,
VALOR_FACTURA NUMBER,
FECHA_FACTURA TIMESTAMP,
CONSTRAINT FACTURAS_PK PRIMARY KEY (ID)
);

CREATE TABLE DETALLE_FACTURAS
(
ID INTEGER NOT NULL,
FACTURA_ID INTEGER NOT NULL,
SERVICIO_ID INTEGER NOT NULL,
VEHICULO_ID INTEGER NOT NULL,
RECORRIDO_ID INTEGER NOT NULL,
NUMERO_VIAJES NUMBER (3,0) NOT NULL,
CONCEPTO VARCHAR2(50) NOT NULL,
VALOR NUMBER NOT NULL,
CONSTRAINT DETALLE_FACTURAS_PK PRIMARY KEY (ID),
CONSTRAINT FK_SERVICIO_D FOREIGN KEY (SERVICIO_ID)
REFERENCES SERVICIOS(ID),
CONSTRAINT FK_VEHICULO_D FOREIGN KEY (VEHICULO_ID)
REFERENCES VEHICULOS(ID),
CONSTRAINT FK_RECORRIDO_D FOREIGN KEY (RECORRIDO_ID)
REFERENCES RECORRIDOS(ID),
CONSTRAINT FK_FACTURA_DETALLE FOREIGN KEY (FACTURA_ID)
REFERENCES FACTURAS(ID),
CONSTRAINT CHK_CONCEPTO CHECK (CONCEPTO IN ('COSTO_BASE','COSTO_RECARGO','COSTO_DEDUCCION','COSTO_IVA','PROPINA'))
);

CREATE TABLE PAYPAL
(
ID INTEGER NOT NULL,
CORREO VARCHAR2(50) NOT NULL,
CLAVE VARCHAR2(50) NOT NULL,
METODOS_PAGOS_ID INTEGER NOT NULL,
CONSTRAINT PAYPAL_PK PRIMARY KEY (ID),
CONSTRAINT FK_METODOS_PAGOS FOREIGN KEY (METODOS_PAGOS_ID)
REFERENCES METODOS_PAGOS(ID)
);

CREATE TABLE HISTORIAL_VIAJES
(
ID INTEGER NOT NULL,
FECHA TIMESTAMP,
CONDUCTOR_ID INTEGER NOT NULL,
CLIENTE_ID INTEGER NOT NULL,
FACTURA_DETALLE_ID INTEGER NOT NULL,
METODOS_PAGOS_ID INTEGER NOT NULL,
FECHA_CORTE TIMESTAMP NOT NULL,
CONSTRAINT HISTORIAL_VIAJES_PK PRIMARY KEY (ID),
CONSTRAINT FK_METODOS_PAGOS2 FOREIGN KEY (METODOS_PAGOS_ID)
REFERENCES METODOS_PAGOS(ID),
CONSTRAINT FK_CONDUCTOR2 FOREIGN KEY (CONDUCTOR_ID)
REFERENCES CONDUCTORES(ID),
CONSTRAINT FK_CLIENTE_VIAJE FOREIGN KEY (CLIENTE_ID)
REFERENCES CONDUCTORES(ID),
CONSTRAINT FK_FACTURA_DETALLE2 FOREIGN KEY (FACTURA_DETALLE_ID)
REFERENCES DETALLE_FACTURAS(ID)
);

CREATE TABLE TARJETA_DEBITO
(
ID INTEGER NOT NULL,
ENTIDAD_BANCARIA VARCHAR2(50) NOT NULL,
CLIENTE_ID INTEGER NOT NULL,
METODOS_PAGOS_ID INTEGER NOT NULL,
CONSTRAINT TARJETA_DEBITO_PK PRIMARY KEY (ID),
CONSTRAINT FK_METODOS_PAGOS4 FOREIGN KEY (METODOS_PAGOS_ID)
REFERENCES METODOS_PAGOS(ID),
CONSTRAINT FK_CLIENTE4 FOREIGN KEY (CLIENTE_ID)
REFERENCES CLIENTES (ID)
);

CREATE TABLE TARJETA_CREDITO
(
ID INTEGER NOT NULL,
 NUMERO_TARJETA VARCHAR2(50) NOT NULL,
 FECHA_VENCIMIENTO TIMESTAMP,
 CODIGO_SEGURIDAD VARCHAR2(50) NOT NULL,
 METODOS_PAGOS_ID INTEGER NOT NULL,
CONSTRAINT TARJETA_CREDITO_PK PRIMARY KEY (ID),
CONSTRAINT FK_METODOS_PAGOS3 FOREIGN KEY (METODOS_PAGOS_ID)
REFERENCES METODOS_PAGOS(ID)
);
/* CREATE SEQUENCES FOR EVERY PRIMARY KEY*/
CREATE SEQUENCE ID_CIUDADES INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_CLIENTES INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_CONDUCTORES INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_DEPARTAMENTOS INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_DETALLE_FACTURAS INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_FACTURAS INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_PAISES INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_RECORRIDOS INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_SERVICIOS INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_VEHICULOS INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_METODOS_PAGOS INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_CODIGOS_INVITACION INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_EMPRESA INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_PAYPAL INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_TARJETA_CREDITO INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_TARJETA_DEBITO INCREMENT BY 1 START WITH 1 MINVALUE 1;
CREATE SEQUENCE ID_TIPO_VEHICULOS INCREMENT BY 1 START WITH 1 MINVALUE 1;


/*INSERT TABLA CIUDADES*/
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Teno');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Sundrie');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Rochester');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Baddeck');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Williams Lake');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Maule');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Zignago');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Königs Wusterhausen');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Ipís');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Merritt');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Potsdam');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Price');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Sint-Niklaas');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Dhuy');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Ostrowiec ?wi?tokrzyski');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Bulzi');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Hawick');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Wanaka');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Heule');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Montebello');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Itter');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Merseburg');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Houston');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Meise');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Gols');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Covington');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Wandsworth');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Hertford');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Uberlândia');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Harlow');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Penco');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Regina');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Osogbo');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Yellowhead County');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Lairg');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Chelmsford');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Smoky Lake');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Vergemoli');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Vegreville');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Calama');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Paradise');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Rodì Milici');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Freux');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Filey');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Shimoga');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Kilwinning');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Upplands Väsby');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Vancouver');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Le Havre');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Newbury');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Libramont-Chevigny');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Bragança');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Évreux');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Pratovecchio');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Oxford');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Ceppaloni');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Rionero in Vulture');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Tarvisio');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Uddevalla');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Casperia');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Dawson Creek');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Marzabotto');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Haren');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Smithers');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Cuccaro Vetere');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Culemborg');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Abingdon');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Raymond');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Doñihue');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Spruce Grove');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Temuco');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Cochrane');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Stekene');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Teruel');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Worms');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Gaithersburg');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Mansfield-et-Pontefract');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Paradise');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Turgutlu');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Noville');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Hollabrunn');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Trois-Rivi?res');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Lincoln');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Savannah');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Wibrin');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Gonars');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Develi');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Sparwood');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Suarlee');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Springfield');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'St. David''s');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Dhuy');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Götzis');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'El Carmen');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Collipulli');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Montignies-Saint-Christophe');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Compiano');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Monghidoro');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Penna San Giovanni');
INSERT INTO CIUDADES (id,descripcion) VALUES (ID_CIUDADES.nextval,'Hassan');

/*INSERT TABLA PAISES*/

INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,78,'Solomon Islands','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,43,'Nepal','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,63,'Singapore','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,59,'Latvia','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,76,'Macao','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,52,'Liechtenstein','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,97,'Ghana','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,55,'Burkina Faso','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,93,'South Africa','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,29,'Israel','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,86,'Bonaire, Sint Eustatius and Saba','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,80,'Mauritius','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,82,'Tonga','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,13,'Namibia','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,37,'Saint Lucia','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,81,'British Indian Ocean Territory','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,3,'Moldova','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,63,'Honduras','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,56,'Libya','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,61,'Mauritania','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,67,'Switzerland','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,16,'Brunei','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,30,'Germany','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,51,'Jordan','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,79,'Martinique','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,40,'Liechtenstein','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,90,'Guadeloupe','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,3,'Indonesia','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,76,'Iran','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,22,'Syria','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,97,'Pakistan','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,21,'Western Sahara','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,47,'Gabon','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,98,'Guyana','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,15,'Mayotte','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,87,'Lebanon','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,74,'Singapore','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,62,'Denmark','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,79,'Azerbaijan','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,73,'Saudi Arabia','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,1,'Burundi','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,74,'Gabon','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,89,'Honduras','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,39,'Guatemala','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,13,'Belgium','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,8,'Mali','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,20,'Turkmenistan','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,1,'Montenegro','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,92,'Tunisia','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,42,'Japan','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,15,'Portugal','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,17,'Slovenia','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,84,'Morocco','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,57,'Samoa','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,6,'Austria','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,64,'Germany','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,3,'Guyana','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,15,'Guadeloupe','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,78,'Senegal','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,86,'Turkey','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,62,'Brunei','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,22,'Kuwait','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,43,'Bosnia and Herzegovina','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,25,'Nicaragua','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,29,'Guatemala','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,59,'Korea, South','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,67,'Wallis and Futuna','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,66,'Svalbard and Jan Mayen Islands','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,19,'India','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,75,'Nauru','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,25,'Zambia','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,34,'Bolivia','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,2,'United States Minor Outlying Islands','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,30,'Bonaire, Sint Eustatius and Saba','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,63,'Austria','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,29,'Tonga','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,1,'Chad','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,15,'Paraguay','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,40,'Malaysia','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,41,'Zambia','Euro');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,43,'United States Minor Outlying Islands','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,23,'Korea, South','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,50,'Macedonia','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,72,'Ethiopia','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,26,'Iran','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,45,'Nepal','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,81,'Liberia','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,43,'Somalia','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,71,'Sint Maarten','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,3,'Denmark','Pesos');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,87,'South Africa','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,56,'Somalia','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,81,'Myanmar','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,32,'Australia','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,29,'American Samoa','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,39,'Austria','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,49,'Norfolk Island','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,77,'Seychelles','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,93,'South Georgia and The South Sandwich Islands','Dollar');
INSERT INTO PAISES(ID,ciudad_id,descripcion,moneda) VALUES (ID_PAISES.nextval,80,'Kiribati','Dollar');

/*INSERT TABLA VEHICULOS*/
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,71,3541166587203250,'Familia','Mazda','Pjhy-9027',1989,'UBER BLACK','2/10/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,6,3554759965238500,'Tracker','Geo','Xlqd-6568',1993,'UBERX','5/12/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,9,5610897820498980000,'Firebird','Pontiac','Gxaa-0112',1997,'UBERX','31/07/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,3,3566055239132400,'43168','Saab','Pvok-9635',2005,'UBER BLACK','23/04/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,38,564182716261433000,'CLK-Class','Mercedes-Benz','Upov-6807',2002,'UBERX','9/11/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,75,374622031729329,'Accord','Honda','Plrv-7761',2009,'UBERX','20/09/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,79,3565674073741900,'Accord','Honda','Achn-4858',1994,'UBERX','3/11/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,80,3559555729395820,'911','Porsche','Wdna-6891',2004,'UBERX','13/07/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,100,5602236222299730,'Outlander','Mitsubishi','Ngop-5640',2008,'UBER BLACK','6/07/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,10,3546677768779890,'Canyon','GMC','Hjtf-0944',2005,'UBER BLACK','7/10/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,8,3560261798653190,'Carens','Kia','Lxfy-6727',2007,'UBER BLACK','13/04/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,34,3560624579070260,'LUV','Chevrolet','Mqza-4595',1979,'UBER BLACK','6/10/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,43,372301447254147,'Yukon XL 1500','GMC','Imjz-3410',2001,'UBERX','18/10/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,55,3580278580292850,'Spectra','Kia','Zaua-1355',2003,'UBER BLACK','5/03/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,62,201550494863690,'Navigator','Lincoln','Zgvn-6651',2012,'UBER BLACK','3/10/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,22,3558652200661010,'Sentra','Nissan','Ddqg-1673',1995,'UBERX','14/03/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,82,67069906294136900,'Aveo','Chevrolet','Kcyv-3589',2005,'UBERX','20/12/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,56,5018485253639930,'300SE','Mercedes-Benz','Apdz-7224',1992,'UBERX','5/12/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,73,201888082591269,'M-Class','Mercedes-Benz','Zulx-3399',2003,'UBER BLACK','29/07/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,22,5602242818325940,'Impala','Chevrolet','Ckhq-4006',2006,'UBER BLACK','9/07/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,90,5610423810917030,'Sorento','Kia','Edjw-0018',2007,'UBERX','8/12/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,57,4917068848657020,'2500','Chevrolet','Eumx-4537',1998,'UBERX','2/05/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,16,3533571298564370,'Ram Van B350','Dodge','Obox-2432',1994,'UBER BLACK','28/03/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,74,56022167205344100,'GTO','Mitsubishi','Zrys-1776',1998,'UBER BLACK','25/10/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,12,4405372453588880,'Murano','Nissan','Ungs-3125',2005,'UBERX','20/02/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,72,5610574549876880000,'Camry Hybrid','Toyota','Phvf-5418',2009,'UBERX','2/04/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,36,5496649621102670,'RAV4','Toyota','Qyup-4142',2008,'UBER BLACK','10/02/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,10,3538144694381000,'Town Car','Lincoln','Eglw-0031',2003,'UBERX','6/01/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,95,5489394267805830,'Lucerne','Buick','Hmqy-6349',2011,'UBER BLACK','20/12/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,55,676799900069164000,'Ram 2500','Dodge','Avbd-4338',2003,'UBER BLACK','23/10/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,95,6391628067097870,'IS','Lexus','Kzzd-2578',2006,'UBER BLACK','23/03/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,66,4915564723554,'LR4','Land Rover','Zurl-6368',2011,'UBER BLACK','27/04/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,86,5408674752818260,'Supra','Toyota','Zdbg-3048',1992,'UBER BLACK','5/05/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,38,4844393436498770,'Ion','Saturn','Srct-9780',2004,'UBERX','7/10/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,18,4175009881725910,'Outback','Subaru','Xeod-3776',2005,'UBERX','7/12/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,73,3579336909621730,'F-Series','Ford','Endw-7739',1985,'UBER BLACK','22/01/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,25,5010128428923880,'Xterra','Nissan','Tjbv-5449',2006,'UBERX','29/11/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,11,3531556278915280,'Cabriolet','Volkswagen','Dhxf-4702',1988,'UBERX','17/08/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,27,5602246374577830,'Town','Chrysler','Tuxp-9625',1994,'UBER BLACK','9/10/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,18,6334565919094780000,'Intrigue','Oldsmobile','Fvoq-6052',1998,'UBER BLACK','26/12/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,27,6759907844983910000,'Spectra','Kia','Yvzd-5622',2005,'UBERX','19/09/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,71,3561583299177040,'Sequoia','Toyota','Tnnt-1824',2004,'UBERX','21/11/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,70,347997454103663,'Silhouette','Oldsmobile','Liwa-9793',1997,'UBERX','16/11/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,89,3584117051567920,'Z3','BMW','Aaem-5171',2000,'UBER BLACK','10/03/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,71,4781986246313,'Quest','Nissan','Jxfb-4089',2009,'UBERX','3/06/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,7,201679760886661,'Optima','Kia','Kezk-1102',2003,'UBER BLACK','5/04/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,95,503860517720936000,'Mazda5','Mazda','Depq-8719',2009,'UBER BLACK','28/07/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,41,5570686694486560,'V40','Volvo','Vlre-6796',2000,'UBER BLACK','3/06/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,64,3528219237137180,'Caliber','Dodge','Kkxx-7398',2009,'UBERX','13/05/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,78,3581249484905390,'Cherokee','Jeep','Tfyp-9906',1999,'UBER BLACK','7/03/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,79,3566935103424850,'Prius Plug-in Hybrid','Toyota','Kjwn-5694',2012,'UBERX','4/02/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,36,5602228710082980,'CL65 AMG','Mercedes-Benz','Coiu-9416',2009,'UBER BLACK','14/04/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,16,3531856078177730,'LS','Lexus','Ttch-6200',2002,'UBERX','20/12/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,9,3542636719337430,'Yukon','GMC','Dwhe-8974',1995,'UBER BLACK','14/06/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,45,374622458713897,'CL-Class','Mercedes-Benz','Zvnr-7183',1999,'UBERX','8/09/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,38,3572430459605270,'RL','Acura','Uuve-5159',2001,'UBER BLACK','20/04/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,54,4041594524829,'Voyager','Plymouth','Ujid-2111',1994,'UBERX','3/12/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,68,30121996715361,'SSR','Chevrolet','Ovlx-3675',2004,'UBER BLACK','6/07/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,16,3530416330776590,'Ridgeline','Honda','Upaj-8888',2006,'UBER BLACK','15/11/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,35,5002359450201540,'Concorde','Chrysler','Fwld-3910',1999,'UBER BLACK','4/04/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,18,502078233882530000,'Mountaineer','Mercury','Irdj-3626',1997,'UBERX','27/05/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,81,3541850025201730,'Envoy','GMC','Zmrm-3337',2005,'UBERX','15/06/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,66,4405819683806460,'Regal','Buick','Bjfc-9877',1996,'UBER BLACK','17/01/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,83,4175000742474530,'B-Series Plus','Mazda','Icox-2593',2004,'UBERX','10/11/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,7,30121552135822,'H3','Hummer','Ywar-8240',2008,'UBER BLACK','14/12/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,30,3579660145355800,'57','Maybach','Jney-8292',2006,'UBERX','2/10/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,78,3543418831292160,'Achieva','Oldsmobile','Dsnq-2015',1997,'UBERX','18/07/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,67,5610927404711110,'S-Type','Jaguar','Exoq-2357',2008,'UBER BLACK','2/01/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,33,3535009836046510,'Rodeo','Isuzu','Kzpd-4184',1996,'UBERX','27/06/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,27,4508812193747870,'Mountaineer','Mercury','Azfd-6754',2005,'UBERX','9/08/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,2,3539351258763430,'Crown Victoria','Ford','Rzto-4563',2008,'UBER BLACK','27/01/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,87,3578000278377030,'Ram 3500','Dodge','Tzsk-1645',1999,'UBER BLACK','14/08/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,50,5602239477492720,'i-Series','Isuzu','Ohyg-8758',2008,'UBER BLACK','21/06/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,39,3540344600925360,'CL','Acura','Szso-1566',1998,'UBERX','29/09/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,100,337941522605418,'Q7','Audi','Emwc-9983',2008,'UBERX','11/01/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,14,56022125983793400,'Eurovan','Volkswagen','Sdaa-5726',1994,'UBER BLACK','31/03/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,30,6331108711414430000,'CL','Acura','Vkcs-8865',1997,'UBERX','22/05/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,41,5540132315883700,'Odyssey','Honda','Gcji-7975',2004,'UBERX','2/03/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,61,3562102452255740,'Yukon XL 1500','GMC','Vjzu-5496',2008,'UBERX','26/01/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,10,5524109927763100,'Reno','Suzuki','Etgt-2023',2008,'UBERX','17/03/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,48,3582135971118170,'Optima','Kia','Xbvm-6314',2012,'UBERX','21/10/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,73,5641825436532090,'Expedition EL','Ford','Fyel-2366',2009,'UBER BLACK','16/03/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,77,67614204913617000,'350Z','Nissan','Lqtv-9084',2004,'UBERX','31/03/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,81,3541766507111620,'Suburban 1500','GMC','Bzom-8649',1998,'UBER BLACK','7/03/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,63,5486209965787730,'SL65 AMG','Mercedes-Benz','Ksdx-9061',2006,'UBER BLACK','22/09/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,57,5602254416650740,'Patriot','Jeep','Xaxs-8718',2011,'UBERX','26/06/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,24,3559338129037290,'Sierra 1500','GMC','Uckb-4621',2009,'UBER BLACK','22/09/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,39,3540854980042080,'CLS-Class','Mercedes-Benz','Vper-6367',2012,'UBER BLACK','9/09/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,15,6331103494548610,'LX','Lexus','Mbha-4179',2010,'UBERX','14/09/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,53,5100148335226080,'Rapide','Aston Martin','Lxst-4394',2010,'UBER BLACK','17/11/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,2,633110510627431000,'Fusion','Ford','Jvqj-2079',2012,'UBERX','5/02/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,42,3558203522822860,'Fox','Volkswagen','Qagp-1316',1992,'UBER BLACK','22/06/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,72,630480227490130000,'Express 3500','Chevrolet','Cpxs-0030',2002,'UBER BLACK','26/03/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,70,3553166986568030,'Carens','Kia','Bvsk-2230',2007,'UBERX','22/05/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,45,56022242233765100,'6 Series','BMW','Kndk-1793',2005,'UBER BLACK','3/10/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,83,4508693298742520,'Regal','Buick','Ilyf-7176',1998,'UBER BLACK','18/03/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,81,3570657070360750,'XL-7','Suzuki','Shab-0327',2001,'UBERX','6/04/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,54,5602215470402380,'Windstar','Ford','Tywh-0795',2003,'UBERX','5/01/2018');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,48,3548683125851290,'Taurus','Ford','Tnlg-0755',2009,'UBERX','19/11/2017');
INSERT INTO VEHICULOS(ID,tipo_vehiculo,tarjeta_propiedad,modelo,marca,"AÑO",placa,vehiculo,fecha_creacion) VALUES (ID_VEHICULOS.nextval,44,5602225965197840,'1500 Club Coupe','GMC','Rrdn-6162',1998,'UBERX','22/04/2018');
