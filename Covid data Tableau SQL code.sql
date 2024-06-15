-- Below are the SQL queries I used for the Covid data Tableau project
-- Since Tableau Public cannot directly access SQL databases, I copied the results of these queries into Excel and opened the Excel files in Tableau

-- Global death percentage
select sum(new_cases) as global_cases, sum(new_deaths) as global_deaths, (sum(new_deaths)/sum(new_cases))*100 as global_death_percentage
from coviddeaths
where continent is not null;

-- Total death count in each continent
select continent, sum(new_deaths) as total_deaths, (sum(new_deaths)/max(population))*100 as deaths_vs_population_continent
from coviddeaths
where continent not in ("Continent")
group by 1
order by 2 desc;

-- Deaths as a percentage of population in each country
select location, max(total_deaths) as total_deaths, max(population) as population, (max(total_deaths)/max(population))*100 as deaths_vs_population_country
from coviddeaths
where continent is not null;
group by 1
order by 4 desc;

-- Percentage of population infected in each country
select location, population, date, max(total_cases) as highest_infection_count, (max(total_cases)/population)*100 as percent_population_infected
from coviddeaths
group by 1, 2, 3
order by 5 desc;
