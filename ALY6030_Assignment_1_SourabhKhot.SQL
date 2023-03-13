# Creating database to store table(s)
CREATE DATABASE vehicle;
# Check whether the database is created
SHOW DATABASES;

# Set database to use, to avoid mentioning it repetively
USE vehicle;

# Creating empty table with appropriate structure
CREATE TABLE car (
	Car VARCHAR(64),
    MPG FLOAT,
	Cylinders INT,
	Displacement INT,
	Horsepower INT,
	Weight INT,
	Acceleration FLOAT,
	Model INT,
	Origin VARCHAR(12)
);

# At this stage, import data from CSV manually using the following steps
# Refresh schema on the left. Under 'vehicle' database > Tables > right click 'car' table
# Click on Table Data Import Wizard, choose the path location pointing to 'cars-2.csv'.
# Choose to import in existing 'car' table, columns should be mapped automatically and import

# Show Ford cars with average weight per model filtered between 3000 and 4000, sorted by ascending weight
SELECT Car, ROUND(AVG(Weight),1) AS AVG_WT
FROM car
WHERE Car LIKE 'Ford%'
GROUP BY Car
HAVING AVG_WT BETWEEN 3000 AND 4000
ORDER BY AVG_WT ASC;

# Show count of unique cars by Origin region, having acceleration seconds less than 12
SELECT Origin, COUNT(DISTINCT Car) AS Car_Count
FROM car
WHERE Acceleration < 12
GROUP BY Origin;

# Show Average MPG by Origin of Cars, sorted by Avg MPG to understand if cars from a Region are more fuel efficient
SELECT Origin, ROUND(AVG(MPG),2) AS AVG_MPG
FROM car
GROUP BY Origin
ORDER BY AVG_MPG DESC;

# Show Average Displacement for each Cylinder Counfiguration of Car, sored by Avg Displacement
SELECT Cylinders, ROUND(AVG(Displacement),2) AS Avg_Disp
FROM car
GROUP BY Cylinders
ORDER BY Avg_Disp ASC;