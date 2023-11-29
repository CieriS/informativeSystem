--Esercitazione 1 - SQL: DDL e DML di base

--ESERCIZIO 1

CREATE TABLE Utenti(
	tessera SMALLINT PRIMARY KEY NOT NULL,
	nome ,
	cognome ,
	telefono ,
);

CREATE TABLE Libri(
	codice ,
	titolo ,
	autori ,
	note DEFAULT NULL
);

CREATE TABLE Prestiti(
	codiceLibro  NOT NULL,
	tessera  NOT NULL,
	data_out  NOT NULL,
	data_in  DEFAULT NULL,
	PRIMARY KEY(codiceLibro, tessera, data_out)
);

CHECK CONSTRAINT 



INSERT INTO Utenti VALUES 
(),
();

INSERT INTO Prestiti VALUES 
(),
();

INSERT INTO Prestiti VALUES 
(),
();

