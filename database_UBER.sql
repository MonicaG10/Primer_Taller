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
TARJETA_PROPIEDAD NUMBER (12,0) NOT NULL,
MODELO VARCHAR2(50) NOT NULL,
MARCA VARCHAR2(50) NOT NULL,
A�O VARCHAR2(10) NOT NULL,
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
CEDULA VARCHAR2(20) NOT NULL,
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
CONSTRAINT CHK_TIPO_DOCUMENTO CHECK (TIPO_DOCUMENTO IN ('CEDULA DE CIUDADAN�A','PASAPORTE','CEDULA DE EXTRANJER�A'))
);
CREATE TABLE CONDUCTORES 
(
ID INTEGER NOT NULL,
VEHICULO_ID INTEGER NOT NULL,
PAIS_ID INTEGER NOT NULL,
LICENCIA_CONDUCCION NUMBER (10,0) NOT NULL,
TIPO_DOCUMENTO VARCHAR2(50) NOT NULL,
CEDULA VARCHAR2(50) NOT NULL,
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
CONSTRAINT CHK_TIPO_DOCUMENTO_CONDUCTOR CHECK (TIPO_DOCUMENTO IN ('CEDULA DE CIUDADAN�A','PASAPORTE','CEDULA DE EXTRANJER�A '))
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

