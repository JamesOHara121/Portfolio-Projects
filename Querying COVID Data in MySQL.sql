-- select data I am starting with
select location, date, total_cases, new_cases, total_deaths, population
from coviddeaths
order by 1, 2;

-- what is the likelihood of dying if you contract covid in the UK?
select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as how_likely_to_die
from coviddeaths
where location = "United Kingdom"
order by 1, 2;

-- what percentage of the population has contracted covid?
select location, date, total_cases, population, (total_cases/population)*100 as percent_contracted_covid
from coviddeaths
where location = "United Kingdom"
order by 1, 2;

-- which countries have the highest infection rate compared to their population?
select location, max(total_cases), max(population), (max(total_cases)/max(population))*100 as infected_vs_population
from coviddeaths
group by 1
order by 4 desc;

-- which countries have the highest death count compared to their population?
select location, max(total_deaths), max(population), (max(total_deaths)/max(population))*100 as deaths_vs_population_country
from coviddeaths
group by 1
order by 4 desc;

-- is there a trend between the death rate vs percent aged 65 or older?
-- can later create a scatter plot to show any trends
select dea.location, (max(dea.total_deaths)/max(dea.total_cases))*100 as death_percentage, max(vac.percent_aged_65_older) as percent_aged_65_older
from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
group by dea.location
order by percent_aged_65_older desc;

-- is there a trend between the death rate and female/male smokers?
select dea.location, (max(dea.total_deaths)/max(dea.total_cases))*100 as death_percentage, max(vac.female_smokers) as female_smokers
from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
group by dea.location
order by death_percentage desc;

select dea.location, (max(dea.total_deaths)/max(dea.total_cases))*100 as death_percentage, max(vac.male_smokers) as male_smokers
from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
group by dea.location
order by death_percentage desc;

-- which continents have the highest death count compared to their population?
select continent, max(total_deaths), max(population), (max(total_deaths)/max(population))*100 as deaths_vs_population_continent
from coviddeaths
group by 1
order by 4 desc;

-- total number of cases and deaths in the whole world
select sum(new_cases) as global_cases, sum(new_deaths) as global_deaths, (sum(new_deaths)/sum(new_cases))*100 as global_death_percentage
from coviddeaths;

-- rolling count of new vaccinations
select dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rolling_vaccinations
from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date;

-- rolling vaccinations vs population using common table expression
with vac_vs_pop as (
select dea.location, dea.date, dea.population, vac.new_vaccinations, sum(vac.new_vaccinations) over (partition by dea.location order by dea.location, dea.date) as rolling_vaccinations
from coviddeaths dea
join covidvaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
)
select *, (rolling_vaccinations/population)*100 as percent_vaccinated
from vac_vs_pop
order by location, date;
