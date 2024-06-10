-- With data files as large as these, the MySQL import wizard was slow to import the data and contained many errors
-- Therefore, I had to find a different way to import the data into MySQL - using 'load data infile'

-- create covid deaths table
create table coviddeaths (
iso_code text,
continent text,
location text,
date datetime,
population int,
total_cases int,
new_cases int,
total_deaths int,
new_deaths int,
icu_patients int,
hosp_patients int,
weekly_icu_admissions int,
weekly_hosp_admissions int
);

-- check the columns were created correctly
select * from
coviddeaths;

-- import data from the csv file
load data infile 'CovidDeaths2.csv'
into table coviddeaths
fields terminated by ','
ignore 1 lines;

-- date column should have been 'date' datatype rather than 'datetime'
alter table coviddeaths
modify column date date;

-- some values in population > 2,147,483,647 which is the maximum allowed for 'int' datatype. modified to 'bigint'.
alter table coviddeaths
modify column population bigint;

-- check the number of records is correct
select count(iso_code)
from coviddeaths;

-- check data in the table looks right
select *
from coviddeaths;

-- create covid vaccinations table
create table covidvaccinations (
iso_code text,
continent text,
location text,
date date,
population bigint,
total_tests int,
new_tests int,
total_vaccinations int,
new_vaccinations int,
people_vaccinated int,
people_fully_vaccinated int,
total_boosters int,
median_age decimal,
percent_aged_65_older decimal,
gdp_per_capita decimal,
female_smokers decimal,
male_smokers decimal,
life_expectancy decimal
);

-- repeat the same process to import the covid vaccinations data
select *
from covidvaccinations;

load data infile 'CovidVaccinations.csv'
into table covidvaccinations
fields terminated by ','
ignore 1 lines;

-- this time a few more of the columns need to have 'bigint' datatype
alter table covidvaccinations
modify column total_vaccinations bigint;

alter table covidvaccinations
modify column people_vaccinated bigint;

alter table covidvaccinations
modify column people_fully_vaccinated bigint;

alter table covidvaccinations
modify column total_tests bigint;

alter table covidvaccinations
modify column total_boosters bigint;

select count(iso_code)
from covidvaccinations;

select *
from covidvaccinations;
-- noticed that the decimal columns are not displaying the digits after decimal point

-- determine whether this was due to data being incorrectly imported or MySQL just showing rounded numbers in the table
select gdp_per_capita/median_age
from covidvaccinations;
-- result grid shows 94.9474 for the first few rows in the table. it should show 96.9885. data has been imported incorrectly

-- need to change the scale for the decimal columns
alter table covidvaccinations
modify column median_age decimal(10,1);

alter table covidvaccinations
modify column percent_aged_65_older decimal(10,3);

alter table covidvaccinations
modify column gdp_per_capita decimal(10,3);

alter table covidvaccinations
modify column female_smokers decimal(10,1);

alter table covidvaccinations
modify column male_smokers decimal(10,1);

alter table covidvaccinations
modify column life_expectancy decimal(10,2);

-- delete all data from the table
delete from covidvaccinations;

-- imported the data again using the same 'load data infile' command above
-- all looks good now