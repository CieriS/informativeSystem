/*
 ============================================================================
 Name        : 
 Author      : Samuele Cieri 0001060128
 Version     :
 Copyright   : 
 Description : 
 ============================================================================
 */
 
--DB2 DBMain
--Esercitazione 1 - SQL: DDL e DML di base

--ESERCIZIO 1

CREATE TABLE Utenti(
	tessera SMALLINT PRIMARY KEY NOT NULL,
	nome VARCHAR(15) NOT NULL,
	cognome VARCHAR(15) NOT NULL,
	telefono CHAR(10) NOT NULL,
	UNIQUE(nome, cognome, telefono),
	CONSTRAINT telefonoValido CHECK (LEN(telefono) = 10),
	CONSTRAINT isNumericTessera CHECK (ISNUMERIC(tessera) = 1)
);

INSERT INTO Utenti VALUES 
(0, "Brad", "Pitt", "2545455454"),
(1, "Philip", "J. Fry", "3895724838"),
(2, "Bender", "Rodriguez", "228941742"),
(3, "Homer", "Simpson", "3762385321"),
(4, "Eric", "Cartman", "3445837561");

CREATE TABLE Libri(
	codice CHAR(3) PRIMARY KEY NOT NULL,
	titolo VARCHAR(50) NOT NULL,
	autori VARCHAR(75) NOT NULL DEFAULT "Anonimo",
	note VARCHAR(300) DEFAULT NULL
);

INSERT INTO Libri VALUES 
("Y", "il cromosoma x", DEFAULT, NULL),
("P01", "Il libro della Giungla", "Peppino", NULL),
("P02", "Avventura spaziale", "Francesco", NULL),
("P03", "il Ritorno and jr", DEFAULT, NULL),
("P04", "L'attacco il and dei giganti", "Norberto, Giovanni", NULL),
("P05", "La scoperta del medioevo", "Solvina", NULL),
("P06", "Economia Circolare", DEFAULT, NULL),
("P07", "Trave W Parallela", "Z", NULL),
("P08", "Riunione il and Straordinaria!", "Troverzi", NULL),
("P09", "Ormai è così...", "Z", NULL),
("P10", "Il serpente è il re della giungla", "Lotrato", NULL);

CREATE TABLE Prestiti(
	codiceLibro CHAR(3) NOT NULL,
	tessera SMALLINT NOT NULL,
	data_out DATE NOT NULL,
	data_in DATE DEFAULT NULL,
	PRIMARY KEY(codiceLibro, tessera, data_out),
	FOREIGN KEY codiceLibro REFERENCES Libri(codice) ON UPDATE NO ACTION ON DELETE CASCADE,
	FOREIGN KEY tessera REFERENCES Utenti(tessera) ON UPDATE NO ACTION ON DELETE CASCADE,
	CONSTRAINT validateDates CHECK ((data_out >= data_in) OR (data_in IS NULL AND data_out IS NOT NULL))
);

INSERT INTO Prestiti VALUES 
("Y", 4, '01.04.2018', NULL),
("Y", 3, '11.03.2018', NULL),
("Y", 2, '15.09.2018', NULL),
("Y", 1, '17.07.2018', NULL),
("Y", 4, '10.04.2018', '10.04.2018'),
("P04", 4, '01.04.2018', '10.04.2019'),
("P05", 4, '01.04.2018', '10.04.2019'),
("P06", 4, '01.04.2018', '10.04.2019'),
("P07", 4, '01.04.2018', '10.04.2019'),
("P08", 1, '01.04.2017', '10.04.2019'),
("P09", 4, '01.04.2017', '10.04.2019'),
("P01", 4, '01.04.2017', '10.04.2019'),
("P02", 3, '01.04.2017', '10.04.2019'),
("P03", 3, '01.04.2017', '10.04.2019'),
("P05", 2, '01.04.2017', '10.04.2019'),
("P04", 2, '01.04.2017', '10.04.2019'),
("P01", 2, '01.04.2017', '10.04.2019'),
("P02", 2, '01.04.2017', '10.04.2019'),
("P07", 2, '01.04.2017', '10.04.2019'),
("P08", 3, '01.04.2017', '10.04.2019'),
("P09", 3, '01.04.2017', '10.04.2019');

