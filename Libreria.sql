--------------------- CREACION DE LA BASE DE DATOS ----------------------


--------------------- LAS DE AFUERA ----------------------

CREATE TABLE TBLPREMIOS
(CODIGO NUMBER PRIMARY KEY,
NOMBRE_PREMIO VARCHAR2(30) NOT NULL,
ANOCREACION NUMBER);

CREATE TABLE TBLNACIONALIDAD
(CODIGO NUMBER PRIMARY KEY,
DESCRIPCION VARCHAR2(30) NOT NULL);


CREATE TABLE TBLCIUDAD
(CODIGO NUMBER PRIMARY KEY,
NOMBRE VARCHAR2(40) NOT NULL,
NROHABITANTES NUMBER);

CREATE TABLE TBLGENERO
(CODIGO NUMBER PRIMARY KEY,
DESCRIPCION VARCHAR2(30) NOT NULL);

--------------------------------------------------------------------------------------------------------------


--------------------- LAS DEL MEDIO ----------------------

CREATE TABLE TBLLIBROPREMIO
(CODLIBRO NUMBER NOT NULL,
CODPREMIO NUMBER NOT NULL,
ANOPREMIO NUMBER,
VALORPREMIO FLOAT,
NoASISTENTESEVENTO NUMBER,
PRIMARY KEY(CODLIBRO, CODPREMIO));


CREATE TABLE TBLAUTOR
(CODIGO NUMBER PRIMARY KEY,
NOMBRE VARCHAR2(30) NOT NULL,
EDAD NUMBER,
SUELDO FLOAT,
CODNACION NUMBER);



CREATE TABLE TBLEDITORIAL
(CODIGO NUMBER PRIMARY KEY,
NOMBRE VARCHAR2(30) NOT NULL,
NUMEMPLEADOS NUMBER,
CODCIUDAD NUMBER);


-------------------------------------------------------------------------------------------------------------------


CREATE TABLE TBLLIBRO
(CODIGO NUMBER PRIMARY KEY,
TITULO VARCHAR2(30) NOT NULL,
NROPAGINAS NUMBER,
CODAUTOR NUMBER,
CODGENERO NUMBER,
CODEDITORIAL NUMBER);



--------------------- Claves Foraneas ----------------------

ALTER TABLE TBLLIBROPREMIO ADD FOREIGN KEY(CODPREMIO) REFERENCES TBLPREMIOS(CODIGO);
ALTER TABLE TBLLIBROPREMIO ADD FOREIGN KEY(CODLIBRO) REFERENCES TBLLIBRO(CODIGO);

ALTER TABLE TBLAUTOR ADD FOREIGN KEY(CODNACION) REFERENCES TBLNACIONALIDAD(CODIGO);

ALTER TABLE TBLEDITORIAL ADD FOREIGN KEY(CODCIUDAD) REFERENCES TBLCIUDAD(CODIGO);

ALTER TABLE TBLLIBRO ADD FOREIGN KEY(CODAUTOR) REFERENCES TBLAUTOR(CODIGO);
ALTER TABLE TBLLIBRO ADD FOREIGN KEY(CODGENERO) REFERENCES TBLGENERO(CODIGO);
ALTER TABLE TBLLIBRO ADD FOREIGN KEY(CODEDITORIAL) REFERENCES TBLEDITORIAL(CODIGO);


--------------------------------------------------------------------------------------------------------------


--------------------- Insert datos ----------------------


--------------------- LAS DE AFUERA ----------------------
INSERT INTO TBLPREMIOS VALUES (100,'Nobel',2000);
INSERT INTO TBLPREMIOS VALUES (200,'Mejor Comedia',2013);
INSERT INTO TBLPREMIOS VALUES (300,'Best seller',2021);
INSERT INTO TBLPREMIOS VALUES (400,'Mejor Novela',2020);



INSERT INTO TBLNACIONALIDAD VALUES (1, 'Frances');
INSERT INTO TBLNACIONALIDAD VALUES (2, 'Ingles');
INSERT INTO TBLNACIONALIDAD VALUES (3, 'Sueco');
INSERT INTO TBLNACIONALIDAD VALUES (4, 'Aleman');

select * from TBLNACIONALIDAD;


INSERT INTO TBLCIUDAD VALUES (1000,'Oslo',2000000);
INSERT INTO TBLCIUDAD VALUES (2000,'Tokio',30000000);
INSERT INTO TBLCIUDAD VALUES (3000,'Berlin',14000000);
INSERT INTO TBLCIUDAD VALUES (4000,'Paris',7000000);


INSERT INTO TBLGENERO VALUES (1111,'Comedia');
INSERT INTO TBLGENERO VALUES (2222,'Romance');
INSERT INTO TBLGENERO VALUES (3333,'Misterio');
INSERT INTO TBLGENERO VALUES (4444,'Terror');
----------------------------------------------------------------------------------------------------------


--------------------- LAS DEL MEDIO ----------------------


