/*
 ============================================================================
 Name        : Creazione Generalità
 Author      : Samuele Cieri s0001060128 - 0001060128 - A1060128
 Version     : 
 Copyright   : 
 Description : Esercitazione 0 - Creazione ed set del mio Schema
 ============================================================================
 */

CREATE SCHEMA A1060128; --creazione mio schema

SET CURRENT SCHEMA A1060128; --setto il mio schema come schema attivo


/*
	Utenti(tessera, nome, cognome, telefono) tessera primary key e nome, cognome e telefono chiave
	Libri(codice, titolo, autori, telefono) pk: Codice; optional: note
	Prestiti(codiceLibro, tessera, dataOut, dataIn) pk: codiceLibro, tessera, dataOut; OPTIONAL: dataIn
*/

CREATE TABLE Utenti(
	tessera INT NOT NULL PRIMARY KEY,
	nome VARCHAR(30) NOT NULL,
	cognome VARCHAR(30) NOT NULL,
	telefono CHAR(15) NOT NULL,
	UNIQUE(nome, cognome, telefono)
);

CREATE TABLE Libri(
	codice INT NOT NULL PRIMARY KEY,
	titolo VARCHAR(100) NOT NULL,
	autori VARCHAR(100) NOT NULL DEFAULT 'Anonimo',	-- Ogni autore separato da virgola
	note VARCHAR(300)
);

CREATE TABLE Prestiti(
	codiceLibro INT NOT NULL,
	tessera INT NOT NULL,
	dataOut DATE NOT NULL,
	dataIn DATE,
	PRIMARY KEY(codiceLibro, tessera, dataOut),
	CONSTRAINT  "Errore Cronologico" CHECK(dataOut <= dataIn),
	--CONSTRAINT  "Inserimento Data Futura" CHECK (dataOut <= CURRENT_DATE), -- CURRENT_DATE non si può usare perché dato dinamico; Per ovviare al problema sarà necessario utilizzare i trigger
	FOREIGN KEY (codiceLibro) REFERENCES Libri(codice) ON DELETE CASCADE ON UPDATE NO ACTION,
	FOREIGN KEY (tessera) REFERENCES Utenti(tessera) ON DELETE CASCADE ON UPDATE NO ACTION
);


/* INSERIMENTI */
--UTENTI - INSERT
INSERT INTO Utenti VALUES --inserimenti corretti
(5, 'Temp', 	'Pers', 	'1111111111'),
(1, 'Samuele', 	'Cieri', 	'1111111111'),
(2, 'Samardo', 	'Cieri', 	'2222222222'),
(3, 'Homer', 	'Simpson', 	'3333333333'),
(4, 'Philip', 	'J. Fry', 	'1111111111');

SELECT * FROM Utenti;

--ERRORE
INSERT INTO Utenti VALUES --provo a violare il vincolo di chiave primaria
(1, 'Eric', 'Cartman', '9999999999');

--ERRORE
INSERT INTO Utenti VALUES --provo a violare il vincolo di chiave
(5, 'Samuele', 'Cieri', '1111111111');

--LIBRI - INSERT
INSERT INTO Libri(codice, titolo, autori, note) VALUES --inserimenti corretti
(0, 'Libro Da Cancellare', DEFAULT, NULL),
(1, 'Il morso del mostro', 'autore1, autore2', NULL),
(2, 'Lie With Statistics', 'John Doe', 'Libro bellissimo'),
(3, 'Il mostro nel cassetto', DEFAULT, 'voto diesci'),
(4, 'Herri Cottaro', 'John Doe', 'ciao ciao caio'),
(5, 'soluzione finale', DEFAULT, NULL),
(6, 'libro finale', 'mr. cagotto', 'Questa è una descrizione importante e mi aspetto di trovare due parole'),
(7, 'Il mostro nel cassetto', DEFAULT, 'Questa è una descrizione importante e mi aspetto di trovare due parole');

SELECT * FROM Libri;

--ERRORE
INSERT INTO Libri(codice, titolo, autori, note) VALUES --provo a violare il vincolo di NOT NULL
(40, 'Il morso del mostro', NULL, NULL);

--PRESTITI - INSERT
INSERT INTO Prestiti VALUES 
(1, 1, '2024-10-16', NULL),
(1, 4, '2024-10-10', CURRENT_DATE), 
(1, 3, '2024-10-15', '2024-10-15'), 
(1, 5, '2022-10-15', NULL), 
(5, 2, '2022-7-15', '2024-7-15'), 
(1, 4, '2022-10-11', NULL), 
(4, 1, '2022-7-15', '2024-7-15'), 
(4, 2, '2018-8-15', NULL),
(3, 3, '2018-10-15', '2019-10-15'),
(3, 4, '2018-10-15', NULL), 
(1, 2, '2024-9-15', NULL),
(1, 4, '2017-10-15', '2019-10-15'),
(1, 2, '2017-10-15', '2019-10-15'),
(5, 1, '2024-9-15', NULL),
(6, 2, '2024-7-15', NULL),
(7, 3, '2024-6-15', NULL),
(7, 4, '2023-5-15', NULL);

