-- #######################################################
-- auto generated ddl-script #############################
-- generated sql creation script for ER model
-- database-##############################################
drop database if exists tennis_modeldb;
create database tennis_modeldb;
use tennis_modeldb;
-- switch autocommit off
set autocommit=0;
-- to allow load data from any directory
set global local_infile=1;
-- tables-################################################
-- table g_gets
create table g_gets(
     g_gets_p_paymentnr varchar(100) not null unique,
     g_gets_p_playernr varchar(100) not null,
     primary key(g_gets_p_paymentnr)
);

-- table i_iscaptain
create table i_iscaptain(
     i_iscaptain_t_teamnr varchar(100) not null unique,
     i_iscaptain_p_playernr varchar(100) not null unique,
     primary key(i_iscaptain_t_teamnr)
);

-- table m_match
create table m_match(
     m_matchnr varchar(100) not null,
     m_lost varchar(100) not null,
     m_won varchar(100),
     primary key(m_matchnr)
);

-- table p_penalty
create table p_penalty(
     p_paymentnr varchar(100) not null,
     p_amount varchar(100) not null,
     p_penaltydate varchar(100) not null,
     primary key(p_paymentnr)
);

-- table p_player
create table p_player(
     p_playernr varchar(100) not null,
     p_yearofbirth varchar(100) not null,
     p_yearjoined varchar(100) not null,
     p_sex varchar(100) not null,
     p_phone varchar(100) not null,
     p_initials varchar(100) not null,
     p_name varchar(100) not null,
     p_postcode varchar(100) not null,
     p_town varchar(100) not null,
     p_street varchar(100) not null,
     p_housenumber varchar(100) not null,
     p_leaguenumber varchar(100),
     primary key(p_playernr)
);

-- table p_plays
create table p_plays(
     p_plays_m_matchnr varchar(100) not null unique,
     p_plays_t_teamnr varchar(100) not null,
     primary key(p_plays_m_matchnr)
);

-- table p_plays_1
create table p_plays_1(
     p_plays_1_m_matchnr varchar(100) not null unique,
     p_plays_1_p_playernr varchar(100) not null,
     primary key(p_plays_1_m_matchnr)
);

-- table t_team
create table t_team(
     t_teamnr varchar(100) not null,
     t_division varchar(100) not null,
     primary key(t_teamnr)
);


-- unique combinations -#################################################

-- foreign keys-#################################################
alter table g_gets
add foreign key (g_gets_p_playernr) references p_player(p_playernr) on delete restrict on update restrict,
add foreign key (g_gets_p_paymentnr) references p_penalty(p_paymentnr) on delete restrict on update restrict;
alter table i_iscaptain
add foreign key (i_iscaptain_p_playernr) references p_player(p_playernr) on delete restrict on update restrict,
add foreign key (i_iscaptain_t_teamnr) references t_team(t_teamnr) on delete restrict on update restrict;
alter table p_plays
add foreign key (p_plays_m_matchnr) references m_match(m_matchnr) on delete restrict on update restrict,
add foreign key (p_plays_t_teamnr) references t_team(t_teamnr) on delete restrict on update restrict;
alter table p_plays_1
add foreign key (p_plays_1_m_matchnr) references m_match(m_matchnr) on delete restrict on update restrict,
add foreign key (p_plays_1_p_playernr) references p_player(p_playernr) on delete restrict on update restrict;
-- commit all changes
commit;