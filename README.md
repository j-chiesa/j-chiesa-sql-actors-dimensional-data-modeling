# SQL Dimensional Data Modeling

This repository demonstrates a comprehensive approach to solving a data engineering problem focused on dimensional modeling. The project showcases SQL skills, database design, and data manipulation to enable efficient analysis of the actor_films dataset.

## Problem / Opportunity
The task involves transforming and modeling the actor_films dataset into a structure that supports efficient analysis. Key objectives include creating tables, defining data types, and implementing queries to handle complex requirements such as:

1. Modeling actor performance and activity.
2. Classifying performance quality based on average movie ratings.
3. Tracking changes in actor performance and activity over time using a Type 2 Slowly Changing Dimension (SCD).

## How I Identified the Problem
The actor_films dataset lacked a clear dimensional model to facilitate analysis. It required restructuring to:
- Normalize and aggregate actor data.
- Track changes in actor performance over time.
- Provide flexibility for incremental updates.

This gap was identified through analyzing the dataset schema and recognizing inefficiencies in its raw form for answering analytical queries.

## The Solution
The solution consists of:

1. **Defining custom data types**:
   - `films`: To represent film attributes (name, votes, rating, ID).
   - `quality_class`: To classify actor performance (e.g., star, good, average, bad).
   - `scd_actors_type`: To track changes for SCD.

2. **Creating two main tables**:
   - `actors`: A table with aggregated yearly actor data.
   - `actors_history_scd`: A Type 2 SCD table to track historical changes.

3. **Implementing queries**:
   - Populating the `actors` table incrementally.
   - Generating backfill and incremental queries for `actors_history_scd`.

The SQL scripts used to implement this solution are structured as follows:
- `1_create_types.sql`
- `2_create_tables.sql`
- `3_populate_actors.sql`
- `4_populate_actors_history.sql`
- `5_incremental_query.sql`

## How I Came Up With the Solution
The solution was designed based on:

1. **Best practices in dimensional modeling**:
   - Ensuring efficient storage and query performance.
   - Supporting historical tracking with SCD Type 2.

2. **Dataset requirements**:
   - Using field analysis to design the `films` and `quality_class` types.
   - Capturing key attributes for actor performance.

3. **Iterative refinement**:
   - Drafting initial designs and testing queries.
   - Iteratively improving query logic and structure.

## The Process for Implementing It

1. **Define data types**:
   - Created custom data types for structured and consistent modeling.

2. **Design table schemas**:
   - Built normalized schemas for `actors` and `actors_history_scd`.

3. **Develop SQL queries**:
   - Wrote SQL scripts to populate tables incrementally and handle historical data.

4. **Test and validate**:
   - Ran test cases to ensure the accuracy of data and query outputs.

5. **Optimize and document**:
   - Refined queries for performance and added clear documentation to scripts.

---

### Files in This Repository

- **`1_create_types.sql`**: Defines custom types for the dataset.
- **`2_create_tables.sql`**: Creates `actors` and `actors_history_scd` tables.
- **`3_populate_actors.sql`**: Populates the `actors` table with annual data.
- **`4_populate_actors_history.sql`**: Backfills historical data for `actors_history_scd`.
- **`5_incremental_query.sql`**: Handles incremental updates to `actors_history_scd`.

This project demonstrates the principles of dimensional modeling and serves as an example of my skills in this domain.