INSERT INTO TBLEDITORIAL VALUES (1, 'International EU', 200, 1000);
INSERT INTO TBLEDITORIAL VALUES (2, 'Editorial EU', 20, 1000);
INSERT INTO TBLEDITORIAL VALUES (3, 'Conichigua', 340, 2000);
INSERT INTO TBLEDITORIAL VALUES (4, 'Elsevier', 500, 4000);

select * from TBLAUTOR;

INSERT INTO TBLAUTOR VALUES (111, 'Gabo', 66, 10000,1 );
INSERT INTO TBLAUTOR VALUES (222, 'Wilde', 43, 20000, 2 );
INSERT INTO TBLAUTOR VALUES (333, 'Charles', 38, 4000, 3 );
INSERT INTO TBLAUTOR VALUES (444, 'Ana', 13, 2000, 4);




INSERT INTO TBLLIBROPREMIO VALUES (11111, 100, 1998, 850000, 425);
INSERT INTO TBLLIBROPREMIO VALUES (22222, 200, 1972, 2500000, 835);
INSERT INTO TBLLIBROPREMIO VALUES (33333, 300, 2018, 400000, 200);
INSERT INTO TBLLIBROPREMIO VALUES (44444, 400, 2021, 8600000, 700);
select * from TBLLIBROPREMIO


----------------------------------------------------------------------------------------------------------------


INSERT INTO TBLLIBRO VALUES (11111, 'El Retrato', 342, 222, 1111, 1);
INSERT INTO TBLLIBRO VALUES (22222, 'El Gato Negro', 132, 333, 2222, 2);
INSERT INTO TBLLIBRO VALUES (33333, 'El Principito', 89, 111, 3333, 3);
INSERT INTO TBLLIBRO VALUES (44444, 'El Diario De Ana Frank', 200, 444, 4444, 4);

select * from TBLLIBRO;


select * from all_tables where table_name = 'TBLLIBROPREMIO';




--------------------- Lector --------------------------
CREATE USER Lector IDENTIFIED BY lector123;

alter session set "_ORACLE_SCRIPT"=true;

GRANT CREATE SESSION TO Lector;

CREATE PUBLIC SYNONYM Libros FOR TBLLIBRO;

CREATE PUBLIC SYNONYM Editorial FOR TBLEDITORIAL;

CREATE PUBLIC SYNONYM Genero FOR TBLGENERO;



GRANT SELECT ON libros TO lector;

GRANT SELECT ON Editorial TO lector;

GRANT SELECT ON Genero TO lector;



CREATE PROFILE perfilLector LIMIT 
SESSIONS_PER_USER 10
IDLE_TIME 2
CONNECT_TIME 5;


ALTER USER lector PROFILE perfilLector; 

DROP PROFILE perfilLector CASCADE;
--------------------------------------------------------------------------------------------------------


--------------------- Bibliotecaria --------------------------

CREATE USER Bibliotecaria IDENTIFIED BY bibli123;

CREATE ROLE Biblioteca;

GRANT CREATE SESSION, CREATE TABLE  TO
Biblioteca;



GRANT SELECT ON TBLPREMIOS TO Bibliotecaria;

GRANT SELECT ON TBLNACIONALIDAD TO Bibliotecaria;

GRANT SELECT ON TBLCIUDAD TO Bibliotecaria;

GRANT SELECT ON TBLLIBROPREMIO TO Bibliotecaria;

GRANT SELECT ON TBLAUTOR TO Bibliotecaria;

GRANT SELECT ON libros TO Bibliotecaria;

GRANT SELECT ON Editorial TO Bibliotecaria;

GRANT SELECT ON Genero TO Bibliotecaria;





GRANT INSERT ON libros TO Bibliotecaria;

ALTER USER Bibliotecaria QUOTA UNLIMITED ON users;



CREATE PROFILE perfilBiblio LIMIT 
SESSIONS_PER_USER 3
IDLE_TIME 5
CONNECT_TIME 10;


ALTER USER Bibliotecaria PROFILE perfilBiblio; 


GRANT Biblioteca TO Bibliotecaria;

CREATE ROLE premios;

GRANT insert ON TBLPREMIOS TO premios;


GRANT premios TO Bibliotecaria;

revoke premios FROM Bibliotecaria;

--------------------------------------------------------------------------------------------------------


--------------------- GerenteLibrary --------------------------

CREATE USER GerenteLibrary IDENTIFIED BY gerente123;




GRANT SELECT ON TBLPREMIOS TO GerenteLibrary;

GRANT SELECT ON TBLNACIONALIDAD TO GerenteLibrary;

GRANT SELECT ON TBLCIUDAD TO GerenteLibrary;

GRANT SELECT ON TBLLIBROPREMIO TO GerenteLibrary;

GRANT SELECT ON TBLAUTOR TO GerenteLibrary;

GRANT SELECT ON libros TO GerenteLibrary;

GRANT SELECT ON Editorial TO GerenteLibrary;

