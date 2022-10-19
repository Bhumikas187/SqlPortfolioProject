--Data to be used
Select location, date, total_cases, new_cases, total_deaths, population
From portfolioproject.coviddeaths
where continent is Not Null
order by 1,2

--Looking at Total Cases vs Total Deaths
--Percentage of population that can die from contracting covid
Select location, date, total_cases, total_deaths, continent, (total_deaths/total_cases)*100 as DeathPercentage
From project1.coviddeaths
where location = "India"
and continent is Not Null
Order By 1,2

--Looking at countries with highest infection rate compared to population

Select location, Population, Max(total_cases) as HighestInfectionRate, Max(total_cases/Population)*100 as PercentPopulationInfected
From project1.coviddeaths
where continent is Not Null
Group By Population, location
Order By PercentPopulationInfected desc

--Showing Countries with highest death count per population
Select Location, Max(cast(total_deaths as Signed)) As TotalDeathCount
From project1.coviddeaths
Where continent is Not Null
Group by Location
Order by TotalDeathCount desc

--breaking down data by continent
Select Location, Max(cast(total_deaths as Signed)) As TotalDeathCount
From project1.coviddeaths
Where continent is Null
Group by location
Order by TotalDeathCount desc

--Showing continents with highest death count with per population

--Global Numbers by date
Select date, Sum(new_cases) As total_cases,Sum(Cast(new_deaths As Signed) As total_deaths,Sum(Cast(new_deaths As Signed))/Sum(new_cases)*100 as DeathPercentage
From portfolioproject.coviddeaths
where continent is Not Null
Group By date
order by 1,2

--global numbers
Select Sum(new_cases) As total_cases,Sum(Cast(new_deaths As Signed) As total_deaths,Sum(Cast(new_deaths As Signed))/Sum(new_cases)*100 as DeathPercentage
From portfolioproject.coviddeaths
where continent is Not Null
order by 1,2

--looking at total population vs total vaccination
--Use cte
With PopvsVac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
As(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(Cast(vac.new_vaccinations As Signed)) Over (Partition By dea.location order by dea.location,dea.date) As RollingPeopleVaccinated
From portfolioproject.coviddeaths dea
Join portfolioproject.covidvaccinations vac
on dea.location = vac.location
and dea.date= vac.date
where dea.continent is Not Null

)
Select* ,(RollingPeopleVaccinated/population)*100
From PopvsVac

--Using Temp Table
Drop Table PercentPopulationvaccinated
Create Temporary Table If Not Exists PercentPopulationvaccinated
(
continent varchar(255) Not Null,
location VarChar(255) Not Null,
date datetime Not Null,
population int Not Null,
new_vaccinations int,
RollingPeopleVaccinated double
)
Insert Into PercentPopulationvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(Cast(vac.new_vaccinations As Signed)) Over (Partition By dea.location order by dea.location, dea.date) As RollingPeopleVaccinated
From portfolioproject.coviddeaths dea
Join portfolioproject.covidvaccinations vac
on dea.location = vac.location
and dea.date= vac.date
where dea.continent is not null

Select* ,(RollingPeopleVaccinated/population)*100
From PercentPopulationvaccinated

--Creating view to store data for visualization
Create View PopvsVac
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(Cast(new_vaccinationns As Signed)) Over (Partion By dea.location order by dea.location, dea.date) As RollingPeopleVaccinated

From portfolioproject.coviddeaths dea
Join portfolioproject.covidvaccinations vac
on dea.location = vac.location
and dea.date= vac.date
where dea.continent is Not Null
--order by 2,3