--WRONG INSERTION Utenti
INSERT INTO Utenti VALUES ('3', 'Luca', 'Rossi', '123456789');
INSERT INTO Utenti VALUES (7, 'Luca', 'Rossi', '123456789');
INSERT INTO Libri VALUES ('3', NULL, 'Rossi', '123456789');

--UPDATE
--U1) Modifica del numero di telefono dell’utente con tessera X (a scelta)
UPDATE Utente 
SET telefono = "3333333333" 
WHERE tessera = 3;
--U2) Aggiunta di una nota al libro di codice Y
UPDATE Libri 
SET note = "Questo libro è un capolavoro 5 stelle" 
WHERE codice LIKE "p10";
--U3) Aggiunta della data di restituzione a un prestito
UPDATE Prestiti 
SET data_in = '21.12.2018' 
WHERE codice LIKE "p10";

--DELETE
--D1) Cancellazione di un utente X (verificare l’effetto)
DELETE Utenti 
WHERE codice = 0;

--D2) Cancellazione del libro con codice Y (verificare l’effetto)
DELETE Libri 
WHERE codice LIKE "y";

--QUERIES
--Q1) Libri con autore Z e nel cui titolo compare la parola W
SELECT codice, titolo, autori, note  
FROM Libri  
WHERE titolo LIKE "%Il%";

--Q2) Utenti con un dato cognome
SELECT nome, cognome  
FROM Utenti 
WHERE cognome LIKE "cartman";

--Q3) Prestiti del 2018 (usare la funzione YEAR)
SELECT * 
FROM Prestiti 
WHERE YEAR(data_prestito) = 2018;

--Q4) Prestiti in cui la restituzione non è avvenuta lo stesso anno
SELECT * 
FROM Prestiti 
WHERE YEAR(data_out) != YEAR(data_in);

--Q5) Codici dei libri presi in prestito da un utente, dati nome, cognome e tel
SELECT P.codiceLibro AS Codice, U.nome AS Nome, U.cognome AS Cognome, U.telefono AS Telefono 
FROM Prestiti AS P INNER JOIN Utenti AS U 
ON P.tessera = U.tessera 
WHERE U.name LIKE "Philip";

--Q6) Come Q5, ma in un certo intervallo di tempo
SELECT P.codiceLibro AS Codice, U.nome AS Nome, U.cognome AS Cognome, U.telefono AS Telefono 
FROM Prestiti AS P INNER JOIN Utenti AS U 
ON P.tessera = U.tessera 
WHERE U.name LIKE "Philip" AND (BETWEEN '01.01.2018' AND '01.01.2019');

--Q7) Come Q6, ma fornendo tutti i dettagli dei libri
SELECT L.*, U.nome AS Nome, U.cognome AS Cognome, U.telefono AS Telefono 
FROM Prestiti AS P INNER JOIN Utenti AS U 
ON P.tessera = U.tessera 
INNER JOIN Libri AS L 
ON L.codice = P.codiceLibro 
WHERE U.name LIKE "Philip" AND (BETWEEN '01.01.2018' AND '01.01.2019');

--Q8) Utenti che hanno preso in prestito almeno 2 libri nel 2017
SELECT U.tessera, U.nome, U.cognome, COUNT(*) 
FROM Utenti AS U INNER JOIN Prestiti AS P 
ON U.tessera = P.tessera 
WHERE YEAR(data_out) = 2017 
GROUP BY U.tessera, U.nome, U.cognome 
HAVING COUNT(*) >= 2;


--Q9) Utenti che nel 2017 non hanno preso in prestito nessun libro
SELECT * 
FROM Utenti AS U2 
WHERE U2.tessera = ANY(
	SELECT U.tessera 
	FROM Utenti AS U LEFT JOIN Prestiti AS P 
	ON U.tessera = P.tessera 
	WHERE YEAR(DATA_OUT) != 2017 
	GROUP BY U.tessera 
	HAVING COUNT(*) = 0
	);

--Q10) Utenti che non hanno mai preso in prestito un libro senza autori e che nei commenti include entrambe le parole H e J (a scelta)
SELECT U.* 
FROM Utenti AS U LEFT JOIN Prestiti as P 
ON U.tessera = P.tessera 
WHERE codiceLibro != ALL(
	SELECT L0.codice 
	FROM Libri AS L0 
	WHERE autori LIKE "anonimo" AND (note LIKE "and" AND note LIKE "IL")
	); 