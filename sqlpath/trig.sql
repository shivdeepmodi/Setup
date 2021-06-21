Accept trigger_name char prompt 'Give trigger name:'

Column owner            heading Owner            format a10
Column TRIGGERING_EVENT heading TRIGGERING_EVENT format a16
Column trigger_name     heading 'Trigger Name'   format a15
select owner,trigger_name,table_name,trigger_type,triggering_event,table_owner,status
  from dba_triggers
 where trigger_name = '&trigger_name'
/