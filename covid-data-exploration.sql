/*
Covid 19 Data Exploration 
Skills used:   Aggregate Functions, Windows Functions, Joins, CTE's, 
*/



--1 covid_deaths and covid_vaccinations 

select * from covid.covid_deaths 
where continent is not null
order by 3, 4;

select * from covid.covid_vaccinations 
order by 3, 4;

--2 select data that we are going to starting with 

select location,date,total_cases,new_cases,total_deaths,population 
from covid.covid_deaths
where continent is not null
order by 1,2; 

--3 total cases vs total deaths 
--shows likelihood of dying if you contract covid in your country 

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as death_percentage
from covid.covid_deaths
where location like '%erman%' and continent is not null
order by 1,2;


--4 total cases vs population
--shows what percentage of population infected with covid 

select location,date,population,total_cases, (total_cases/population)*100 as percent_population_infected
from covid.covid_deaths
where continent is not null
order by 1,2;

--5) countries with highest infection rate compared to popultaion

select location,population,max(total_cases) as highest_infectedcount, max((total_cases/population))*100 as percent_population_infected
from covid.covid_deaths
where continent is not null
group by location, population
order by percent_population_infected desc;


--6)showing countries with highest death count per population

select location,sum(new_deaths) as total_deathcount
from covid.covid_deaths
where continent is not null
group by location
order by total_deathcount desc;


--7) first 3 countries with  highest death count

select location, sum(new_deaths) as num_of_deaths from covid.covid_deaths
where continent is not null
group by location
order by num_of_deaths desc  
limit 3;

--8) second largest death count country 
select location, sum(new_deaths) as num_of_deaths from covid.covid_deaths
where continent is not null
group by location
order by num_of_deaths desc  
limit 1 offset 1;


--9)lowest death count country

select location, ifnull(sum(new_deaths), 0) as total_deaths from covid.covid_deaths
where continent is not null 
group by location
order by total_deaths 
limit 1 ;


--10) showing continents with highest death count 

select continent,max(total_deaths) as total_deathcount
from covid.covid_deaths
where continent is not null
group by continent
order by total_deathcount desc;


--11) total number of icu patients in each countries of Europe

select location, sum(icu_patients) as total_icupatients from covid.covid_deaths 
where continent= 'Europe'
group by location
order by total_icupatients desc;


--12) Global Numbers

select sum(new_cases) as total_cases , sum(new_deaths) as total_deaths , (sum(new_deaths)/sum(new_cases))*100 as death_percentage
from covid.covid_deaths
where continent is not null
order by 1,2;


--13) join two tables vaccination and deaths

select * 
from covid.covid_deaths cd
join covid.covid_vaccinations cv
on cd.location = cv.location
and cd.date = cv.date;

--14) total poulation vs total vaccinations 

WITH popvsvac  
AS
  (
  select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
  sum(new_vaccinations) over (partition by cd.location order by cd.location, cd.date ) as rollingpeople_vaccinated
  from covid.covid_deaths cd
  join covid.covid_vaccinations cv
  on cd.location = cv.location
  and cd.date = cv.date 
  where cd.continent is not null
  ---order by 2,3
  )
select *, (rollingpeople_vaccinated/ population)* 100 from popvsvac
