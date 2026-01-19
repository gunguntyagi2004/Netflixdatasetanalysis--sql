create database netflix_db ;
use netflix_db ;
drop table if exists netflix_titles;
CREATE TABLE netflix_titles (
    show_id	int,
	type    VARCHAR(10),
	title	VARCHAR(250),
	director VARCHAR(550),
	casts	VARCHAR(1050),
	country	VARCHAR(550),
	date_added	VARCHAR(55),
	release_year	varchar(70),
	rating	VARCHAR(20),
	duration	VARCHAR(40),
	listed_in	VARCHAR(850),
	description VARCHAR(1000)
);

select * from netflix_titles;
select count(*) from netflix_titles;

