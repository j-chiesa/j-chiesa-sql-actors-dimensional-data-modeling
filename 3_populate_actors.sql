-- Insert data into the 'actors' table using a series of common table expressions (CTEs)
INSERT INTO actors
WITH 
    -- Generate a series of years from 1970 to 2021
    years AS (
        SELECT *
        FROM generate_series(1970, 2021) AS year
    ),
    -- Determine the first year each actor appeared in a film
    first_year AS (
        SELECT
            actor,
            actorid,
            MIN(year) AS first_year
        FROM actor_films
        GROUP BY actor, actorid
    ),
    -- Combine actors with their corresponding years
    actors_and_years AS (
        SELECT *
        FROM first_year fy
        JOIN years y ON fy.first_year <= y.year
    ),
    -- Calculate the average rating for each actor by year, handling nulls
    actors_and_ratings_nulls AS (
        SELECT 
            ay.actor,
            ay.actorid,
            ay.year,
            AVG(af.rating) AS avg_rating,
            SUM(CASE WHEN AVG(af.rating) IS NOT NULL THEN 1 ELSE 0 END) OVER (PARTITION BY ay.actor ORDER BY ay.year) AS avg_group
        FROM actors_and_years AS ay
        LEFT JOIN actor_films AS af 
            ON ay.actor = af.actor AND ay.year = af.year
        GROUP BY ay.actor, ay.actorid, ay.year
    ),
    -- Fill in null average ratings with the most recent non-null value for the actor
    actors_and_ratings AS (
        SELECT 
            actor,
            actorid,
            year,
            COALESCE(
                avg_rating,
                MAX(avg_rating) OVER (PARTITION BY actor, actorid, avg_group ORDER BY year) 
            ) AS avg_rating
        FROM actors_and_ratings_nulls
    ),
    -- Aggregate films for each actor by year and calculate the average rating
    windowed AS (
        SELECT 
            ar.actor,
            ar.actorid,
            ar.year,
            ar.avg_rating,
            ARRAY_REMOVE(
                ARRAY_AGG(
                    CASE
                        WHEN af.year IS NOT NULL THEN CAST(ROW(af.film, af.votes, af.rating, af.filmid) AS films)
                    END
                ),
                NULL
            ) AS films
        FROM actors_and_ratings AS ar
        LEFT JOIN actor_films AS af ON ar.actor = af.actor AND ar.year = af.year
        GROUP BY ar.actor, ar.actorid, ar.year, ar.avg_rating
    ),
    -- Retrieve data from the previous year's 'actors' table incrementally from 1970 until the last year from current year. Execute code once per year.
    last_year AS (
        SELECT *
        FROM actors
        WHERE current_year = 2020
    ),
    -- Retrieve data for the current year (2021) incrementally from 1970 until the current year. Execute code once per year.
    this_year AS (
        SELECT *
        FROM windowed
        WHERE year = 2021
    )
SELECT 
    COALESCE(t.actorid, l.actor_id) AS actor_id, -- Use current year's actor_id or previous year's if not available
    COALESCE(t.actor, l.actor_name) AS actor_name, -- Use current year's actor name or previous year's if not available
    CASE
        WHEN l.films IS NULL THEN t.films -- If previous year's films are null, use current year's films
        WHEN t.year IS NOT NULL THEN l.films || t.films -- If current year data exists, concatenate films
        ELSE l.films -- Otherwise, use previous year's films
    END AS films,
    CASE
        WHEN t.avg_rating > 8 THEN 'star'
        WHEN t.avg_rating > 7 THEN 'good'
        WHEN t.avg_rating > 6 THEN 'average'
        ELSE 'bad'
    END::quality_class AS quality_class, -- Classify quality based on average rating
    CASE 
        WHEN CARDINALITY(t.films) = 0 THEN l.years_since_last_film + 1 -- Increment years since last film if no films this year
        ELSE 0 -- Reset to 0 if there are films this year
    END AS years_since_last_film,
    COALESCE(t.year, l.current_year) AS current_year, -- Use current year's data or previous year's if not available
    CASE 
        WHEN CARDINALITY(t.films) = 0 THEN FALSE -- Mark as inactive if no films this year
        ELSE TRUE -- Mark as active if there are films this year
    END AS is_active    
FROM this_year AS t
FULL OUTER JOIN last_year AS l
    ON t.actor = l.actor_name AND t.actorid = l.actor_id;
