/*Criar banco de dados*/

create database db_upa;

use db_upa;

create table tbl_especialidade(
	id_esp int unsigned auto_increment primary key,
	nome_esp varchar(100)Not Null
);

create table tbl_paciente(
	id_paciente int unsigned auto_increment primary key,
	nome_paciente varchar(100)Not Null,
    tel_paciente varchar(10),
    cel_paciente varchar(11) not null,
    nome_responsavel varchar(100)not null,
    tel_responsavel varchar(10)
);

create table tbl_medico(
	id_medico int unsigned auto_increment primary key,
    id_esp int unsigned not null,
	nome_medico varchar(100)Not Null,
    tel_medico varchar(10),
    cel_medico varchar(11) not null,
    
    foreign key(id_esp) references tbl_especialidade(id_esp)
);

create table tbl_insumos(
	id_insumos int unsigned auto_increment primary key,
    id_paciente int unsigned not null,
	nome_insumos varchar(100)Not Null,
    qtde_insumos decimal(10,2),
    
    foreign key(id_paciente) references tbl_paciente(id_paciente)
);

create table tbl_salas(
	id_salas int unsigned auto_increment primary key,
    id_esp int unsigned not null,
	num_salas varchar(10)Not Null,
    
    foreign key(id_esp) references tbl_especialidade(id_esp)
);

create table tbl_agenda(
	id_agenda int unsigned auto_increment primary key,
    id_sala int unsigned not null,
    id_medico int unsigned not null,
    id_paciente int unsigned not null,
	data_cirurgia varchar(10)not null,
    status_cirurgia enum("Agendado", "Concluido", "Cancelado"),
    
    foreign key(id_sala) references tbl_salas(id_salas),
    foreign key(id_medico) references tbl_medico(id_medico),
    foreign key(id_paciente) references tbl_paciente(id_paciente)
);

/*Popular banco de dados*/

insert into tbl_especialidade(nome_esp)
values ('NEUROLOGIA'), ('ORTOPEDIA'), ('CARDIOLOGIA');

insert into tbl_paciente(nome_paciente, tel_paciente, cel_paciente, nome_responsavel, tel_responsavel)
values 
('Alan Armando Velasques', '2587-9635', '2365-5897', 'Rosângela Jimenes Marés', '9748-3737'), 
('Laila Franco de Alvarenga', '2357-9514', '5923-5769', 'David Bernardo Lira', '9860-7481'),
('Alexandre Anakin Cervantes de Saraiva', '2357-2145', '2365-6987', 'Giovanni Hilton Aguiar Espinoza', '9797-6644'),
('Sâmia Thaíssa Barreto Brito de Soares', '2595-2587', '2354-8936', 'Berenice Larissa Franco de Padilha', '9926-3268'),
('Matilde Sara Aragão Ávila de Barboza', '3217-5324', '2587-9122', 'Bianca Delgado', '9671-7161');

insert into tbl_medico(id_esp, nome_medico, tel_medico, cel_medico)
values (1, 'Alexa Paula Ramires Soares Bahia', '1234-5678', '17894-5612'),
(2, 'Anne Guiomar Caldeira', '1234-5678', '27894-5612'),
(3, 'Álvaro Kevin de Duarte', '1234-5678', '27894-5612'),
(2, 'Celina Laura Colaço de Drummond', '1234-5678', '27894-5612');

insert into tbl_salas(num_salas, id_esp)
values  ('01', 1),
('02', 2),
('03', 3);

insert into tbl_agenda(id_sala, id_medico, id_paciente, data_cirurgia, status_cirurgia)
values (1, 1, 1, '2017-09-05 12:00', 'AGENDADO'),
(1, 2, 1, '2017-10-15 13:00', 'AGENDADO'),
(1, 3, 1, '2017-11-01 14:00', 'AGENDADO');

/*criação das views*/

create view listagem_geral AS
select * from tbl_medico;

select * from listagem_geral
where id_medico = 1;
######### LISTAGEM GERAL, AULA 2 CRIAÇÃO DE VIEWS #########
create view listagem_medico as
select 
tm.nome_medico,
tm.tel_medico,
tm.cel_medico,
te.id_esp
from
tbl_medico tm
inner join
tbl_especialidade te 
on tm.id_esp = te.id_esp;


######### LISTAGEM SALA/ESPECIALIDADE #########
create view vw_sala_especilidade as
select 
ts.num_salas,
te.nome_esp
from 
tbl_salas ts
inner join 
tbl_especialidade te
on ts.id_esp = te.id_esp;

######### LISTAGEM AGENDA #########
create view vw_agenda_completa as
select
ta.data_cirurgia, ta.status_cirurgia,
ts.num_salas,
tm.nome_medico, tm.cel_medico,
tp.nome_paciente, tp.cel_paciente, tp.nome_responsavel, tp.tel_responsavel
from tbl_agenda ta
inner join tbl_salas ts
on ta.id_sala = ts.id_salas
inner join tbl_medico tm
on ta.id_medico = tm.id_medico
inner join tbl_paciente tp
on tp.id_paciente = ta.id_paciente;
#####################################

select * from vw_agenda_completa;

######Criando Store Procedures#######

#Procedure sem parametros

delimiter $

create procedure listagem_agenda1()
begin

select
ta.data_cirurgia, ta.status_cirurgia,
ts.num_salas,
tm.nome_medico, tm.cel_medico,
tp.nome_paciente, tp.cel_paciente, tp.nome_responsavel, tp.tel_responsavel
from tbl_agenda ta
inner join tbl_salas ts
on ta.id_sala = ts.id_salas
inner join tbl_medico tm
on ta.id_medico = tm.id_medico
inner join tbl_paciente tp
on tp.id_paciente = ta.id_paciente;

end;

$

call listagem_agenda1();

#Procedure com parametros

delimiter $

create procedure listagem_agenda2(in id_medicoPARAM int)
begin

select
ta.data_cirurgia, ta.status_cirurgia,
ts.num_salas,
tm.nome_medico, tm.cel_medico,
tp.nome_paciente, tp.cel_paciente, tp.nome_responsavel, tp.tel_responsavel
from tbl_agenda ta
inner join tbl_salas ts
on ta.id_sala = ts.id_salas
inner join tbl_medico tm
on ta.id_medico = tm.id_medico
inner join tbl_paciente tp
on tp.id_paciente = ta.id_paciente

where ta.id_medico = id_medicoPARAM;

end;

$
call listagem_agenda2(1);

#Procedure de contagem

create procedure contagem_paciente(out total_pacientes int)
begin

select count(id_paciente) into total_pacientes from tbl_paciente;

end;

$

call contagem_paciente(@total_pacientes);