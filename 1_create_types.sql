-- Create a composite type 'films' to represent information about films
CREATE TYPE films AS (
    film TEXT,          -- The name of the film
    votes INTEGER,      -- The number of votes the film received
    rating REAL,        -- The rating of the film
    filmid TEXT         -- A unique identifier for each film
);

-- Create an enum type 'quality_class' to represent the performance quality of actors
CREATE TYPE quality_class AS ENUM(
    'star',             -- Average rating > 8
    'good',             -- Average rating > 7 and ≤ 8
    'average',          -- Average rating > 6 and ≤ 7
    'bad'               -- Average rating ≤ 6
);

-- Create a composite type 'scd_actors_type' to represent type 2 dimension attributes for actors
CREATE TYPE scd_actors_type AS (
    quality_class quality_class,  -- The performance quality of the actor
    is_active BOOLEAN,            -- Indicates if the actor is currently active
    start_year INTEGER,           -- The year the record started being valid
    end_year INTEGER              -- The year the record stopped being valid (null if current)
);