-- Insert data into the 'actors_history_scd' table using a series of common table expressions (CTEs)
INSERT INTO actors_history_scd
WITH
    -- Retrieve previous quality_class and is_active status for each actor, year by year
    actors_previous AS (
        SELECT 
            actor_id,
            actor_name,
            current_year,
            quality_class,
            is_active,
            LAG(quality_class, 1) OVER (PARTITION BY actor_id, actor_name ORDER BY current_year) AS previous_quality_class, -- Previous year's quality_class
            LAG(is_active, 1) OVER (PARTITION BY actor_id, actor_name ORDER BY current_year) AS previous_is_active -- Previous year's is_active status
        FROM actors
        WHERE current_year <= 2020 -- Include data up to the year 2020
    ),
    -- Identify changes in quality_class or is_active status
    change_identifier AS (
        SELECT *,
            CASE
                WHEN quality_class <> previous_quality_class THEN 1
                WHEN is_active <> previous_is_active THEN 1
                ELSE 0
            END AS change_indicator -- Indicator for changes in quality_class or is_active status
        FROM actors_previous
    ),
    -- Identify streaks (periods of unchanged status) for each actor
    streak_identifier AS (
        SELECT *,
            SUM(change_indicator) OVER (PARTITION BY actor_id, actor_name ORDER BY current_year) AS streak_indicator -- Identify streaks of unchanged status
        FROM change_identifier
    )

SELECT 
    actor_id,
    actor_name,
    quality_class,
    is_active,
    MIN(current_year) AS start_year, -- Start year of the streak
    MAX(current_year) AS end_year, -- End year of the streak (2020 in this case)
    2020 AS current_year -- The final year of data being processed
FROM streak_identifier
GROUP BY actor_id, actor_name, quality_class, is_active
ORDER BY actor_id, actor_name;
