select * 
from PortfolioProject..CovidDeath
where continent <> ''
order by location


--Data exploration

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeath
order by 1, 2

-- Total cases vs Total death

select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage 
from PortfolioProject..CovidDeath
where location = 'Argentina'
order by 1, 2

--Total cases vs population

SELECT location, date, population, total_cases, (total_cases/population)*100 as PercentageCases
from PortfolioProject..CovidDeath
where location = 'argentina'
order by 1, 2 desc

--Paises con el mayor porcentaje de casos

SELECT location, population, max(total_cases) as MaxTotalCases , max((total_cases/population)*100) as CasesPercentage 
from PortfolioProject..CovidDeath
GROUP BY location, population
order by CasesPercentage desc

--Countries

SELECT location, population, max(total_deaths) as MaxTotalDeath
from PortfolioProject..CovidDeath
where continent <> ''
GROUP BY location,population
ORDER BY MaxTotalDeath desc

--Mostrando las muertes por continente

SELECT location, max(total_deaths) as MaxTotalDeath
from PortfolioProject..CovidDeath
where continent = ''
GROUP BY location
ORDER BY MaxTotalDeath desc

--Globales
SELECT sum(new_cases) as TotalCases, sum(new_deaths) as TotalDeaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeath
WHERE continent <> ''
order by 1,2

--Por día
SELECT date, sum(new_cases) as TotalCasesPerDay, sum(new_deaths) as TotalDeathsPerDay, sum(new_deaths)/sum(new_cases)*100 as DeathPercentage
FROM PortfolioProject..CovidDeath
WHERE continent <> ''
group by date
order by 1,2

--Vaccinations

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	sum(cast(vac.new_vaccinations as float)) over (partition by dea.location order by dea.location, dea.date)
from PortfolioProject..CovidDeath dea
join PortfolioProject..CovidVacinnation vac
	on dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent <> ''
order by 2,3


--Create CTE table

WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS 
(
SELECT dea.continent, dea.location, dea.date, dea.Population, vac.new_vaccinations, 
SUM(CONVERT(FLOAT,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVacinnation vac
	ON dea.location = vac.location
	and dea.date = vac.date
	WHERE dea.continent IS NOT NULL)
SELECT *, RollingPeopleVaccinated/Population*100
FROM PopvsVac

--Create temp table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent varchar(255),
Location varchar(255),
Date datetime,
Population numeric,
New_vaccinations float,
RollingPeopleVaccinated numeric
)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.Population, vac.new_vaccinations, 
SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVacinnation vac
	ON dea.location = vac.location
	and dea.date = vac.date
	--WHERE dea.continent IS NOT NULL
SELECT *, RollingPeopleVaccinated/Population*100
FROM #PercentPopulationVaccinated

--creating views
CREATE VIEW 
PercentPeopleVacunada as
SELECT dea.continent, dea.location, dea.date, dea.Population, vac.new_vaccinations, 
SUM(CONVERT(float,vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM PortfolioProject..CovidDeath dea
JOIN PortfolioProject..CovidVacinnation vac
	ON dea.location = vac.location
	and dea.date = vac.date
WHERE dea.continent IS NOT NULL
--ORDER BY 2,3