GRANT SELECT ON Genero TO GerenteLibrary;


CREATE ROLE Gerente;

GRANT CREATE SESSION, CREATE TABLE, CREATE VIEW  TO
Gerente;


GRANT Gerente TO GerenteLibrary;



CREATE PROFILE PerfilGerente LIMIT 
SESSIONS_PER_USER 1
IDLE_TIME 3
CONNECT_TIME 5
FAILED_LOGIN_ATTEMPTS 2  -- Despues de cuantos intentos se bloquea la cuenta
PASSWORD_LOCK_TIME 10/1440;  -- Numero de dias para que se desbloquee la cuenta



ALTER USER GerenteLibrary PROFILE PerfilGerente; 



GRANT insert ON TBLPREMIOS TO GerenteLibrary;

GRANT insert ON TBLNACIONALIDAD TO GerenteLibrary;

GRANT insert ON TBLCIUDAD TO GerenteLibrary;

GRANT insert ON TBLLIBROPREMIO TO GerenteLibrary;

GRANT insert ON TBLAUTOR TO GerenteLibrary;

GRANT insert ON libros TO GerenteLibrary;

GRANT insert ON Editorial TO GerenteLibrary;

GRANT insert ON Genero TO GerenteLibrary;


--------------------------------------------------------------------------------------------------------


-------------------------------------- INDICES ----------------------------------------------- 

CREATE INDEX tbllibro_titulo ON TBLLIBRO(TITULO);
CREATE INDEX tblpremios_nombre_premio ON TBLPREMIOS(NOMBRE_PREMIO);
CREATE INDEX tbleditorial_nombre ON TBLEDITORIAL(NOMBRE);
CREATE INDEX tblautor_nombre ON TBLAUTOR(NOMBRE);
CREATE UNIQUE INDEX tblnacionalidad_descripcion ON TBLNACIONALIDAD(DESCRIPCION);
CREATE BITMAP INDEX tblgenero_descripcion ON TBLGENERO(DESCRIPCION);

SELECT index_name, 
	index_type, 
	table_name 
FROM all_indexes 
WHERE table_name 
IN ('TBLLIBRO', 
	'TBLPREMIOS', 
	'TBLEDITORIAL', 
	'TBLAUTOR', 
	'TBLNACIONALIDAD', 
	'TBLGENERO');
    
ALTER INDEX tbllibro_titulo MONITORING USAGE;
ALTER INDEX tblpremios_nombre_premio MONITORING USAGE;
ALTER INDEX tbleditorial_nombre MONITORING USAGE;
ALTER INDEX tblautor_nombre MONITORING USAGE;
ALTER INDEX tblnacionalidad_descripcion MONITORING USAGE;
ALTER INDEX tblgenero_descripcion MONITORING USAGE;


SELECT *
FROM v$object_usage
WHERE table_name 
IN ('TBLLIBRO', 
	'TBLPREMIOS', 
	'TBLEDITORIAL', 
	'TBLAUTOR', 
	'TBLNACIONALIDAD', 
	'TBLGENERO');

SELECT *
FROM v$object_usage
WHERE table_name = 'TBLPREMIOS';


EXPLAIN PLAN FOR
SELECT 	l.titulo, 
		l.nropaginas as "numero paginas", 
		g.descripcion as "genero", 
		e.nombre as "editorial", 
		a.nombre as "autor", 
		n.descripcion as "nacionalidad", 
		p.nombre_premio as "nombre premio"

FROM 		TBLLIBRO l 
		JOIN TBLGENERO g ON l.codgenero = g.codigo
		JOIN TBLEDITORIAL e ON l.codeditorial = e.codigo
		JOIN TBLAUTOR a ON l.codautor = a.codigo
		JOIN TBLNACIONALIDAD n ON a.codnacion = n.codigo
		JOIN TBLLIBROPREMIO lp ON l.codigo = lp.codlibro
		JOIN TBLPREMIOS p ON p.codigo = lp.codpremio

WHERE		SUBSTR(l.titulo, 1, 2) = 'El'
		AND g.descripcion IN ('Terror', 'Romance', 'Misterio', 'Comedia')
		AND n.descripcion IN ('Aleman', 'Sueco', 'Frances', 'Ingles')
		AND e.nombre IN ('Elsevier', 'Editorial EU', 'Conichigua', 'Interational EU')
		AND a.nombre IN ('Ana', 'Charles', 'Gabo', 'Wilde')
		AND p.nombre_premio IN ('Nobel', 'Best seller', 'Mejor Comedia', 'Mejor Novela');

-----------------------------------------------------------------------------------------------------------------


SELECT tablespace_name 
FROM all_tables 
WHERE table_name 
IN ('TBLLIBRO');




select * from TBLAUTOR;

show user;




CREATE USER perfiles IDENTIFIED BY santy2002;

GRANT CREATE SESSION, CREATE TABLE, alter any table , insert any table TO
perfiles;

GRANT read any table to perfiles;


select * from USER_ROLE_PRIVS;




