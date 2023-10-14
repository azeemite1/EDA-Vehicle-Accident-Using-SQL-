--A Vehicle_accident database was created Using MSSMS.
--Next, Imported CVS files to this database as tables.
--Finally, Conduct Exploratory data analysis (EDA).
----------------------------------------------------------------------------------
-- Lets view the two tables
SELECT*
FROM accident;

SELECT*
FROM vehicle;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--Question 1: How many accidents have occurred in urban areas versus rural areas?
SELECT Area, COUNT(AccidentIndex) AS 'Total Accident'
FROM accident
GROUP BY Area;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------
--Question 2: Which day of the week has the highest number of accidents?
SELECT Day, COUNT(AccidentIndex) 'Total Accident'
FROM accident
GROUP BY Day
ORDER BY COUNT(AccidentIndex) DESC;
------------------------------------------------------------------------------------
------------------------------------------------------------------------------------

--Question 3: What is the average age of vehicles involved in accidents based on their type?
SELECT VehicleType, COUNT(AccidentIndex ) AS 'Total Accident', AVG(AgeVehicle) AS 'Average Age'
FROM vehicle
WHERE AgeVehicle is NOT NULL
GROUP BY VehicleType
ORDER BY AVG(AgeVehicle) DESC;
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--Question 4: Can we identify any trends in accidents based on the age of vehicles involved?
----Categorise vehicle based on Age group; 0 to 5 as New, 6 to 10 as regular & more than 10 as Old.

SELECT
	AgeGroup,
	COUNT(AccidentIndex) AS 'Total Accident',
	AVG(AgeVehicle) AS 'Average Age'

FROM 
	(SELECT
			AccidentIndex, AgeVehicle,
			CASE
			WHEN AgeVehicle BETWEEN 0 AND 5 THEN 'New'
			WHEN AgeVehicle BETWEEN 6 AND 10 THEN 'Regular'
			ELSE 'Old'
		END AS AgeGroup
	FROM vehicle
	)
	AS Subquerry
GROUP BY AgeGroup;
--------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------

--Question 5: Are there any specific weather conditions that contribute to severe accidents? --Serious, Fatal, Slight
--DECLARE @Severity nvarchar(50)
--SET @Severity = 'Fatal' --Serious, Fatal, Slight
---------------------------------------------------
--- Total Severity
SELECT 
		[WeatherConditions],
		COUNT([WeatherConditions]) AS 'Total Accident'
FROM accident
--WHERE Severity = 'Fatal'
GROUP BY [WeatherConditions]
ORDER BY 'Total Accident' DESC;

----Total accident by Fatal
SELECT 
		[WeatherConditions],
		COUNT([WeatherConditions]) AS 'Total Accident'
FROM accident
WHERE Severity = 'Fatal'
GROUP BY [WeatherConditions]
ORDER BY 'Total Accident' DESC;

----Total accident by Serious
SELECT 
		[WeatherConditions],
		COUNT([WeatherConditions]) AS 'Total Accident'
FROM accident
WHERE Severity = 'Serious'
GROUP BY [WeatherConditions]
ORDER BY 'Total Accident' DESC;

----Total accident by Slight
SELECT 
		[WeatherConditions],
		COUNT([WeatherConditions]) AS 'Total Accident'
FROM accident
WHERE Severity = 'Slight'
GROUP BY [WeatherConditions]
ORDER BY 'Total Accident' DESC;
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------

--Question 6: Do accidents often involve impacts on the left-hand side of vehicles?
SELECT
		LeftHand,
		COUNT(AccidentIndex) As 'Total Accident'
FROM vehicle
GROUP BY LeftHand
HAVING LeftHand is Not Null;

------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------

--Question 7: Are there any relationships between journey purposes and the severity of accidents?
	---Created 3 levels; Low, Medium and High
SELECT v.JourneyPurpose,
		COUNT(a.Severity) AS 'Total Accident',
		CASE
		WHEN COUNT(a.Severity) BETWEEN 0 AND 1000 THEN 'Low'
		WHEN COUNT(a.Severity) BETWEEN 1001 AND 3000 THEN 'Medium'
		ELSE 'High'
	END AS Level

FROM vehicle v
JOIN accident a ON v.AccidentIndex = a.AccidentIndex
GROUP BY v.JourneyPurpose
ORDER BY 'Total Accident' DESC;

------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------

--Question 8: Calculate the average age of vehicles involved in accidents , considering Day light and point of impact:
SELECT 
		v.PointImpact,
		AVG(v.AgeVehicle) AS 'Average Year'
		
FROM accident a
JOIN vehicle v ON a.AccidentIndex = v.AccidentIndex 
WHERE a.LightConditions = 'Daylight' 
GROUP BY v.PointImpact
ORDER BY AVG(v.AgeVehicle) DESC;
--- When LightConditions is Darkness 
SELECT 
		v.PointImpact,
		AVG(v.AgeVehicle) AS 'Average Year'
		
FROM accident a
JOIN vehicle v ON a.AccidentIndex = v.AccidentIndex 
WHERE a.LightConditions = 'Darkness' 
GROUP BY v.PointImpact
ORDER BY AVG(v.AgeVehicle) DESC;
