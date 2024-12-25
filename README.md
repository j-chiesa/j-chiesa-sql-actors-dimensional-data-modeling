# Dimensional Data Modeling - Portfolio

## Problem/Opportunity

In this project, I tackled the challenge of transforming a dataset, `actor_films`, into a dimensional model that facilitates efficient analysis. This involved constructing SQL queries and creating table definitions to support analytical tasks such as tracking actors' performance over time and implementing Slowly Changing Dimensions (SCD).

### Dataset Overview
The `actor_films` dataset contains:
- `actor`: Actor's name.
- `actorid`: Unique identifier for each actor.
- `film`: Film's title.
- `year`: Release year of the film.
- `votes`: Number of votes the film received.
- `rating`: Film's rating.
- `filmid`: Unique identifier for each film.

Primary Key: (`actorid`, `filmid`)

### Key Tasks:
1. Create a dimensional model for `actors` with a nested structure and performance categorization.
2. Populate the `actors` table incrementally over time.
3. Design and implement an `actors_history_scd` table to track changes using SCD Type 2.
4. Backfill historical data into the `actors_history_scd` table.
5. Develop an incremental update process for the `actors_history_scd` table.

---

## How I Identified It

The opportunity arose in a simulated data engineering scenario where analyzing actors' performance over time required a robust data model. The lack of a dimensional structure in the `actor_films` dataset made analytical queries inefficient, prompting the need for a solution.

---

## The Solution

To address the challenge, I:

1. Designed SQL DDL scripts for defining new data types (`films`, `quality_class`, `scd_actors_type`) and dimensional tables (`actors`, `actors_history_scd`).
2. Developed SQL queries to populate and maintain the dimensional tables incrementally, ensuring scalability and efficiency.
3. Implemented logic to track actors' performance quality and active status using SCD Type 2.

### Key Components:
- **Dimensional Modeling:** Created nested structures and categorical fields for efficient querying.
- **Backfilling:** Ensured historical consistency in the `actors_history_scd` table.
- **Incremental Updates:** Designed queries to handle new data dynamically without reprocessing entire datasets.

---

## How I Came Up with the Solution

The solution leveraged:
- **Dimensional Modeling Principles:** Applied concepts like fact and dimension tables to structure data for analytical queries.
- **SQL Best Practices:** Ensured clear, maintainable, and efficient SQL code.
- **Iterative Development:** Tested each component incrementally to refine the logic and ensure accuracy.

---

## The Process for Implementing It

### 1. Schema Design
   - Defined data types and table structures using SQL DDL.
   - Established primary and foreign key relationships.

### 2. Data Transformation
   - Created a pipeline to transform raw data into structured tables.
   - Handled null values and ensured data consistency.

### 3. Historical Data Management
   - Implemented a backfill query for populating the `actors_history_scd` table.
   - Designed incremental queries to update the SCD table with new data.

### 4. Validation and Optimization
   - Validated data integrity and correctness.
   - Optimized queries for performance.

---

## Repository Structure

```
├── 1_create_types.sql        # Define custom data types
├── 2_create_tables.sql       # Create table structures
├── 3_populate_actors.sql     # Populate `actors` table
├── 4_populate_actors_history.sql # Populate `actors_history_scd` table
├── 5_incremental_query.sql   # Incremental updates for `actors_history_scd`
└── README.md                 # Project documentation
