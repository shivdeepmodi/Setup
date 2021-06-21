REM Details of jobs,programs,schedules in Oracle Database 10g
REM The user needs execute on dbms_sql

set feedback off serveroutput on verify off
Column owner                   heading 'Owner'                  format a15
Column program_name            heading 'Program Name'           format a30
Column enabled                 heading 'Enabled'                format a7
Column schedule_name           heading 'Schedule Name'          format a24
Column schedule_type           heading 'Schedule|Type'          format a8
Column job_name                heading 'Job Name'               format a30
Column job_class               heading 'Job Class'              format a30
Column job_class_name          heading 'Job Class Name'         format a20
Column service                 heading 'Service'                format a10
Column job_creator             heading 'Job Creator'            format a12
Column job_type                heading 'Job Type'               format a16
Column job_action              heading 'Job Action'             format a60 newline
Column resource_consumer_group heading 'Resoure Consumer Group' format a30
Column window_name             heading 'Window Name'            format a20
Column active                  heading 'Active'                 format a6
Column window_group_name       heading 'Window Group Name'      format a30
Column repeat_interval         heading 'Repeat|Interval'        format a70
Column start_Date              heading 'Start Date'             format a20
Column end_Date                heading 'End Date'               format a20
Column next_start_date         heading 'Next Start Date'        format a30
Column last_start_date         heading 'Last Start Date'        format a30
Column duration                heading 'Duration'               format a13
Column state                   heading 'State'                  format a10 

Prompt
Prompt ####################################################################################################
Prompt # Display the program details.                                                                     #
Prompt ####################################################################################################
--SELECT owner, program_name, enabled 
--  FROM dba_scheduler_programs;

@print_table_call.sql "select * from dba_scheduler_programs"
  
Prompt
Prompt ####################################################################################################
Prompt # Display the schedule details.                                                                    #
Prompt ####################################################################################################

@print_table_call.sql "select owner,schedule_name,schedule_type,start_date,repeat_interval, event_queue_owner,event_queue_name,event_queue_agent,event_condition,end_date,comments from dba_scheduler_schedules"

Prompt
Prompt ####################################################################################################
Prompt # Display job details.                                                                             #
Prompt ####################################################################################################
--SELECT owner, job_name, state, job_class, enabled 
--  FROM dba_scheduler_jobs;  
select owner,job_name,schedule_name,job_creator,job_type,state,job_action,repeat_interval
  from dba_scheduler_jobs
/

Prompt
Prompt ####################################################################################################
Prompt # Display job class details.                                                                       #
Prompt ####################################################################################################
SELECT job_class_name, resource_consumer_group,service
  FROM dba_scheduler_job_classes;

Prompt
Prompt ####################################################################################################
Prompt # Display window group members.                                                                    #
Prompt ####################################################################################################
SELECT window_group_name, window_name
  FROM dba_scheduler_wingroup_members;

Prompt
Prompt ####################################################################################################
Prompt # Display window group details.                                                                    #
Prompt ####################################################################################################
SELECT window_name, enabled, active,schedule_type,repeat_interval
  FROM dba_scheduler_windows;

Prompt
Prompt ####################################################################################################
Prompt # Display additional window group details.                                                         #
Prompt ####################################################################################################

@print_table_call.sql "SELECT window_name,window_priority,schedule_owner,schedule_name,resource_plan,duration,start_Date,end_date,next_start_date,last_start_date  FROM dba_scheduler_windows"

Prompt
Prompt ####################################################################################################
Prompt # End                                                                                              #
Prompt ####################################################################################################
Prompt
set feedback on verify on
clear columns