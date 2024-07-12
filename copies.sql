COPY (SELECT 
AVG(fossil_emissions_excluding_carbonation::FLOAT)
AS avg_fossil,
AVG("land-use_change_emissions"::FLOAT) 
AS avg_land_use
FROM global_carbon_budget
)
TO
--private
WITH CSV HEADER;;

COPY (
    SELECT * FROM
    (
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
SELECT ten_1880::DECIMAL,ten_1940::DECIMAL,
ten_1980::DECIMAL,ten_1990::DECIMAL,
ten_2000,ten_2010::DECIMAL
FROM time_spans)
)
TO
--private
WITH CSV HEADER;
COPY (SELECT
AVG(djf::FLOAT)
FILTER(WHERE djf!='***')
AS 
winter,
AVG(mam::FLOAT)
FILTER(WHERE mam!='***')
AS
spring,
AVG(jja::FLOAT)
FILTER(WHERE jja!='***')
AS
summer,
AVG(son::FLOAT)
FILTER(WHERE son!='***')
AS
fall 
FROM temp_change)
TO
--private
WITH CSV HEADER;
COPY (SELECT 
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
AS sequestration_effects,
100-AVG(
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
    ))  AS emission_after_sequestration

FROM global_carbon_budget)
TO
--private
WITH CSV HEADER;
COPY (WITH car_sink AS
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
efficiency_percentage,
100-ls_sink_efficiency*100.0/carbonation AS carbon_left
FROM car_sink)
TO
--private
WITH CSV HEADER;
COPY (WITH trends AS
    (
    SELECT 
    AVG(
        CASE
            WHEN 
            year::INTEGER 
            BETWEEN 
            1960 AND 1969
            THEN
            budget_imbalance::FLOAT
            ELSE NULL
        END
    )
    AS ten_1960,
    AVG(
        CASE
            WHEN 
            year::INTEGER 
            BETWEEN 
            1970 AND 1979
            THEN
            budget_imbalance::FLOAT
            ELSE NULL
        END
    )
    AS ten_1970,
        AVG(
        CASE
            WHEN 
            year::INTEGER 
            BETWEEN 
            1980 AND 1989
            THEN
            budget_imbalance::FLOAT
            ELSE NULL
        END
    )
    AS ten_1980,
        AVG(
        CASE
            WHEN 
            year::INTEGER 
            BETWEEN 
            1990 AND 1999
            THEN
            budget_imbalance::FLOAT
            ELSE NULL
        END
    )
    AS ten_1990,
        AVG(
        CASE
            WHEN 
            year::INTEGER 
            BETWEEN 
            2000 AND 2009
            THEN
            budget_imbalance::FLOAT
            ELSE NULL
        END
    )
    AS ten_2000,
        AVG(
        CASE
            WHEN 
            year::INTEGER 
            BETWEEN 
            2010 AND 2019
            THEN
            budget_imbalance::FLOAT
            ELSE NULL
        END
    )
    AS ten_2010
    FROM global_carbon_budget
    )
SELECT *
FROM trends)
TO
--private
WITH CSV HEADER;
COPY(
WITH decades_south AS(
    SELECT 
    SUM(nh.total_km)
    FILTER(WHERE nh.year::INTEGER BETWEEN 1980 AND 1989)
    AS
    decade_1980_north,
        SUM(nh.total_km)
    FILTER(WHERE nh.year::INTEGER BETWEEN 1990 AND 1999)
    AS
    decade_1990_north,
        SUM(nh.total_km)
    FILTER(WHERE nh.year::INTEGER BETWEEN 2000 AND 2009)
    AS
    decade_2000_north,
        SUM(nh.total_km)
    FILTER(WHERE nh.year::INTEGER BETWEEN 2010 AND 2019)
    AS
    decade_2010_north

    FROM northern_hemisphere nh
)
SELECT * FROM decades_south)
TO
--private
WITH CSV HEADER;
COPY(
WITH decades_south AS(
    SELECT 
    SUM(sh.total_km)
    FILTER(WHERE sh.year::INTEGER BETWEEN 1980 AND 1989)
    AS
    decade_1980_south,
        SUM(sh.total_km)
    FILTER(WHERE sh.year::INTEGER BETWEEN 1990 AND 1999)
    AS
    decade_1990_south,
        SUM(sh.total_km)
    FILTER(WHERE sh.year::INTEGER BETWEEN 2000 AND 2009)
    AS
    decade_2000_south,
        SUM(sh.total_km)
    FILTER(WHERE sh.year::INTEGER BETWEEN 2010 AND 2019)
    AS
    decade_2010_south
FROM southern_hemisphere sh)
SELECT * FROM decades_south)
TO
--private
WITH CSV HEADER;