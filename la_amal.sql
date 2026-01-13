-- 1. Table GENRE
CREATE TABLE Genre (
    GenreID NUMBER PRIMARY KEY,
    LibelleGenre VARCHAR2(100) NOT NULL
);

-- 2. Table AUTEUR
CREATE TABLE Auteur (
    AuteurID NUMBER PRIMARY KEY,
    Nom VARCHAR2(100) NOT NULL,
    Prenom VARCHAR2(100)
);

-- 3. Table CLIENT
CREATE TABLE Clientt (
    ClientID NUMBER PRIMARY KEY,
    NomClient VARCHAR2(100) NOT NULL,
    PrenomClient VARCHAR2(100),
    Adresse VARCHAR2(255),
    CP VARCHAR2(10),       -- VARCHAR2 car un code postal peut commencer par 0 ou contenir des lettres
    Ville VARCHAR2(100)
);

-- 4. Table LIVRE
-- Cette table référence Auteur et Genre
CREATE TABLE Livre (
    ISBN VARCHAR2(20) PRIMARY KEY, -- VARCHAR2 pour gérer les tirets éventuels dans l'ISBN
    Titre VARCHAR2(200) NOT NULL,
    AuteurID NUMBER NOT NULL,      -- Correspond à votre colonne "Auteur#"
    DatePublication DATE,
    GenreID NUMBER NOT NULL,
    CONSTRAINT FK_Livre_Auteur FOREIGN KEY (AuteurID) REFERENCES Auteur(AuteurID),
    CONSTRAINT FK_Livre_Genre FOREIGN KEY (GenreID) REFERENCES Genre(GenreID)
);

-- 5. Table EMPRUNT
-- Cette table référence Livre et Client
CREATE TABLE Emprunt (
    EmpruntID NUMBER PRIMARY KEY,
    ISBN VARCHAR2(20) NOT NULL,
    ClientID NUMBER NOT NULL,
    DateEmprunt DATE DEFAULT SYSDATE NOT NULL, -- Met la date du jour par défaut
    DateRetourPrevu DATE NOT NULL,
    DateRetourEffectif DATE,
    CONSTRAINT FK_Emprunt_Livre FOREIGN KEY (ISBN) REFERENCES Livre(ISBN),
    CONSTRAINT FK_Emprunt_Client FOREIGN KEY (ClientID) REFERENCES Clientt(ClientID)
);

INSERT INTO Genre (GenreID, LibelleGenre) VALUES (1, 'Fantastique');
INSERT INTO Genre (GenreID, LibelleGenre) VALUES (2, 'Policier');
INSERT INTO Genre (GenreID, LibelleGenre) VALUES (3, 'Fantastique');
INSERT INTO Genre (GenreID, LibelleGenre) VALUES (4, 'Classique');

INSERT INTO Auteur (AuteurID, Nom, Prenom) VALUES (101, 'Asimov', 'Isaac');
INSERT INTO Auteur (AuteurID, Nom, Prenom) VALUES (102, 'Christie', 'Agatha');
INSERT INTO Auteur (AuteurID, Nom, Prenom) VALUES (103, 'Hugo', 'Victor');
INSERT INTO Auteur (AuteurID, Nom, Prenom) VALUES (104, 'Rowling', 'J.K.');

-- Livre de Science-Fiction (Genre 1) par Asimov (Auteur 101)
INSERT INTO Livre (ISBN, Titre, AuteurID, DatePublication, GenreID) 
VALUES ('978-0-553-29335-7', 'Fondation', 101, TO_DATE('1951-06-01', 'YYYY-MM-DD'), 1);

-- Livre Policier (Genre 2) par Agatha Christie (Auteur 102)
INSERT INTO Livre (ISBN, Titre, AuteurID, DatePublication, GenreID) 
VALUES ('978-2-7024-4638-9', 'Le Crime de l''Orient-Express', 102, TO_DATE('1934-01-01', 'YYYY-MM-DD'), 2);

-- Livre Classique (Genre 4) par Victor Hugo (Auteur 103)
INSERT INTO Livre (ISBN, Titre, AuteurID, DatePublication, GenreID) 
VALUES ('978-2-253-09633-7', 'Les Misérables', 103, TO_DATE('1862-04-03', 'YYYY-MM-DD'), 4);

-- Livre Fantastique (Genre 3) par J.K. Rowling (Auteur 104)
INSERT INTO Livre (ISBN, Titre, AuteurID, DatePublication, GenreID) 
VALUES ('978-0-7475-3269-6', 'Harry Potter à l''école des sorciers', 104, TO_DATE('1997-06-26', 'YYYY-MM-DD'), 3);


accept genre_d prompt 'genre : '
declare 
nbr_livre number ;
begin 
    select count(*)into nbr_livre from livre l join genre g on l.GenreID=g.GenreID where g.LibelleGenre=genre_d;
    dbms_output.put_line('le nombre de livre de la categorie ' || genre_d ||' : ' || nbr_livre);
end;

accept aut_id prompt 'id : '
declare 
cursor my_cursor is 
select titre from Livre where aut_id=AuteurID ;
titre_c Livre.titre%type;
begin 
    open my_cursor ;
    loop
    fetch my_cursor into titre_c ;
    exit when my_cursor%notfound ;
    dbms_output.put_line('titre '|| titre_c);
    end loop;
    close my_cursor ;
end; 

create table primeClient (
    ClientID number primary key,
    prime number,
    nbrLemp number
);

insert into primeClient(ClientID,nbrLemp)values(
    select ClientID from Emprunt e 
    where e.DateEmprunt='2023'
    group by ClientID ,count(*));

declare 
cursor my_cursor is 
select nbrLemp from primeClient ;

begin

    
        for vc in my_cursor loop
            update primeClient 
            set prime = case 
                when my_cursor.nbrLemp<5 then 0.05 
                when my_cursor.nbrLemp between 10 and 5 then 0.1 
                when my_cursor.nbrLemp>=10 then 0.15 
            end;
        end loop;

end;

declare 
    v_isbn livre.isbn%type;
    v_titre livre.titre%type;
    v_nbrLemp livre.primeClient%type;
begin 
    select isbn,titre,nbrLemp into v_isbn, v_titre, v_nbrLemp from livre l join primeClient p on l.ISBN=p.ISBN
    having max(nbrLemp)=nbrLemp;
end;

create or replace trigger emprunter before update on Emprunt
for each row 
begin
    if :old.DateRetourEffectif is null then 
        raise date_retour_erreur ;
    end if;
    exception 
        when date_retour_erreur then 
        dbms_output.put_line('ya lahwiiii');
        when others then
        dbms_output.put_line('hhhh');
end;


create or replace function nbreLivresEmpruntes(id in number)return number is 
nb_tot number ;
begin 
    select nbrLemp into nb_tot from primeClient where isbn=id;
    return nb_tot;
end;

declare 
nb number;
begin 
    nb := nbreLivresEmpruntes(1023);
    dbms_output.put_line(nb);
end;

create or replace trigger supp_auteur before delete on auteur 
for each row 
begin 
    select count(*)

end;
