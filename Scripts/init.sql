create database if not exists cricket;
create or replace schema cricket.land;
create or replace schema cricket.raw;
create or replace schema cricket.clean;
create or replace schema cricket.consumption;
create or replace schema cricket.etl;

show schemas in database cricket;

-- Create file format in the land schema
use schema cricket.land;

create or replace file format cricket.land.my_json_format
    type = json
    null_if = ('\\n', 'null', '')
    strip_outer_array = false
    comment = 'Json File format outer strip array flag true';

-- Create stage in the landing stage
create or replace stage cricket.land.my_stage;

--- Load Data using SnowSQL 
--PUT file:///C:/--Replace with the path your data is located--/*.json @my_stage/cricket/json/parallel;

-- list files inside the stage location
list @cricket.land.my_stage;

--================================================================================================================================================================
-- DATA EXPLORATION IN THE STAGE
--================================================================================================================================================================

-- Confirm whether Snowflake can read a specific data file
LIST '@"CRICKET"."LAND"."MY_STAGE"/1359514.json'

-- SELECT $1 always returns the full JSON payload for that row.
SELECT $1
FROM '@"CRICKET"."LAND"."MY_STAGE"/1359514.json' -- scan the entire file
     (file_format => 'my_json_format');

-- SHOW ALL TOP KEYS
SELECT OBJECT_KEYS($1)
FROM @CRICKET.LAND.MY_STAGE/1359514.json -- columns in the JSON file
     (file_format => 'my_json_format');
-- ACCESS EACH SECTION EXPLICITLY
-- Pick one of the records and see the details: 
select 
    t.$1:meta::variant as meta,
    t.$1:info::variant as info,
    t.$1:innings::variant as innings,
    metadata$filename as file_name,
    metadata$file_row_number int,
    metadata$file_content_key text,
    metadata$file_last_modified stage_modified_ts
from @my_stage/cricket/json/parallel/1082591.json.gz (file_format => 'my_json_format') t;

-- After Loading data using Put command in SNOWSQL: 
list @cricket.land.my_stage;

desc file format cricket.land.my_json_format;

-- REMOVE @cricket.land.my_stage;



