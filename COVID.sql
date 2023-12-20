
With PopVSVac (continent, location, date,population, new_vaccinations,rollingpeoplevaccinations)
AS
(
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
SUM(CAST(cv.new_vaccinations as int)) OVER (Partition by cd.Location ORDER BY cd.location, cd.date) AS rollingpeoplevaccinations
FROM CovidProject..CovidDeath cd
JOIN CovidProject..CovidVaccinations cv
ON cd.location = cv.location
and cd.date= cv.date
WHERE cd.continent is not null
)


SELECT * 
FROM PopVSVac

DROP TABLE if exists #populationvaccinated
CREATE TABLE #populationvaccinated
(
Continent nvarchar(255),
loaction nvarchar(100),
Date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinations numeric
)

insert into #populationvaccinated
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
SUM(CAST(cv.new_vaccinations as float)) OVER (Partition by cd.Location ORDER BY cd.location, cd.date) AS rollingpeoplevaccinations
FROM CovidProject..CovidDeath cd
JOIN CovidProject..CovidVaccinations cv
ON cd.location = cv.location
and cd.date= cv.date
WHERE cd.continent is not null


SELECT * FROM #populationvaccinated



CREATE VIEW populationvaccinations as
SELECT cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations, 
SUM(CAST(cv.new_vaccinations as float)) OVER (Partition by cd.Location ORDER BY cd.location, cd.date) AS rollingpeoplevaccinations
FROM CovidProject..CovidDeath cd
JOIN CovidProject..CovidVaccinations cv
ON cd.location = cv.location
and cd.date= cv.date
WHERE cd.continent is not null

SELECT * FROM populationvaccinations