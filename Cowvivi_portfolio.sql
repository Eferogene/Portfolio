SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid_deaths
ORDER BY 1, 2;

-- Chances of dying if you contract covid in Nigeria
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as 'death rate'
FROM covid_deaths
WHERE location LIKE '%igeri%'
ORDER BY 1, 2;

-- Total cases vs population
SELECT location, date, population, total_cases, (total_cases/population)* 100 as 'infection rate'
FROM covid_deaths
WHERE location = 'Nigeria'
ORDER BY 1, 2;
 
--  Countries with highest infection rate 
SELECT DISTINCT location, population, max(total_cases) as 'Highest infection count', MAX((total_cases/population))* 100 as 'infection_rate'
FROM covid_deaths
GROUP BY population, location
ORDER BY infection_rate desc;

--  Continents with highest death rate 
SELECT DISTINCT continent,  max(total_deaths) as Totaldeathcount
FROM covid_deaths
GROUP BY continent
ORDER BY Totaldeathcount desc;

-- Places with the most cases
SELECT location, sum(total_cases) as overall_cases from
covid_deaths
 GROUP BY location
ORDER BY  overall_cases DESC;

-- Days wiith the most cases
SELECT date ,  max(total_deaths) as Totaldeathcount
FROM covid_deaths
GROUP BY date
ORDER BY Totaldeathcount desc;

-- Death rate each day
SELECT date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as Death_rate
from covid_deaths
GROUP BY date
ORDER BY 1, 2;

-- Finding overall covid death rate
SELECT sum(new_cases) as total_cases, 
sum(new_deaths) as total_deaths, 
sum(new_deaths)/sum(new_cases)*100 as Death_rate
from covid_deaths
ORDER BY 1, 2;

-- Total population vs Vaccination
SELECT d.continent, d.location, d.date, v.new_vaccinations
  FROM
covid_deaths d
JOIN covid_vaccinations v
ON d.location = v.location
AND d.date = v.date
order by 2,4 desc;


SELECT d.continent, d.location, d.date, v.new_vaccinations,
sum(v.new_vaccinations) OVER
 (PARTITION BY d.location
ORDER BY d.location, d.date) as Summation
FROM covid_deaths d
JOIN covid_vaccinations v
ON d.location = v.location
AND d.date = v.date
order by 2,3 ;

-- use of CTE to allow for further calculations
 WITH PvC(continent, location, date, population, new_vaccinations, summation)
 as
 (
SELECT d.continent, d.location, d.date, d.population, v.new_vaccinations,
sum(v.new_vaccinations) OVER
 (PARTITION BY d.location
ORDER BY d.location, d.date) as Summation
FROM covid_deaths d
JOIN covid_vaccinations v
ON d.location = v.location
AND d.date = v.date

)
SELECT *, (summation/ population)* 100
FROM PvC;

--  storing data for visualization
CREATE VIEW PvNewVac AS
SELECT d.continent, d.location, d.date, v.new_vaccinations,
sum(v.new_vaccinations) OVER
 (PARTITION BY d.location
ORDER BY d.location, d.date) as Summation
FROM covid_deaths d
JOIN covid_vaccinations v
ON d.location = v.location
AND d.date = v.date

