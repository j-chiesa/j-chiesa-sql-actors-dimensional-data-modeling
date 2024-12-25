INSERT INTO actors_history_scd
WITH
	actors_previous AS (
		SELECT 
			actor_id,
			actor_name,
			current_year,
			quality_class,
			is_active,
			LAG(quality_class, 1) OVER (PARTITION BY actor_id, actor_name ORDER BY current_year) AS previous_quality_class,
			LAG(is_active, 1) OVER (PARTITION BY actor_id, actor_name ORDER BY current_year) AS previous_is_active
		FROM actors
		WHERE current_year <= 2020
	),
	change_identifier AS (
		SELECT *,
			CASE
				WHEN quality_class <> previous_quality_class THEN 1
				WHEN is_active <> previous_is_active THEN 1
				ELSE 0
			END AS change_indicator
		FROM actors_previous
	),
	streak_identifier AS (
		SELECT *,
			SUM(change_indicator) OVER (PARTITION BY actor_id, actor_name ORDER BY current_year) AS streak_indicator
		FROM change_identifier
	)

SELECT 
	actor_id,
	actor_name,
	quality_class,
	is_active,
	MIN(current_year) AS start_year,
	MAX(current_year) AS end_year,
	2020 AS current_year
FROM streak_identifier
GROUP BY actor_id, actor_name, quality_class, is_active
ORDER BY actor_id, actor_name

