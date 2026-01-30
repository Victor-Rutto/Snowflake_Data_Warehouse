# Snowflake_Data_Warehouse
ETL Pipeline using snowflake

End-to-end ETL project using Snowflake, ingesting JSON data from the Indian Premier League (IPL) from @Kaggle. The pipeline covers Landing (stage) --> Raw --> clean --> consumption (GOLD) layer, handling match, player, and delivery-level data.
Key Components:

1. Landing (LAND) Layer
Created a Snowflake stage and file format for JSON.
Loaded raw .json files using SnowSQL PUT command.

2. Raw (RAW) Layer
Loaded raw JSON into a transient table (match_raw_table) for cost-efficient staging.
Created streams (for_match_stream, for_player_stream) to track incremental inserts.

3. Clean (CLEAN) Layer
Flattened deeply nested JSON arrays (innings → overs → deliveries → extras/wickets) using LATERAL FLATTEN.
Created CLEAN tables:
match_details → match-level info
innings_table → delivery-level details
clean_players_table → player info
Added audit columns (stage_file_name, stage_file_row_number, stage_file_hashkey, stage_modified_ts).

4. Consumption (GOLD) Layer
Built dimensional tables:
MATCH_DIM → match-level dimension
PLAYER_DIM → player-level dimension
Built fact table:
DELIVERIES_FACT → ball-by-ball deliveries with foreign keys to match and player dimensions.
Tasks use MERGE statements with metadata$action = 'INSERT' to ensure incremental updates.

TAKE-AWAYS
Snowflake Stages & File Formats
JSON handling is easy and performant with proper stage + file format setup.
strip_outer_array and null_if help manage messy JSON.

Flattening JSON
LATERAL FLATTEN is essential for deeply nested arrays like innings, overs, deliveries.

Streams & Tasks
Stream objects capture incremental changes from RAW → CLEAN → GOLD.
Tasks allow time- and event-triggered execution, building a fully orchestrated DAG.

Robust DAG Design
Task chaining ensures dependencies are respected.
GOLD tasks run after CLEAN tasks finish, ensuring referential integrity for dimensions and fact tables.
