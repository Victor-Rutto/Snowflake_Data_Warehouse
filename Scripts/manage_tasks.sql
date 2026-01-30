use schema cricket.etl;

use role accountadmin;
GRANT EXECUTE TASK, EXECUTE MANAGED TASK ON ACCOUNT TO ROLE sysadmin;
use role sysadmin;


--- Directed Acyclic Graph (DAG) task chains
--- Use Snowsight UI for DAG visualization
ALTER TASK cricket.etl.load_json_to_raw SUSPEND;


----- Clean layer tasks
alter task cricket.etl.load_to_clean_match_details resume;
alter task cricket.etl.load_to_clean_innings_table resume;
alter task cricket.etl.load_to_clean_players_table resume;

----- Gold tasks
alter task cricket.etl.etl_load_to_gold_match_dim resume;
alter task cricket.etl.etl_load_to_player_dim resume;
alter task cricket.etl.etl_load_to_deliveries_fact resume;

----- Landing to raw layer task
alter task cricket.etl.load_json_to_raw resume; ----------------- resume/start the root task the last.
                                                

SHOW TASKS IN SCHEMA cricket.etl; ----------------- The root task has PREDECESSORS = null.


SELECT
    name,
    predecessor,
    state
FROM TABLE(INFORMATION_SCHEMA.TASK_GRAPH('CRICKET.ETL.LOAD_JSON_TO_RAW'));


SHOW TASKS IN SCHEMA cricket.etl;


