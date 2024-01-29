SELECT *
FROM TutorialDB.dbo.EmployeeDemographics

SELECT JobTitle, Max(Salary)
FROM TutorialDB.dbo.EmployeeDemographics
Inner Join TutorialDb.dbo.EmployeeSalary
    ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
WHERE JobTitle = 'Salesman'
GROUP BY JobTitle


SELECT FirstName, LastName, Age,
CASE  
    WHEN AGE > 30 THEN 'Sta'
    WHEN AGE BETWEEN 27 and 30 THEN 'Young'
    ELSE 'Baby'
END
From TutorialDB.dbo.EmployeeDemographics
WHERE AGE is not NULL
ORDER BY Age


SELECT FirstName, LastName, JobTitle, Salary,
CASE 
    WHEN JobTitle = 'Salesman' THEN Salary + (Salary * .10)
    WHEN JobTitle = 'Marketing' THEN Salary + (Salary * .05)
    ELSE Salary + (Salary *0.03)
END AS AdjSalary
FROM TutorialDB.dbo.EmployeeDemographics
JOIN TutorialDB.dbo.EmployeeSalary 
    ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID


SELECT JobTitle, AVG(Salary)
FROM TutorialDB.dbo.EmployeeDemographics
JOIN TutorialDB.dbo.EmployeeSalary 
    ON EmployeeDemographics.EmployeeID = EmployeeSalary.EmployeeID
GROUP BY JobTitle
HAVING AVG(Salary) > 30000
ORDER BY AVG(Salary)


SELECT *
FROM TutorialDB.dbo.EmployeeDemographics

UPDATE TutorialDB.dbo.EmployeeDemographics
SET EMPLOYEEID = 1030
WHERE FirstName = 'Apple'


SELECT * 
FROM TutorialDB.dbo.EmployeeDemographics
WHERE EmployeeID = 1001


SELECT Demo.EmployeeID, Sal.Salary
FROM TutorialDB.dbo.EmployeeDemographics AS Demo
JOIN TutorialDb.dbo.EmployeeSalary AS Sal
    On Demo.EmployeeID = Sal.EmployeeID


SELECT FirstName, LastName, Gender, Salary
, COUNT(Gender) OVER (PARTITION BY Gender) as TotalGender
FROM TutorialDB.dbo.EmployeeDemographics dem
JOIN TutorialDB.dbo.EmployeeSalary sal
    ON dem.EmployeeID = sal.EmployeeID

SELECT Gender, COUNT(Gender)
FROM TutorialDB.dbo.EmployeeDemographics dem
JOIN TutorialDB.dbo.EmployeeSalary sal
    ON dem.EmployeeID = sal.EmployeeID
GROUP BY Gender



CREATE TABLE #temp_Employee 
(EmployeeID int,
JobTitle varchar (100),
Salary int
)

SELECT *
FROM #temp_Employee

INSERT INTO #temp_Employee VALUES (
    '1001', 'HR', '45000'
)

INSERT INTO #temp_Employee
SELECT *
FROM TutorialDB..EmployeeSalary


DROP TABLE IF EXISTS #TEMP_employee3
CREATE TABLE #temp_Employee3 (
JobTitle varchar(50),
EmployeesPerJob int,
AvgAge varchar(50),
AvgSalary int
)

INSERT INTO #temp_Employee2
SELECT JobTitle, COUNT(JobTitle), AVG(age), Avg(Salary)
FROM TutorialDB.dbo.EmployeeDemographics emp
JOIN TutorialDB.dbo.EmployeeSalary sal
    ON emp.EmployeeID = sal.EmployeeID
GROUP BY JobTitle

SELECT *
FROM #temp_Employee3


CREATE TABLE EmployeeErrors (
    EmployeeID varchar(50),
    FirstName varchar(50),
    LastName varchar(50)
)

INSERT INTO EmployeeErrors VALUES
('1001 ', 'Jimbo', 'Halbert'),
('   1002', 'Pamela', 'Beasely'),
('1005', 'TOby', 'Flenderson - Fired')

Select *
From EmployeeErrors


-- Using Trim, LTRIM, RTRIM 

Select EmployeeID, TRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors

Select EmployeeID, LTRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors

Select EmployeeID, RTRIM(EmployeeID) as IDTRIM
FROM EmployeeErrors

-- Using Replace 

Select LastName, REPLACE(LastName, '- Fired', '') as LastNameFixed
FROM EmployeeErrors

-- Using Substring 

Select SUBSTRING(FirstName,3,3)
FROM EmployeeErrors

Select err.FirstName, dem.FirstName
From EmployeeErrors err
JOIN EmployeeDemographics dem
    ON err.FirstName = dem.FirstName


SELECT FirstName, UPPER (FirstName)
FROM EmployeeErrors



-- Stored Procedures 

CREATE PROCEDURE TEST
AS
Select *
From EmployeeDemographics


EXEC TEST

CREATE PROCEDURE temp_Employee
AS
CREATE table #temp_employee (
JobTitle varchar(100),
EmployeesPerJob int,
)

Insert into temp_Employee
Select JobTitle, Count(JobTitle), Avg(Age), Avg(Salary)
FROM TutorialDB..EmployeeDemographics emp
JOIN TutorialDB..EmployeeSalary sal
    ON emp.EmployeeID = sal.EmployeeID
GROUP By JobTitle

Select * 
From #temp_employee




Select *
From EmployeeSalary

-- Subquery in Select

Select EmployeeID, Salary, (Select AVG(Salary) From EmployeeSalary) AS AllAvg
From EmployeeSalary

-- Partition By

Select EmployeeID, Salary, AVG(Salary) over () AS AllAvgSalary
From EmployeeSalary

Select EmployeeID, Salary, AVG(Salary) AS AllAvgSalary
From EmployeeSalary
Group by EmployeeID, 
Order By 1,2


Select a.EmployeeID, AllAvgSalary
Select EmployeeID, Salary, AVG(Salary) over () AS AllAvgSalary
From EmployeeSalary a

Select EmployeeID, JobTitle, Salary
From EmployeeSalary
Where EmployeeID in (
    Select EmployeeID
    From EmployeeDemographics
    Where Age > 30)


-- SQL Data Exploration (Part 1/4) 