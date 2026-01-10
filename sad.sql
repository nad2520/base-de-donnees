create table dep(
    id int primary key ,
    nom_dept varchar(100) not null unique
);
create sequence seq_dep start with 1 increment by 1 ;

create table emp(
    id int primary key,
    nom varchar(50),
    prenom varchar(50),
    salaire decimal(10,2),
    poste varchar(50),
    dep_id int,
    constraint c_fk_idD foreign key(dep_id) references dep(id)
);
create sequence seq_emp start with 1 increment by 1;

create table logz(
    id_log int primary key ,
    action_name varchar(255),
    date_action timestamp
);

create sequence seq_logz start with 1 increment by 1 ;

insert into dep values(seq_dep.nextval,'maths');
insert into dep values(seq_dep.nextval,'phy');
insert into dep values(seq_dep.nextval,'info');

insert into emp values(seq_emp.nextval,'nad','mjb',2500,'cadre',1);
insert into emp values(seq_emp.nextval,'adng','ngz',6000,'prof',2);
insert into emp values(seq_emp.nextval,'nour','mjb',10000,'expert',3);

/* procedure */
create or replace procedure total_employez is 
nb_total int;
begin 
    select count(*) into nb_total from emp;
    dbms_output.put_line('Nombre total employés dans l entreprise : ' || nb_total);
end;
/* appel de la procedure*/
begin 
    total_employez ;
end;

create or replace procedure total_employez(nb_total out int) is
begin
    select count(*)into nb_total from emp;
    dbms_output.put_line('Nombre total emp : ' || nb_total);
end;

declare 
    nb int;
begin 
    total_employez(nb) ;
end;

create or replace procedure verifier_salz(emp_id in int)is 
val_sal emp.salaire%type;
begin 
    select salaire into val_sal from emp where id=emp_id;
    if(val_sal>2500)then
        dbms_output.put_line('salaire elevé');
    elsif(2500>=val_sal and val_sal>1500)then
        dbms_output.put_line('salaire moyen');
    else
        dbms_output.put_line('salaire faible');
    end if;
end;

begin 
    verifier_salz(2);
end;
/* fonction */
create or replace function cat_emp(emp_id in int)return varchar2 is 
val_sal emp.salaire%type;
begin
    select salaire into val_sal from emp where id=emp_id;
    if(val_sal>=3000) then 
        return'top management';
    elsif(val_sal<3000 and val_sal>2500) then 
        return'cadre';
    elsif(val_sal<= 2500 and val_sal>=1500) then 
        return'employé';
    else
        return'stagiaire';
    end if;
end;
/* appel de la fonction */
declare 
ch varchar(30);
begin 
    ch := cat_emp(2);
    dbms_output.put_line(ch);
end;

/* gestion des erreurs */
create or replace procedure get_sal_safe(emp_id in int)is
val_sal emp.salaire%type;
begin 
    select salaire into val_sal from emp where id=emp_id;
    
end;
