CREATE TYPE films AS (
    film TEXT,
    votes INTEGER, 
    rating REAL,
    filmid TEXT
);

CREATE TYPE quality_class AS ENUM(
    'star', 
    'good', 
    'average', 
    'bad'
);

CREATE TYPE scd_actors_type AS
(
	quality_class quality_class,
	is_active boolean,
	start_year integer,
	end_year integer
);
