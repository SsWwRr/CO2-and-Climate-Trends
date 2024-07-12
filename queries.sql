-- 1. What are the long-term trends in global temperature anoomaly changes over the years?
WITH time_spans AS (
    SELECT 
    AVG(
        CASE
            WHEN
            "j-d" != '***' 
            AND year::INTEGER 
            BETWEEN 1900 
            AND 1949
            THEN
            "j-d"::FLOAT
            ELSE NULL
        END
    ) AS fifty_1900,
    AVG(
        CASE
            WHEN
            "j-d" != '***' 
            AND year::INTEGER 
            BETWEEN 1950 
            AND 1999
            THEN
            "j-d"::FLOAT
            ELSE NULL
        END
    ) AS fifty_1950,
        AVG(
        CASE
            WHEN
            "j-d" != '***' 
            AND year::INTEGER 
            BETWEEN 1880 
            AND 1889
            THEN
            "j-d"::FLOAT
            ELSE NULL
        END
    ) AS ten_1880,
        AVG(
        CASE
            WHEN
            "j-d" != '***' 
            AND year::INTEGER 
            BETWEEN 1940 
            AND 1949
            THEN
            "j-d"::FLOAT
            ELSE NULL
        END
    ) AS ten_1940,
        AVG(
        CASE
            WHEN
            "j-d" != '***' 
            AND year::INTEGER 
            BETWEEN 1980 
            AND 1989
            THEN
            "j-d"::FLOAT
            ELSE NULL
        END
    ) AS ten_1980,
        AVG(
        CASE
            WHEN
            "j-d" != '***' 
            AND year::INTEGER 
            BETWEEN 1990 
            AND 1999
            THEN
            "j-d"::FLOAT
            ELSE NULL
        END
    ) AS ten_1990,
        AVG(
        CASE
            WHEN
            "j-d" != '***' 
            AND year::INTEGER 
            BETWEEN 2000 
            AND 2009
            THEN
            "j-d"::FLOAT
            ELSE NULL
        END
    ) AS ten_2000,
            AVG(
        CASE
            WHEN
            "j-d" != '***' 
            AND year::INTEGER 
            BETWEEN 2010 
            AND 2019
            THEN
            "j-d"::FLOAT
            ELSE NULL
        END
    ) AS ten_2010
    FROM temp_change
)
SELECT ten_1880,ten_1940,
ten_1980,ten_1990,
ten_2000,ten_2010,
ABS((ten_2010-ten_1880)/ten_1880)
AS anomaly_increase_percentage 
FROM time_spans;
--OPTIONAL: you can also use fifty year periods but there are only two so i used decades
--ANSWER: Until the 80s the anomaly rate has been small and it was below average temp, but it has been growing and now its high and by a huge margin its skewed towards hot temp
--2. Are there any notable seasonal patterns in temperature changes?
SELECT
AVG(djf::FLOAT)
FILTER(
    WHERE djf!='***'
    )
AS 
winter,
AVG(mam::FLOAT)
FILTER(
    WHERE mam!='***'
    )
AS
spring,
AVG(jja::FLOAT)
FILTER(
    WHERE jja!='***'
    )
AS
summer,
AVG(son::FLOAT)
FILTER(
    WHERE son!='***'
    )
AS
fall 
FROM temp_change;
--ANSWER: The anomaly rate is the highest in the fall and the smallest in the summer
--3.How do annual fossil fuel emissions compare to land-use change emissions?
SELECT 
AVG(fossil_emissions_excluding_carbonation::FLOAT)
AS avg_fossil,
AVG("land-use_change_emissions"::FLOAT) 
AS avg_land_use
FROM global_carbon_budget;
--ANSWER: the average fossil fuel emissions are 5 times higher thant the land use emissions
--4. What is the trend in the budget imbalance over the years?
WITH trends AS
    (
    SELECT 
    AVG(
        CASE
            WHEN 
            year::INTEGER 
            BETWEEN 
            1960 AND 1979
            THEN
            budget_imbalance::FLOAT
            ELSE NULL
        END
    )
    AS twenty_1960,
    AVG(
        CASE
            WHEN 
            year::INTEGER 
            BETWEEN 
            1980 AND 1999
            THEN
            budget_imbalance::FLOAT
            ELSE NULL
        END
    )
    AS twenty_1980,
        AVG(
        CASE
            WHEN 
            year::INTEGER 
            BETWEEN 
            2000 AND 2019
            THEN
            budget_imbalance::FLOAT
            ELSE NULL
        END
    )
    AS twenty_2000
    FROM global_carbon_budget
    )
SELECT *
FROM trends;
 --ANSWER: the budget imbalance has gotten worse over the years, but recovered a bit in the last two decades
--5. How does cement carbonation contribute to the carbon budget?
SELECT 
AVG(
    cement_carbonation_sink::FLOAT
    )
*100.0
/
(AVG(
    fossil_emissions_excluding_carbonation::FLOAT
    )
+
AVG(
    "land-use_change_emissions"::FLOAT
    )) 
AS budget_percentage
FROM global_carbon_budget;
--ANSWER: The carbonation contributes a total of 1.09% to the total budget
--6.How effective are the ocean and land sinks in absorbing CO2 emissions?
WITH car_sink AS
(
    SELECT 
    (AVG(
        ocean_sink::FLOAT
        ) 
        + 
    AVG(
        land_sink::FLOAT
        )) 
    AS ls_sink_efficiency,
    (AVG(fossil_emissions_excluding_carbonation::FLOAT)
    +
    AVG("land-use_change_emissions"::FLOAT))
    AS carbonation
    FROM global_carbon_budget
)
SELECT ls_sink_efficiency*100.0/carbonation
AS
efficiency_percentage
FROM car_sink;
--ANSWER: The land and ocean sinkage takes care of 55% of the carbon creation
--7. What are the long-term trends in melting ice areas for both the Northern and Southern Hemispheres?
WITH decades AS
(
    SELECT 
    SUM(sh.total_km)
    FILTER(
        WHERE sh.year::INTEGER 
        BETWEEN 1980 AND 1989
        )
    AS
    decade_1980_south,
        SUM(sh.total_km)
    FILTER(
        WHERE sh.year::INTEGER 
        BETWEEN 1990 AND 1999)
    AS
    decade_1990_south,
        SUM(sh.total_km)
    FILTER(
        WHERE sh.year::INTEGER 
        BETWEEN 2000 AND 2009)
    AS
    decade_2000_south,
        SUM(sh.total_km)
    FILTER(
        WHERE sh.year::INTEGER 
        BETWEEN 2010 AND 2019)
    AS
    decade_2010_south,
    SUM(nh.total_km)
    FILTER(
        WHERE nh.year::INTEGER 
        BETWEEN 1980 AND 1989)
    AS
    decade_1980_north,
        SUM(nh.total_km)
    FILTER(
        WHERE nh.year::INTEGER 
        BETWEEN 1990 AND 1999)
    AS
    decade_1990_north,
        SUM(nh.total_km)
    FILTER(
        WHERE nh.year::INTEGER 
        BETWEEN 2000 AND 2009)
    AS
    decade_2000_north,
        SUM(nh.total_km)
    FILTER(
        WHERE nh.year::INTEGER 
        BETWEEN 2010 AND 2019)
    AS
    decade_2010_north
    FROM southern_hemisphere sh 
    JOIN   
    northern_hemisphere nh
    ON
    sh.year::INTEGER = nh.year::INTEGER
)
SELECT * FROM decades;
--ANSWER: On the north pole the ice surface is shrinking at a high but steady rate, on the south pole it started shrinking rapidly just recently
