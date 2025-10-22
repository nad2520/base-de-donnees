BEGIN
    dbms_output.PUT_LINE('Bonjour plsql');
end;
/

declare 
    ch varchar(100);
BEGIN
    ch:='Bonjour plsql';
    dbms_output.PUT_LINE(ch);
end;
/ 

declare 
    hauteur INT;
    largeur int;
BEGIN
    hauteur:=10;
    largeur:=5;
    dbms_output.PUT_LINE('lair du rectangle est: ');
    dbms_output.PUT_LINE(hauteur*largeur);
end;
/ 

declare 
    x INT;
BEGIN
    x := 8;
    IF MOD(x,2)=0 THEN 
        dbms_output.PUT_LINE(x||' est pair');
    else
        dbms_output.PUT_LINE(x||' est impair');
    end if;
    
end;
/ 

declare 
    x INT;
    y int;
BEGIN
    x:=10;
    y:=5;
    dbms_output.PUT_LINE('le plus grand est: '||greatest(x,y));
end;
/ 

declare 
    x INT := 5;
    factorielle int := 1;
BEGIN
    for i in 1..x LOOP
        factorielle := factorielle * i;
    end LOOP;
    dbms_output.PUT_LINE('la factorielle est: '||factorielle);
end;
/ 

create table employees(
    id_employee int PRIMARY KEY,
    nom_employee varchar(100),
    salaire int
);

insert into employees VALUES
(1,'Ali',10000),
(2,'Nadine',300000),
(3,'Najwa',400),
(4,'Hayet',3000),
(5,'Badr',9000)
;

DECLARE 
    salaire_moy NUMBER;
BEGIN
    select AVG(salaire) INTO salaire_moy
    FROM EMPLOYEES;
    dbms_output.PUT_LINE('le salaire moyen des employés est '||salaire_moy);
end;
/

DECLARE 
    max_salaire int;
    min_salaire int;
BEGIN
    select MAX(salaire),MIN(salaire) INTO max_salaire, min_salaire
    FROM EMPLOYEES;
    dbms_output.PUT_LINE('le salaire le plus élevé des employés est '||max_salaire);
    dbms_output.PUT_LINE('le salaire le plus bas des employés est '||min_salaire);
end;
/

BEGIN
    update employees 
    set salaire= salaire * 1.1 
    where salaire< (select AVG(salaire)from employees );
    
    for reck in ( select id_employee,nom_employee, salaire from employees) LOOP
        
end;
/
