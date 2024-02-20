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
    cel_medico varchar(11) not null
);

create table tbl_insumos(
	id_insumos int unsigned auto_increment primary key,
    id_paciente int unsigned not null,
	nome_insumos varchar(100)Not Null,
    qtde_insumos decimal(10,2)
);

create table tbl_salas(
	id_salas int unsigned auto_increment primary key,
    id_esp int unsigned not null,
	num_salas varchar(10)Not Null
);

create table tbl_agenda(
	id_agenda int unsigned auto_increment primary key,
    id_sala int unsigned not null,
    id_medico int unsigned not null,
    id_paciente int unsigned not null,
	data_cirurgia varchar(10)not null,
    status_cirurgia enum("Agendado", "Concluido", "Cancelado")
);

alter table tbl_salas add constraint fk_esp
foreign key (id_esp)
references tbl_especialidade (id_esp);
