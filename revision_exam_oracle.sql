create table departements(
    id int  primary key ,
    nom_dept varchar(100) not null unique
);
create sequence seq_id_departements start with 1 increment by 1 ; /* pour faire l'auto incrementation cette etape est necessaire */

create table employees(
    id int primary key,
    nom varchar(50),
    prenom varchar(50),
    salaire decimal(10,2),
    poste varchar(50),
    departement_id int,
    foreign key(departement_id) references departements(id)
);

create sequence seq_id_employees start with 1 increment by 1 ;

create table logs(
    id_log int primary key ,
    action_name varchar(255),
    date_action timestamp
);
create sequence seq_id_logs start with 1 increment by 1 ;

insert into departements values(seq_id_departements.nextval,'maths');
insert into employees values(seq_id_employees.nextval,'mjb','nad',10000,'docteur',1);

/* version bloc anonyme */
declare 
nbr_total int ;
begin 
    select count(*) into nbr_total from employees ;
    dbms_output.put_line(nbr_total);
end ;

/* version procedure */
create or replace procedure total_employees is 
nbr_total int;
begin 
    select count(*) into nbr_total from employees ;
    dbms_output.put_line(nbr_total);
end;
        
create or replace procedure total_employees(nbr_total out int ) is
begin 
    select count(*) into nbr_total from employees ; 
end;

create or replace procedure verifier_salaire(emp_id in int) is 
val_sal decimal(10,2);
begin
    select salaire into val_sal from employees where emp_id= id ;
    if(val_sal>2500) then
    dbms_output.put_line('salaire élevé');
    elsif (1500<val_sal) then 
    dbms_output.put_line('salaire moyen');
    else 
    dbms_output.put_line('salaire faire');
    end if;
end;

create or replace function categorie_employee(emp_id in int) return varchar2 is 
val_sal decimal(10,2);
begin 
    select salaire into val_sal from employees where emp_id= id ;
    if(val_sal>=3000) then
    return 'top management';
    elsif (val_sal>2500) then 
    return 'cadre' ;
    elsif (val_sal >=1500) then
    return 'employé';
    else 
    return 'stagiaire' ;
    end if;
end;
/* gestion d'erreur */
create or replace procedure get_salaire_safe(emp_id in int) is 
val_sal employees.salaire%type;
begin
select salaire into val_sal from employees where id=emp_id ;
dbms_output.put_line('le salaire de l employé '||emp_id||' est : '||val_sal);
exception 
when no_data_found then
dbms_output.put_line('Erreur : Aucun employé trouvé avec cet ID');
when others then  
dbms_output.put_line('Erreur : Une erreur sql s est produite');
end;

/* faire un curseur */
declare 
cursor my_cursor is 
select id, nom, prenom, salaire from employees ; /* declaration du curseur */

val_id employees.id%type;
val_nom employees.nom%type;
val_prenom employees.prenom%type;
val_salaire employees.salaire%type;
val_new_sal employees.salaire%type;

begin 
    open my_cursor ;
    loop 
        fetch my_cursor into val_id,val_nom,val_prenom,val_salaire;
        exit when my_cursor%notfound ; 
        val_new_sal := val_salaire * 1.1 ;
        dbms_output.put_line('id '|| val_id ||' nom '||val_nom||' prenom '||val_prenom||' salaire '||val_salaire || ' nouveau salaire '|| val_new_sal);
    end loop;
    close my_cursor ;
end;

insert into employees values(seq_id_employees.nextval,'mbk','sara',900,'vacataire',1);
insert into employees values(seq_id_employees.nextval,'mkh','sara',2800,'prof',1);

declare 
cursor my_cursor is
select id,nom,prenom,salaire from employees ;

val_id employees.id%type;
val_nom employees.nom%type;
val_prenom employees.prenom%type;
val_salaire employees.salaire%type;
val_new_sal employees.salaire%type;

begin 
    open my_cursor ;
    loop 
        fetch my_cursor into val_id,val_nom,val_prenom,val_salaire ;
        exit when my_cursor%notfound ;
        if val_salaire >3000 then 
        val_new_sal := val_salaire ;
        elsif val_salaire >= 2500 and val_salaire<= 3000 then 
        val_new_sal := val_salaire * 1.2 ;
        else 
        val_new_sal := val_salaire * 1.1 ;
        end if;
        update employees set salaire=val_new_sal where id=val_id ;
        dbms_output.put_line('id '|| val_id ||' nom '||val_nom||' prenom '||val_prenom||' salaire '||val_salaire || ' nouveau salaire '|| val_new_sal);
    end loop;
    close my_cursor ;
end;

create or replace trigger before_insert_employes before insert on employees 
for each row 
begin 
    if :new.poste is null then
        :new.poste := 'UNKNOWN' ;
    end if;
end;

insert into employees(id,nom,prenom,salaire,departement_id) values(seq_id_employees.nextval,'mjb','nour',2800,1);


select * from employees;

insert into employees(id,nom,prenom,salaire,departement_id) values(seq_id_employees.nextval,'hhhh','hh',5600,1);

create or replace trigger after_delete_employe after delete on employees 
for each row 
begin 
    insert into logs values(seq_id_logs.nextval,'l emploi d id '|| :old.id ||' a été supprimé avec succès',sysdate);
end;

delete from employees where id=61 ;
select * from logs;

create or replace trigger log_update_salaire after update on employees
for each row
begin
    insert into logs values(seq_id_logs.nextval,'Salaire employé ID'|| :old.id ||' de '|| :old.salaire ||' à '|| :new.salaire, sysdate);
end;

update employees set salaire = 25000 where id=2;