INSERT INTO Prestiti VALUES 
(1, 2, '2017-10-18', NULL);

SELECT * FROM Prestiti;

/* ERRORE */
INSERT INTO Prestiti VALUES -- Verifico che il CHECK sia funzionante
(7, 5, '2023-5-15', '2022-5-15'),	-- Dato nullo inseribile
(7, 2, '2023-5-15', NULL);	-- Ordine Cronologico coerente

/* UPDATE */
--U1) Modifica del numero di telefono dell'utente con TESSERA 4
--U2) Aggiunta di una nota al libro di codice 1
--U3) Aggiunta di una data di restituzione a un prestito


--U1)
UPDATE Utenti 	
SET telefono = '4567891202'		-- il numero di Fry diventa questo 
WHERE tessera = 4;			

SELECT * FROM Utenti WHERE tessera = 4; --Verifico abbia funzionato

--U2)
UPDATE Libri 
SET note = 'Nota modificata lesgo' 		-- lA NOTA de 'il morso del mostro' DIVENTA QUESTA
WHERE codice = 1;

SELECT * FROM Libri WHERE codice = 1; --Verifico abbia funzionato

--U2)
UPDATE Prestiti 
SET dataIn = CURRENT_DATE 
WHERE codiceLibro = 1 AND tessera = 5 AND dataOut = '2022-10-15';

SELECT * FROM Prestiti WHERE codiceLibro = 1 AND tessera = 5 AND dataOut = '2022-10-15'; --Verifico abbia funzionato


/* DELETE */
--D1) Cancellazione dell'utente 5 (con verifica dell'effetto)
--D2) Cancellazione del libro con codice 5 (con verifica dell'effetto)

--D1)
DELETE Utenti 
WHERE tessera = 5;

SELECT * FROM Utenti;


--D2)
DELETE Libri 
WHERE Libri.codice = 5;

SELECT * FROM Libri;


/* Interrogazioni */
--Q01) Libri con autore 'John Doe' nel cui titolo compare la parola 'With'
--Q02) Utenti con cognome 'Cieri'
--Q03) Prestiti del 2018 (usare la funzione YEAR)
--Q04) Prestiti in cui la restituzione non è avvenuta lo stesso anno
--Q05) Codici dei libri presi in prestito da un utente, dati nome, cognome e tel
--Q06) Come Q05, ma in un intervallo di tempo
--Q07) Come Q06, ma fornendo tutti i dettagli dei libri
--Q08) Utenti che hanno preso in prestito almeno 2 libri nel 2017
--Q09) Utenti che nel 2017 non hanno preso in prestito nessun libro
--Q10) Utenti che non hanno mai preso in prestito un libro senza autori e che nei commenti include entrambe le parole "descrizione" e "aspetto"

--Q01)
SELECT * 
FROM Libri 
WHERE titolo LIKE '%With%';

--Q02)
SELECT * 
FROM Utenti 
WHERE cognome = 'Cieri';

--Q03)
SELECT * 
FROM Prestiti P
WHERE YEAR(dataOut) = 2018;

--Q04)
SELECT * 
FROM Prestiti P
WHERE YEAR(dataOut) != YEAR(dataiN);

--Q05)
SELECT P.codiceLibro AS "Codici dei libri presi in prestito da tessera 2" 
FROM Utenti U, Prestiti P 
WHERE U.tessera = P.tessera AND U.tessera = 4;

--Q06)
SELECT P.codiceLibro AS "Codici dei libri presi in prestito da tessera 2 tra date comprese" 
FROM Utenti U, Prestiti P 
WHERE U.tessera = P.tessera AND U.tessera = 4 AND (dataOut BETWEEN '2022-01-01' AND '2022-12-31');

--Q07)
SELECT P.codiceLibro AS "Codici dei libri presi in prestito da tessera 2 tra date comprese con tutti i dati dei libri", L.* 
FROM Utenti U, Prestiti P, Libri L 
WHERE U.tessera = P.tessera AND U.tessera = 4 AND (dataOut BETWEEN '2022-01-01' AND '2022-12-31') AND L.codice = P.codiceLibro;

--Q08) Utenti che hanno preso in prestito almeno 2 libri nel 2017
SELECT * 
FROM Utenti U INNER JOIN Prestiti P 
ON U.tessera = P.tessera 
INNER JOIN Libri L 
ON P.codiceLibro = L.codice 
WHERE YEAR(dataOut) = 2017 INTERSECT(
	SELECT *
);

SELECT * 
FROM Utenti U INNER JOIN Prestiti P 
ON U.tessera = P.tessera 
INNER JOIN Libri L 
ON P.codiceLibro = L.codice 
WHERE ;

--Q09)

--Q10)