select location, date, total_cases, new_cases, total_deaths,population
from CovidDeaths
order by 1,2

-- total cases vs total deaths

select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as Deathpercentage
from CovidDeaths
where location LIKE '%states%'
order by 1,2

-- total cases vs population
select location, date, total_cases, population, (total_cases/population)* 100 as Deathpercentage
from CovidDeaths
where location like '%states%'
order by 1,2


--highest infection rate compared to population

select location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population))* 100 as
 PercentPopulationInfected
from CovidDeaths
--where location like '%states%'
group by location, population 
order by PercentPopulationInfected desc


-- break down by continent 

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%states%'
where continent is null 
group by location
order by TotalDeathCount desc

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%states%'
where continent is not null 
group by continent 
order by TotalDeathCount desc


--highest death count per population

select location, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%states%'
where continent is not null 
group by location, population 
order by TotalDeathCount desc


--continents with highest death count

select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from CovidDeaths
--where location like '%states%'
where continent is not null 
group by continent 
order by TotalDeathCount desc



--Global Numbers

select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast
 (new_deaths as int)) / SUM(new_cases)* 100 as Deathpercentage
from PortfolioProject..CovidDeaths 
where continent is not null
--Group by date
order by 1,2


--total population vs vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From portfolioproject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac 
    ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3 


--temp table

DROP table if exists #percentpopulationvaccinated
Create Table #percentpopulationvaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From portfolioproject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac 
    ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3 

select * ,(RollingPeopleVaccinated/population)*100
from #percentpopulationvaccinated


--creating view to store data for later visualisations
create view percentpopulationvaccinated as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
From portfolioproject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac 
    ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

