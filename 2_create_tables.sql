CREATE TABLE actors (
	actor_id TEXT,
	actor_name TEXT,
	films films[],
	quality_class quality_class,
	years_since_last_film INTEGER,
	current_year INTEGER,
	is_active BOOLEAN,
	PRIMARY KEY (actor_name, current_year)
)

CREATE TABLE actors_history_scd (
	actor_id TEXT,
	actor_name TEXT,
	quality_class quality_class,
	is_active BOOLEAN,
	start_year INTEGER,
	end_year INTEGER,
	current_year INTEGER,
	PRIMARY KEY (actor_id, actor_name, start_year)
)