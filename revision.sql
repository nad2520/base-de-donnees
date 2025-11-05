create table representation1(
    num_rep number ,
    titre_rep varchar(100),
    ville varchar(100),
    constraint c1 PRIMARY KEY(num_rep)
);

create table musicien1(
    num_mus number ,
    nom varchar(100),
    num_tel varchar(8) UNIQUE,
    num_rep number ,
    constraint c2 PRIMARY KEY(num_mus),
    constraint c3 FOREIGN KEY(num_rep) REFERENCES representation1 
);

create table programmer1(
    date_n DATE ,
    num_rep number ,
    tarif NUMBER(5,2),
    constraint c4 PRIMARY KEY(date_n,num_rep),
    constraint c5 FOREIGN KEY(num_rep) REFERENCES representation1 
);

ALTER TABLE representation1
add constraint ConVille1 CHECK (ville in ('Tunis','Sousse','Tabarka'));

ALTER TABLE musicien1
MODIFY nom VARCHAR(20);

ALTER TABLE programmer1
add CONSTRAINT ConTar1 CHECK(tarif BETWEEN 20 and 50);

ALTER TABLE musicien1
ADD email VARCHAR(100) CHECK ( email like '%@%');

CREATE VIEW V_MuscVille1 AS
SELECT m.num_mus, m.nom, m.num_tel, m.num_rep, r.ville
FROM musicien1 m JOIN representation1 r 
ON r.num_rep=m.num_rep;

DROP VIEW V_MuscVille1;

CREATE INDEX idx_nom
ON musicien1 (nom);

INSERT into representation1 VALUES
    (12,'bonj','Tunis'),
    (2,'hh','Sousse'),
    (3,'jsp','Tabarka');

DELETE from representation1 
WHERE num_rep=12;

SET 
SERVEROUTPUT ON ;
ACCEPT numtel PROMPT 'donner num tel';
DECLARE
    num_tot representation1.num_rep%TYPE;
    titre representation1.titre_rep%TYPE;
BEGIN
    select COUNT (*) into num_tot from representation1  ;
    DBMS_OUTPUT.PUT_LINE("le nombre total est : "|| num_tot);

    select titre_rep into titre from representation1
    WHERE num_rep=23;
    DBMS_OUTPUT.PUT_LINE("voici le titre de la representation 23: "|| titre);

    UPDATE musicien1 
    SET num_tel = '&numtel'
    WHERE num_mus=432 ;
    DBMS_OUTPUT.PUT_LINE(num_tel);
END;
/
