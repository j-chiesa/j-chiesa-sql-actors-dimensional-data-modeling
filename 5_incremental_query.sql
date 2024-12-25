WITH 
	last_year_scd AS (
		SELECT *
		FROM actors_history_scd
		WHERE current_year = 2020
			AND end_year = 2020
	),
	historical_scd AS (
		SELECT 
			actor_id,
			actor_name,
			quality_class,
			is_active,
			start_year,
			end_year
		FROM actors_history_scd
		WHERE current_year = 2020
			AND end_year <= 2020
	),
	this_year_records AS (
		SELECT * 
		FROM actors
		WHERE current_year = 2021
	),
	unchanged_records AS (
		SELECT 
			ty.actor_id,
			ty.actor_name,
			ty.quality_class,
			ty.is_active,
			ly.start_year,
			ty.current_year	
		FROM this_year_records AS ty
		JOIN last_year_scd AS ly ON ty.actor_id = ly.actor_id AND ty.actor_name = ly.actor_name
		WHERE ty.quality_class = ly.quality_class
			AND ty.is_active = ly.is_active
	),
	changed_records AS (
		SELECT 
			ty.actor_id,
			ty.actor_name,
			UNNEST(ARRAY [
				ROW(
					ty.quality_class,
					ty.is_active,
					ty.current_year,
					ty.current_year
				)::scd_actors_type
			]) AS records
		FROM this_year_records AS ty
		LEFT JOIN last_year_scd AS ly ON ty.actor_id = ly.actor_id AND ty.actor_name = ly.actor_name
		WHERE (ty.quality_class <> ly.quality_class OR ty.is_active <> ly.is_active)
			OR ly.actor_id IS NULL
	),
	unnested_changed_records AS (
		SELECT 
			actor_id,
			actor_name,
			(records::scd_actors_type).quality_class,
			(records::scd_actors_type).is_active,
			(records::scd_actors_type).start_year,
			(records::scd_actors_type).end_year
		FROM changed_records
	),
	new_records AS (
		SELECT 
			ty.actor_id,
			ty.actor_name,
			ty.quality_class,
			ty.is_active,
			ty.current_year AS start_year,
			ty.current_year AS end_year
		FROM this_year_records AS ty
		LEFT JOIN last_year_scd AS ly ON ty.actor_id = ly.actor_id AND ty.actor_name = ly.actor_name
		WHERE ly.actor_id IS NULL
	)

SELECT * FROM historical_scd
UNION ALL
SELECT * FROM unchanged_records
UNION ALL
SELECT * FROM unnested_changed_records
UNION ALL
SELECT * FROM new_records