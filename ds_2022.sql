create table agence(
    numAgence int PRIMARY KEY,
    nom varchar(100),
    ville varchar(100),
    actif VARCHAR(100) CHECK(actif in ('asset' , 'idle'))
);

create table client(
    numClient int PRIMARY KEY,
    nomc varchar(100),
    prenomc varchar(100),
    villec varchar(100),
    email VARCHAR(100) CHECK(email like '%@%')
);

create table compte(
    numCompte int PRIMARY KEY,
    numAgence int,
    numClient int,
    solde NUMBER(10,2) NOT NULL,
    foreign key(numAgence) references agence(numAgence) ON DELETE CASCADE,
    foreign key(numClient) references client(numClient) ON DELETE CASCADE
);

ALTER TABLE agence 
ADD CONSTRAINT ConVille 
CHECK (ville in('Tunis','Sousse','Tabarka'));

ALTER TABLE compte
ADD CONSTRAINT ConTar 
CHECK ( solde > 100);

ALTER TABLE client 
ADD telephone NUMBER(8,0) UNIQUE ;

CREATE VIEW V_ClientSolde AS
SELECT c.numClient, c.nomc, c.prenomc, c.villec, c.email, co.NumCompte, co.solde 
from compte co join client c
on c.numClient=co.numClient ;

DECLARE
    nb_total_client int;
    BEGIN
        select count(*) into nb_total_client from client ;
        DBMS_OUTPUT.PUT_LINE('le nombre total des clients de toutes les agences est : ' || nb_total_client);
    END;
/

DECLARE
    solde_compte NUMBER ;
    BEGIN
        SELECT solde into solde_compte from compte
        WHERE numCompte = 2563;
        DBMS_OUTPUT.PUT_LINE('le solde du compte 2563 est : ' || solde_compte);
    END;
/
