--UPDATES:
--change the commas to dots for:
--global_carbon_budget
--northern_hemisphere
--southern_hemisphere
UPDATE global_carbon_budget SET fossil_emissions_excluding_carbonation = REPLACE(fossil_emissions_excluding_carbonation,',','.');
UPDATE global_carbon_budget SET "land-use_change_emissions" = REPLACE("land-use_change_emissions",',','.');
UPDATE global_carbon_budget SET atmospheric_growth = REPLACE(atmospheric_growth,',','.');
UPDATE global_carbon_budget SET ocean_sink =  REPLACE(ocean_sink,',','.');
UPDATE global_carbon_budget SET land_sink = REPLACE(land_sink,',','.');
UPDATE global_carbon_budget SET cement_carbonation_sink = REPLACE(cement_carbonation_sink,',','.');
UPDATE global_carbon_budget SET budget_imbalance = REPLACE(budget_imbalance,',','.');
UPDATE northern_hemisphere SET jan = REPLACE(jan,',','.');
UPDATE northern_hemisphere SET feb = REPLACE(feb,',','.');
UPDATE northern_hemisphere SET mar = REPLACE(mar,',','.');
UPDATE northern_hemisphere SET apr = REPLACE(apr,',','.');
UPDATE northern_hemisphere SET may = REPLACE(may,',','.');
UPDATE northern_hemisphere SET jun = REPLACE(jun,',','.');
UPDATE northern_hemisphere SET jul = REPLACE(jul,',','.');
UPDATE northern_hemisphere SET aug = REPLACE(aug,',','.');
UPDATE northern_hemisphere SET sept = REPLACE(sept,',','.');
UPDATE northern_hemisphere SET oct = REPLACE(oct,',','.');
UPDATE northern_hemisphere SET nov = REPLACE(nov,',','.');
UPDATE northern_hemisphere SET dec = REPLACE(dec,',','.');
UPDATE southern_hemisphere SET jan = REPLACE(jan,',','.');
UPDATE southern_hemisphere SET feb = REPLACE(feb,',','.');
UPDATE southern_hemisphere SET mar = REPLACE(mar,',','.');
UPDATE southern_hemisphere SET apr = REPLACE(apr,',','.');
UPDATE southern_hemisphere SET may = REPLACE(may,',','.');
UPDATE southern_hemisphere SET jun = REPLACE(jun,',','.');
UPDATE southern_hemisphere SET jul = REPLACE(jul,',','.');
UPDATE southern_hemisphere SET aug = REPLACE(aug,',','.');
UPDATE southern_hemisphere SET sept = REPLACE(sept,',','.');
UPDATE southern_hemisphere SET oct = REPLACE(oct,',','.');
UPDATE southern_hemisphere SET nov = REPLACE(nov,',','.');
UPDATE southern_hemisphere SET dec = REPLACE(dec,',','.');

--Add a column of total_km to both northern and southern hemisphere
ALTER TABLE southern_hemisphere
ADD COLUMN total_km NUMERIC;
UPDATE southern_hemisphere
SET total_km = (((jan::FLOAT + feb::FLOAT + mar::FLOAT
                 + apr::FLOAT + may::FLOAT + jun::FLOAT
                 + jul::FLOAT + aug::FLOAT + sept::FLOAT
                 + oct::FLOAT + nov::FLOAT + dec::FLOAT)) * 1000000);
ALTER TABLE northern_hemisphere
ADD COLUMN total_km NUMERIC;
UPDATE northern_hemisphere
SET total_km = (((jan::FLOAT + feb::FLOAT + mar::FLOAT
                 + apr::FLOAT + may::FLOAT + jun::FLOAT
                 + jul::FLOAT + aug::FLOAT + sept::FLOAT
                 + oct::FLOAT + nov::FLOAT + dec::FLOAT)) * 1000000);
--Get rid of rows that contain nulls values
WITH nulls AS (
SELECT  *,
jan::FLOAT + feb::FLOAT + mar::FLOAT
+ apr::FLOAT + may::FLOAT + jun::FLOAT
+ jul::FLOAT + aug::FLOAT + sept::FLOAT
+ oct::FLOAT + nov::FLOAT + dec::FLOAT 
AS
total
FROM northern_hemisphere)
SELECT *  FROM northern_hemisphere
JOIN nulls ON nulls.year = northern_hemisphere.year
 WHERE total IS NULL;
 WITH nulls AS (
    SELECT *,
           jan::FLOAT + feb::FLOAT + mar::FLOAT
           + apr::FLOAT + may::FLOAT + jun::FLOAT
           + jul::FLOAT + aug::FLOAT + sept::FLOAT
           + oct::FLOAT + nov::FLOAT + dec::FLOAT 
           AS total
    FROM northern_hemisphere
)
DELETE FROM northern_hemisphere
WHERE year IN (
    SELECT year
    FROM nulls
    WHERE total IS NULL
);


WITH nulls AS (
SELECT  *,
jan::FLOAT + feb::FLOAT + mar::FLOAT
+ apr::FLOAT + may::FLOAT + jun::FLOAT
+ jul::FLOAT + aug::FLOAT + sept::FLOAT
+ oct::FLOAT + nov::FLOAT + dec::FLOAT 
AS
total
FROM southern_hemisphere)
SELECT *  FROM southern_hemisphere
JOIN nulls ON nulls.year = southern_hemisphere.year
 WHERE total IS NULL;
 
 WITH nulls AS (
    SELECT *,
           jan::FLOAT + feb::FLOAT + mar::FLOAT
           + apr::FLOAT + may::FLOAT + jun::FLOAT
           + jul::FLOAT + aug::FLOAT + sept::FLOAT
           + oct::FLOAT + nov::FLOAT + dec::FLOAT 
           AS total
    FROM southern_hemisphere
)
DELETE FROM southern_hemisphere
WHERE year IN (
    SELECT year
    FROM nulls
    WHERE total IS NULL
);
