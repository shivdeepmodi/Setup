REM Details of jobs,programs,schedules in Oracle Database 10g
REM The user needs execute on dbms_sql

set feedback off serveroutput on
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

declare
  p_query         varchar2(1000):='select * from dba_scheduler_programs';
  l_theCursor     integer default dbms_sql.open_cursor;
  l_columnValue   varchar2(4000);
  l_status        integer;
  l_descTbl       dbms_sql.desc_tab;
  l_colCnt        number;
begin
  execute immediate 'alter session set nls_date_format=''DD-MON-YYYY HH24:MI:SS'' ';

  dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );
  dbms_sql.describe_columns  ( l_theCursor, l_colCnt, l_descTbl );
  dbms_output.put_line( '-------------------------------------------------------------------------------------------' );
  for i in 1 .. l_colCnt 
    loop
      dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
    end loop;

    l_status := dbms_sql.execute(l_theCursor);

    while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
      for i in 1 .. l_colCnt
      loop
        dbms_sql.column_value( l_theCursor, i, l_columnValue );
        dbms_output.put_line( rpad( l_descTbl(i).col_name, 30 )|| ': ' ||l_columnValue );
      end loop;
      dbms_output.put_line( '-------------------------------------------------------------------------------------------' );
    end loop;
    execute immediate 'alter session set nls_date_format=''DD-MON-YYYY'' ';
exception
    when others then
      execute immediate 'alter session set nls_date_format=''DD-MON-YYYY'' ';
      raise;
end;
/

  
Prompt
Prompt ####################################################################################################
Prompt # Display the schedule details.                                                                    #
Prompt ####################################################################################################

declare
  p_query         varchar2(1000):='select owner,schedule_name,schedule_type,start_date,repeat_interval,
                                          event_queue_owner,event_queue_name,event_queue_agent,event_condition,end_date,comments
                                     from dba_scheduler_schedules';
  l_theCursor     integer default dbms_sql.open_cursor;
  l_columnValue   varchar2(4000);
  l_status        integer;
  l_descTbl       dbms_sql.desc_tab;
  l_colCnt        number;
begin
  execute immediate 'alter session set nls_date_format=''DD-MON-YYYY HH24:MI:SS'' ';

  dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );
  dbms_sql.describe_columns  ( l_theCursor, l_colCnt, l_descTbl );
  dbms_output.put_line( '-------------------------------------------------------------------------------------------' );
  for i in 1 .. l_colCnt 
    loop
      dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
    end loop;

    l_status := dbms_sql.execute(l_theCursor);

    while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
      for i in 1 .. l_colCnt
      loop
        dbms_sql.column_value( l_theCursor, i, l_columnValue );
        dbms_output.put_line( rpad( l_descTbl(i).col_name, 30 )|| ': ' ||l_columnValue );
      end loop;
      dbms_output.put_line( '-------------------------------------------------------------------------------------------' );
    end loop;
    execute immediate 'alter session set nls_date_format=''DD-MON-YYYY'' ';
exception
    when others then
      execute immediate 'alter session set nls_date_format=''DD-MON-YYYY'' ';
      raise;
end;
/


Prompt
Prompt ####################################################################################################
Prompt # Display job details.                                                                             #
Prompt ####################################################################################################
--SELECT owner, job_name, state, job_class, enabled 
--  FROM dba_scheduler_jobs;  
select owner,job_name,job_creator,job_type,state,job_action
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
declare
  p_query         varchar2(1000):='SELECT window_name,window_priority,schedule_owner,schedule_name,resource_plan,duration,start_Date,end_date,next_start_date,last_start_date  FROM dba_scheduler_windows';
  l_theCursor     integer default dbms_sql.open_cursor;
  l_columnValue   varchar2(4000);
  l_status        integer;
  l_descTbl       dbms_sql.desc_tab;
  l_colCnt        number;
begin
  execute immediate 'alter session set nls_date_format=''DD-MON-YYYY HH24:MI:SS'' ';

  dbms_sql.parse(  l_theCursor,  p_query, dbms_sql.native );
  dbms_sql.describe_columns  ( l_theCursor, l_colCnt, l_descTbl );
  dbms_output.put_line( '-------------------------------------------------------------------------------------------' );
  for i in 1 .. l_colCnt 
    loop
      dbms_sql.define_column(l_theCursor, i, l_columnValue, 4000);
    end loop;

    l_status := dbms_sql.execute(l_theCursor);

    while ( dbms_sql.fetch_rows(l_theCursor) > 0 ) loop
      for i in 1 .. l_colCnt
      loop
        dbms_sql.column_value( l_theCursor, i, l_columnValue );
        dbms_output.put_line( rpad( l_descTbl(i).col_name, 30 )|| ': ' ||l_columnValue );
      end loop;
      dbms_output.put_line( '-------------------------------------------------------------------------------------------' );
    end loop;
    execute immediate 'alter session set nls_date_format=''DD-MON-YYYY'' ';
exception
    when others then
      execute immediate 'alter session set nls_date_format=''DD-MON-YYYY'' ';
      raise;
end;
/

Prompt
Prompt ####################################################################################################
Prompt # End                                                                                              #
Prompt ####################################################################################################
Prompt
set feedback on
clear columns