-- Create the 'actors' table to store information about actors and their film details
CREATE TABLE actors (
    actor_id TEXT,               			-- A unique identifier for each actor
    actor_name TEXT,             			-- The name of the actor
    films films[],               			-- An array of 'films' type containing information about each film the actor has worked in
    quality_class quality_class, 			-- The performance quality of the actor, based on average film ratings
    years_since_last_film INTEGER,			-- The number of years since the actor's last film
    current_year INTEGER,        			-- The current year for which the data is relevant
    is_active BOOLEAN,           			-- Indicates if the actor is currently active in the film industry
    PRIMARY KEY (actor_name, current_year) 	-- Composite primary key to ensure uniqueness of actor_name and current_year combination
);

-- Create the 'actors_history_scd' table to implement type 2 dimension modeling for actors' history
CREATE TABLE actors_history_scd (
    actor_id TEXT,               					-- A unique identifier for each actor
    actor_name TEXT,             					-- The name of the actor
    quality_class quality_class, 					-- The performance quality of the actor, tracked over time
    is_active BOOLEAN,           					-- Indicates if the actor is currently active in the film industry
    start_year INTEGER,          					-- The year the record started being valid
    end_year INTEGER,            					-- The year the record stopped being valid (null if current)
    current_year INTEGER,        					-- The current year for which the data is relevant
    PRIMARY KEY (actor_id, actor_name, start_year) 	-- Composite primary key to ensure uniqueness of actor_id, actor_name, and start_year combination
);