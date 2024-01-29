SELECT *
FROM CovidDeaths
WHERE continent is not null
ORDER BY 3,4

SELECT *
FROM CovidVaccination
ORDER BY 3, 4

-- Select data that we are going to be using 

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2

-- Looking at Total Cases per country vs Total Deaths 
-- Shows likelihood of dying if you contracted covid in states

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercent
FROM CovidDeaths
Where location like '%states%'
ORDER BY 1,2

-- Looking at Total Cases vs Population
-- Shows what % of population contracted Covid

SELECT Location, date, population, total_cases, (total_cases/population)*100 AS PercentPopInfection
Where location like '%singapore%'
ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to Population

SELECT Location, Population, MAX(total_cases) AS HighestInfectionCount, Max((total_cases/population))*100 AS PercentPopInfection
FROM CovidDeaths
GROUP BY Location, Population
ORDER BY PercentPopInfection DESC


-- Looking at Countries with Highest Death Count per Population


SELECT Location, Max(cast(total_deaths as int)) As TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount DESC


-- Breaking down by Continents 

SELECT continent, Max(cast(total_deaths as int)) As TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Showing continents with the highest death count per population

SELECT continent, Max(cast(total_deaths as int)) As TotalDeathCount
FROM CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Global Numbers 

SELECT date, SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(New_cases)*100 as DeathPercentage
FROM CovidDeaths
where continent is not null
Group BY [date]
ORDER BY 1,2

SELECT SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(New_cases)*100 as DeathPercentage
FROM CovidDeaths
where continent is not null
ORDER BY 1,2

SELECT *
FROM CovidVaccination

-- Join both tables together
-- Looking at Total Population vs Vaccinations

SELECT *
FROM CovidDeaths dea
Join CovidVaccination vac
    On dea.location = vac.location
    and dea.date = vac.date 


SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM CovidDeaths dea
Join CovidVaccination vac
    On dea.location = vac.location
    and dea.date = vac.date 
    where dea.continent is not null
ORDER BY 2,3

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CAST(vac.new_vaccinations as bigint)) OVER (PARTITION BY dea.location)
FROM CovidDeaths dea
Join CovidVaccination vac
    On dea.location = vac.location
    and dea.date = vac.date 
where dea.continent is not null
ORDER BY 2,3

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea
Join CovidVaccination vac
    On dea.location = vac.location
    and dea.date = vac.date 
where dea.continent is not null
ORDER BY 2,3

-- Option 1 Use CTE

With PopvsVac (Continent, Location, Date, Population, New_vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea
Join CovidVaccination vac
    On dea.location = vac.location
    and dea.date = vac.date 
where dea.continent is not null
--ORDER BY 2,3
)

Select *, (RollingPeopleVaccinated/Population)*100
From PopvsVac

-- Alternative temp table 


DROP TABLE IF exists #PercentPopulationVaccinated
Create table #PercentPopulationVaccinated 
(
Continent NVARCHAR(255), 
Location nvarchar(255), 
Date datetime, 
Population numeric, 
New_vaccinations numeric, 
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea
Join CovidVaccination vac
    On dea.location = vac.location
    and dea.date = vac.date 
--where dea.continent is not null
--ORDER BY 2,3


Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated 


-- Creating View to store data for later visualizations

Create View PercentPopulationVaccinated As 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(bigint,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
FROM CovidDeaths dea
Join CovidVaccination vac
    On dea.location = vac.location
    and dea.date = vac.date 
where dea.continent is not null
--order by 2,3

select *
from PercentPopulationVaccinated
