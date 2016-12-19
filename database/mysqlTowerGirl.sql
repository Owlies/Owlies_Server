drop database if exists towergirl;

create database towergirl;

use towergirl;

drop table if exists user_account;

drop table if exists user_game_info;

create table if not exists  user_account ( user_id varchar(255) NOT NULL, account varchar(255), device varchar(255), facebook_account varchar(255), google_play_account varchar(255), identifier varchar(255), PRIMARY KEY (user_id) );

create table if not exists  user_game_info ( user_id varchar(255) NOT NULL, level int NOT NULL, exp int NOT NULL, game_version varchar(255),  last_login_time timestamp, PRIMARY KEY (user_id) );

insert into user_account (user_id, account, device, facebook_account, google_play_account, identifier) values ("1", "aaa@gmail.com","iphone6","aaa","aaa","00000001");

insert into user_account (user_id, account, device, facebook_account, google_play_account, identifier) values ("2", "bbb@gmail.com","winphone","bbb","bbb","00000002");

insert into user_account (user_id, account, device, facebook_account, google_play_account, identifier) values ("3", "ccc@gmail.com","nexus","ccc","ccc","00000003");

insert into user_game_info (user_id, level, exp, game_version, last_login_time) values ("1",7,30,"1.0",NOW());

insert into user_game_info (user_id, level, exp, game_version, last_login_time) values ("2",6,100,"1.0",NOW());

insert into user_game_info (user_id, level, exp, game_version, last_login_time) values ("3",9,90,"1.0",NOW());
