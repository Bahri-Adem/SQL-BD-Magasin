CREATE TABLE Magasin
(NumMag NUMBER(8)CONSTRAINT pk_numMag PRIMARY KEY,
surface NUMBER(5),
ville VARCHAR2(15) DEFAULT 'Sfax');

CREATE TABLE Produit
(NumProd VARCHAR(5) CONSTRAINT pk_numProd PRIMARY KEY CHECK(NumProd LIKE '%H' OR NumProd LIKE '%G' OR NumProd LIKE '%F'),
Couleur VARCHAR2(10),
QteStock NUMBER(5) CHECK (QteStock>0) NOT NULL,
Désignation VARCHAR2(10) UNIQUE,
Poids NUMBER(7,3) CHECK (Poids BETWEEN 0 AND 1000) ,
NumMag NUMBER(?,
CONSTRAINT fk_numMag FOREIGN  KEY (NumMag) REFERENCES Magasin(NumMag));


CREATE TABLE Commande
(NumCde NUMBER(5) CONSTRAINT pk_numCde PRIMARY KEY, 
DateCde DATE);
CREATE TABLE LigneCde
(NumProd VARCHAR2(5),
NumCde NUMBER(5),
QteCde Number(5),
CONSTRAINT pk_ligneCde PRIMARY KEY(NumProd,NumCde),
CONSTRAINT fk_numProd FOREIGN KEY (NumProd) REFERENCES Produit(NumProd),
CONSTRAINT fk_numCde FOREIGN  KEY (NumCde) REFERENCES Commande(NumCde));

ALTER TABLE Produit
ADD Qtemin NUMBER(5);

ALTER TABLE Produit
MODIFY Désignation VARCHAR2(20);

ALTER TABLE Produit
DROP COLUMN Poids;

ALTER TABLE Produit
ADD CONSTRAINT ck_couleur CHECK(Couleur IN ('Rouge','Bleu','Vert','Jaune','Blanc'));

ALTER TABLE Produit
DROP CONSTRAINT pk_numProd cascade;

ALTER TABLE Produit
ADD CONSTRAINT ck_qtestock CHECK(QteStock>=Qtemin);

ALTER TABLE Produit
ADD CONSTRAINT pk_numProd PRIMARY KEY (Numprod);

ALTER TABLE LigneCde
ADD CONSTRAINT pk_numProd FOREIGN KEY (NumProd) References Produit (NumProd);

ALTER TABLE Commande
ADD CONSTRAINT cK_numcde check ( NumCde<2000 and NumCde>1000);

RENAME   Produit TO Article ;
CREATE SYNONYM LC FOR LigneCde;

Select * From user_constraints where TABLE_name =upper('Article') ;

INSERT INTO Magasin
values (100, 20, 'SEAX');
INSERT INTO Magasin
values (200, 60, 'SOUSSE');
INSERT INTO Magasin
values (300, 20, 'TUNIS');
INSERT INTO Magasin
values (400,NULL, 'SFAX');

INSERT INTO Article
values ('H101', 'Vert', 10, 'CHEMISE10',400,5);
insert into Article
values ('F102', 'Bleu', 15, 'CHEMISEF',400, 10);
insert into Article
values ('H103', 'Bleu',25, 'PANTALONM10', 100, 10);
insert into Article
values ('H104', 'Jaune', 80, 'PULLF128',200,5);
insert into Article
values ('G105', 'Rouge', 100, 'JUPEF114',200, 10);
insert into Article
values ('F106', 'Blanc',15, 'PULLG204',200,5);
insert into Article
values ('G107', 'Blanc', 5, 'CHEMISEH', 400,5);

insert into Commande
values (1200, '16/09/2021');
insert into Commande
values (1201, '16/09/2021');
insert into Commande
values (1202, '18/09/2021');
insert into Commande
values (1203, '21/09/2021');

insert into LigneCde
Values ('H101',1200,6);
insert into LigneCde
Values ('F102',1200,10);
insert into LigneCde
Values ('H104',1201,20);
insert into LigneCde
Values ('F106',1201,15);
insert into LigneCde
Values ('H103',1201,10);
insert into LigneCde
Values ('G105',1202,40);
insert into LigneCde
Values ('F102',1203,5);
insert into LigneCde
Values ('H103',1203,10);
insert into LigneCde
Values ('H104',1203,5);
insert into LigneCde
Values ('G105',1203,8);

CREATE TABLE Client 
(codecl NUMBER(4) constraint pk_codecl primary key,
nomcl char(15),
telephone number(?,
typee char(10));

alter table commande
add codecl number(4) REFERENCES Client(codecl);

insert into Client
Values (10,'AZARO',24587100,'FIDELE');
insert into Client
Values (20,'OMIZ',55248748,'PASSAGER');

CREATE UNIQUE index ind_nomclt ON Client(nomcl);

Update Commande 
SET codecl=(SELECT codecl
            FROM Client
            WHERE nomcl='AZARO')
            WHERE DATECde BETWEEN '14/09/2021' AND '20/09/2021';
Update Commande 
SET codecl=(SELECT codecl
            FROM Client
            WHERE nomcl='OMIZ')
            WHERE DATECde = '21/09/2021'; 
update client
set nomcl='MARAM'
where codecl=10;
delete from commande
where numcde=1202;

/*TP4*/
select numprod
from lignecde
where (numcde=1200) 
intersect
select numprod
from lignecde
where (numcde=1203);

select numprod
from lignecde
group by numprod
having count(*)>=2;

select count(*) as numeroprod ,sum(qtecde) as quantite,numcde
from lignecde
group by numcde
order by numeroprod desc,quantite ;

select numprod
from article
minus 
select numprod
from lignecde;

select numcde
from lignecde
group by numcde
having count(numcde) > 3;

select couleur
from article
where upper(désignation) like '%CHEMISE%';

select sum(qtecde)as som,numprod
from lignecde
group by numprod;

select *
from lignecde
where rownum<=5;

select codecl,nomcl
from client
where upper(nomcl) like 'A%'OR upper(nomcl) like 'M%' or upper(nomcl) like'Z%';

select numprod,couleur,qtestock
from article
where (upper(couleur)='BLEU')and (qtestock>5);

/*TP5*/

select trunc (avg(qtestock))
from article
where numprod like'H%';

select DÉSIGNATION,couleur
from article a join lignecde l on a.numprod=l.numprod
     join commande c on c.numcde=l.numcde
     join client cl on cl.codecl=c.codecl
where extract (year from datecde)='2021'
      and (lower(typee)='fidele');

select désignation
from article a join lignecde l on a.numprod=l.numprod
GROUP BY a.numprod,désignation
having (sum(qtecde))=(select max(sum(qtecde))
                     from lignecde
                     group by numprod);

select m.nummag,count(qtestock) as qtsk
From  magasin m left outer join article a on a.nummag=m.nummag
group by m.nummag
order by qtsk desc;

select numcde
from commande 
group by numcde
minus
select numcde
from lignecde
where upper(numprod) like 'G%';

select substr(numprod,1,1)
from article
where substr(numprod,1,1) in (select substr(numprod,1,1)
                              from article
                              where qtestock between 10 and 100);
                              
select nomcl
from client
where codecl in (select codecl
                from commande
                group by codecl 
                having count(numcde)>2);
                
SELECT numprod,désignation,substr(numprod,1,1)
from article a join magasin m on a.nummag=m.nummag
where upper(ville) like 'SFAX' OR upper(ville) like 'SOUSSE';

select désignation 
from article
where couleur=(select couleur 
               from article
               where UPPER(numprod)  like 'H101');
               
ALTER TABLE article
ADD NbreCde number(5) default(0) ;
update article a
set NbreCde=(select count(numcde)
             from  lignecde l
             where a. numprod = l.numprod
             );
    
ALTER TABLE article
ADD propriete varchar2(10) ;
update article 
set propriete=(substr(désignation,1,3)||couleur);

select nomcl
from article a join lignecde l on a.numprod=l.numprod
     join commande c on c.numcde=l.numcde
     join client cl on cl.codecl=c.codecl
where extract (year from datecde)='2021'
      and extract (month from datecde)='09'
      and upper(substr(a.numprod,1,1))='H'
      and upper(désignation) like 'PANTALON%';

ALTER TABLE article
ADD prix number(9) default 20;

select sum(prix*qtecde) as somme
from article a join lignecde l on a.numprod=l.numprod
group by numcde;

create view ClientPassager
as select *
from client
where rtrim(lower(typee)) like 'passager' ;

select count(*)
from ClientPassager;

insert into  ClientPassager
Values (30,'CARINO',25987611,'FIDELE');

create or replace view ClientPassager
as select *
from client
where rtrim(lower(typee)) like 'passager' 
with check option;

insert into  ClientPassager
Values (40,'CARINYO',27987611,'FIDELE');

select *
from client;

create view ClientClientPassager
as select c.numcde,datecde,nomcl
from commande c join client cl on c.codecl=cl.codecl
where rtrim(lower(typee)) like 'passager' ;

select datecde,count(numcde) as nbr
from ClientClientPassager
group by datecde
order by datecde;

select column_name,updatable,insertable,deletable
from user_updatable_columns
where table_name='CLIENTCLIENTPASSAGER';

update CLIENTCLIENTPASSAGER
set datecde='24/11/2021'
where numcde=1203;

SET SERVEROUTPUT ON ;

DECLARE 
  V_nbreTot NUMBER;
  V_nbreFemme NUMBER;
  V_pourcent NUMBER;
BEGIN
  SELECT COUNT(*) INTO V_nbreTot FROM ARTICLE;
  IF V_nbreTot=0 THEN
    DBMS_OUTPUT.PUT_line('table article vide');
  ELSE
    SELECT COUNT(*) INTO V_nbreFemme FROM ARTICLE
    WHERE UPPER(numprod) LIKE 'F%';
    V_pourcent := V_nbreFemme / V_nbreTot * 100;
    DBMS_OUTPUT.PUT_line('le nombre total d''article est :' || V_nbreTot );
    DBMS_OUTPUT.PUT_line('le nombre d''article Femme est :' || V_nbreFemme );
    DBMS_OUTPUT.PUT_line('le pourcentage des article pour Femme est :' || ROUND(V_pourcent,2) || '%' );
  END IF;
END;


--q2
CREATE OR REPLACE FUNCTION Calculer_Montant(p_numcde COMMANDE.numcde%TYPE)
  RETURN NUMBER IS 
  V_montant NUMBER;
  BEGIN
    SELECT SUM(prix*qtecde) INTO V_montant
    FROM ARTICLE NATURAL JOIN LIGNECDE
    WHERE numcde=p_numcde;
    RETURN V_montant;
END;

SET SERVEROUTPUT ON ;
DECLARE 
  V_mnt NUMBER;
BEGIN
  V_mnt := Calculer_Montant(1200);
  DBMS_OUTPUT.PUT_line('Le montant de la commande est :' || V_mnt );
END;

create or replace procedure afficher_commande (p_nomcl client.nomcl %type)
is 
  cursor c_commande(p_ncl varchar2) is
  select numcde
  from commande natural join client
  where nomcl=p_ncl;
  v_aff commande.numcde%type;
  v_mont number:=0;
begin 
open c_commande(p_nomcl);
loop 
  fetch c_commande into v_aff;
  exit when c_commande%NOTFOUND;
  v_mont:=Calculer_Montant(v_aff);
  DBMS_OUTPUT.PUT_line('Le montant de la commande est :' || v_mont );
  end loop;
  close c_commande;
end;

SET SERVEROUTPUT ON;
BEGIN 
   afficher_commande('MARAM');
end;
create or replace procedure supprimmer_commande (p_codecl client.codecl %type)
is 
  cursor c_commande is
  select numcde
  from commande natural join client
  where codecl=p_codecl
  For Update;
  cursor c_ligne(p_numcde commande.numcde %type) is
  select numcde,numprod
  from lignecde
  where numcde=p_numcde
  For Update;
begin
 for chaquecde in c_commande
   loop 
       for chaqueligne in c_ligne(chaquecde.numcde)
        loop
           DBMS_OUTPUT.PUT_line('La ligne a supprimer est:' || chaqueligne.numcde || '  ' || chaqueligne.numprod);
           delete from lignecde
           where current of c_ligne;
        end loop;
