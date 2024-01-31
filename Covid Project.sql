
--COVID CASES & DEATHS

SELECT *
FROM CovidDeaths
Order by location

SELECT location, date, total_cases, new_cases, total_deaths, new_deaths, population
FROM CovidDeaths
Order by location, date

-- total cases vs total deaths for UK
SELECT location, date, total_cases, total_deaths,total_deaths/total_cases as DeathRate
FROM CovidDeaths
WHERE location = 'United Kingdom'
ORDER BY date

--total cases vs populataion for UK
SELECT location, date, population, total_cases, total_cases/population as CovidPercentage
FROM CovidDeaths
WHERE location = 'United Kingdom'
ORDER BY date

--total deaths vs populataion for UK
SELECT location, date, population, total_deaths, total_deaths/population as DeathPercentage
FROM CovidDeaths
WHERE location = 'United Kingdom'
ORDER BY date

-- countries with highest case count
SELECT location, population, MAX(total_cases) AS HighestCaseCount, MAX(total_cases/population)*100 AS CovidPercentage
FROM CovidDeaths
GROUP BY location, population
ORDER BY CovidPercentage DESC

--countries with highest death count
SELECT location, population, MAX(total_deaths) AS TotalDeathCount, MAX(total_deaths/population)*100 AS DeathPercentage
FROM CovidDeaths
GROUP BY location, population
ORDER BY DeathPercentage DESC

--continents with highest death count
SELECT continent, MAX(total_deaths) AS TotalDeathCount, MAX(total_deaths/population)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent
ORDER BY TotalDeathCount DESC

--global cases & deaths by date
SELECT date, SUM(new_cases) AS totalcases, SUM(new_deaths) AS totaldeaths, (SUM(new_deaths)/SUM(new_cases))*100 AS deathpercentage
FROM CovidDeaths
GROUP BY date
ORDER BY date


--COVID VACCINATIONS

SELECT *
FROM CovidVaccinations


SELECT *
FROM CovidDeaths AS cd
JOIN CovidVaccinations AS cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent IS NOT NULL

--population vs vaccination
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CONVERT(bigint, cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS TotalPeopleVaccinated
FROM CovidDeaths AS cd
JOIN CovidVaccinations AS cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent IS NOT NULL
ORDER BY location, date;

--percentage of population vs vaccination (using CTE)
WITH totalpeoplevacc (continent, location, date, population, new_vaccinations, TotalPeopleVaccinated) AS (
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations,
SUM(CONVERT(bigint, cv.new_vaccinations)) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS PeopleVaccinated
FROM CovidDeaths AS cd
JOIN CovidVaccinations AS cv
ON cd.location = cv.location
AND cd.date = cv.date
WHERE cd.continent IS NOT NULL)
SELECT *, (TotalPeopleVaccinated/population)*100 AS PercentPeopleVaccinated
FROM totalpeoplevacc
ORDER BY location, date