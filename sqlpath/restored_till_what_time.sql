prompt
prompt After recovery open database in READ-ONLY mode and run following
prompt 
select name,scn_to_timestamp(current_scn) "Restored_Till_Time" from v$database
/