create table representationn(
    numRep int,
    titre varchar(100),
    ville varchar(100),
    CONSTRAINT c_numRep PRIMARY KEY(numRep)
);

create table musicienn(
    numMus int,
    nom varchar(100),
    numTel varchar(8) UNIQUE,
    numRep int ,
    CONSTRAINT c_numRepFK FOREIGN KEY(numRep) REFERENCES representationn(numRep)
);

create table programmerr(
    dateP date,
    numRep int,
    tarif int,
    CONSTRAINT c_numRepFK1 FOREIGN KEY(numRep) REFERENCES representationn(numRep),
    CONSTRAINT c_numRepPK PRIMARY KEY(numRep,dateP)
);

ALTER TABLE representationn
ADD CONSTRAINT ConVille CHECK (ville in('Tunis','Sousse','Tabarka'));

ALTER TABLE programmerr
ADD CONSTRAINT ConTar CHECK(tarif BETWEEN 20 and 50);

ALTER TABLE musicienn 
ADD email VARCHAR(100) CHECK( email LIKE '%@%');

CREATE VIEW V_MuscVille AS 
SELECT m.numMus, m.nom, m.numTel, m.numRep, r.ville 
FROM musicienn m join representationn r 
ON r.numRep=m.numRep;

SET 
SERVEROUTPUT ON;

DECLARE
    nombreTtotal NUMBER ;
    titreRepresentation REPRESENTATIONN.titre%TYPE;
    NEWnumTel := '&nouveau num tel :';
BEGIN
    SELECT COUNT(*) INTO nombreTtotal FROM REPRESENTATIONN;
    DBMS_OUTPUT.PUT_LINE('le nombre de representations est : ' || nombreTtotal );

    SELECT titre INTO titreRepresentation FROM REPRESENTATIONN 
    WHERE numRep = 23 ;
    DBMS_OUTPUT.PUT_LINE('le titre de la representation num 23 est : ' || titreRepresentation);

    UPDATE musicienn 
    SET numTel = NEWnumTel 
    WHERE numMus= 432;
    DBMS_OUTPUT.PUT_LINE('le nouveau numero de telephone est : '|| numTel);
END;
/
