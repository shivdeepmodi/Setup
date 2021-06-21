alter session set nls_Date_format='DD-MON-YYYY HH24:MI:SS';
col taskid noprint
col time_taken for a20
col description for a10 trunc
col work_task heading MAIN_TASK for a20 trunc
col work_task_sub for a20 trunc
col WORK_TASK_DESC heading TASK_DESC for a20 trunc
col comments for a10 trunc
set timing off
prompt ====================================================================================================================================================================
prompt = Main task for today                                                                                                                                              =
prompt ====================================================================================================================================================================

select tl.description,tm.*,
case
 when tm.status = 'InProgress'
 then case
          when sysdate-tm.start_date = 0 then 'IF. Are you sure it completed in 0?'
          when sysdate-tm.start_date > 1 then to_char(trunc(sysdate-tm.start_date)) || ' Days '|| to_char(round(mod(sysdate-tm.start_date,1)*24,2))|| ' Hours '
          when sysdate-tm.start_date < 1 then to_char(round(mod(sysdate-tm.start_date,1)*24,2))|| ' Hours '|| to_char(mod(round(mod(sysdate-tm.start_date,1)*24,2),1)*60) ||' Mins'
          else 'If. Other'
      end
 when tm.status = 'Completed'
 then case
          when tm.complete_date-tm.start_date = 0 then 'Else. Are you sure it completed in 0?'
          when tm.complete_date-tm.start_date > 1 then to_char(trunc(sysdate-tm.start_date)) || ' Days '|| to_char(round(mod(tm.complete_date-tm.start_date,1)*24,2))|| ' Hours '
          when tm.complete_date-tm.start_date < 1 then to_char(round(mod(tm.complete_date-tm.start_date,1)*24,2))|| ' Hours '|| to_char(mod(round(mod(tm.complete_date-tm.start_date,1)*24,2),1)*60) ||' Mins'
          else 'Else. Other'
      end
end time_taken
 from task_main tm, task_list tl
 where tm.taskid=tl.taskid
   and trunc(tm.start_date) = trunc(sysdate)
 order by tm.status
/
prompt ====================================================================================================================================================================
prompt = SUB task for today                                                                                                                                               =
prompt ====================================================================================================================================================================
col taskid noprint
col work_task heading SUB_TASK for a20 trunc
select tl.description,st.*,
case
 when st.status = 'InProgress'
 then case
          when sysdate-st.start_date = 0 then 'IF. Are you sure it completed in 0?'
          when sysdate-st.start_date > 1 then to_char(trunc(sysdate-st.start_date)) || ' Days '|| to_char(round(mod(sysdate-st.start_date,1)*24,2))|| ' Hours '
          when sysdate-st.start_date < 1 then to_char(round(mod(sysdate-st.start_date,1)*24,2))|| ' Hours '|| to_char(mod(round(mod(sysdate-st.start_date,1)*24,2),1)*60) ||' Mins'
          else 'If. Other'
      end
 when st.status = 'Completed'
 then case
          when st.complete_date-st.start_date = 0 then 'Else. Are you sure it completed in 0?'
          when st.complete_date-st.start_date > 1 then to_char(trunc(sysdate-st.start_date)) || ' Days '|| to_char(round(mod(st.complete_date-st.start_date,1)*24,2))|| ' Hours '
          when st.complete_date-st.start_date < 1 then to_char(round(mod(st.complete_date-st.start_date,1)*24,2))|| ' Hours '|| to_char(mod(round(mod(st.complete_date-st.start_date,1)*24,2),1)*60) ||' Mins'
          else 'Else. Other'
      end
end time_taken
 from task_main tm, task_list tl, task_subtask st
 where tm.taskid=tl.taskid
   and tm.work_task = st.work_task
   and trunc(st.start_date) = trunc(sysdate)
order by st.status
/

col taskid noprint
col comments for a20 trunc
col assigned for a9
col work_task heading DAILY_TASK for a20 trunc
prompt ====================================================================================================================================================================
prompt = Daily task for today                                                                                                                                             =
prompt ====================================================================================================================================================================

select tl.description,st.*,
case
 when st.status = 'InProgress'
 then case
          when sysdate-st.start_date = 0 then 'IF. Are you sure it completed in 0?'
          when sysdate-st.start_date > 1 then to_char(trunc(sysdate-st.start_date)) || ' Days '|| to_char(round(mod(sysdate-st.start_date,1)*24,2))|| ' Hours '
          when sysdate-st.start_date < 1 then to_char(round(mod(sysdate-st.start_date,1)*24,2))|| ' Hours '|| to_char(mod(round(mod(sysdate-st.start_date,1)*24,2),1)*60) ||' Mins'
          else 'If. Other'
      end
 when st.status = 'Completed'
 then case
          when st.complete_date-st.start_date = 0 then 'Else. Are you sure it completed in 0?'
          when st.complete_date-st.start_date > 1 then to_char(trunc(sysdate-st.start_date)) || ' Days '|| to_char(round(mod(st.complete_date-st.start_date,1)*24,2))|| ' Hours '
          when st.complete_date-st.start_date < 1 then to_char(round(mod(st.complete_date-st.start_date,1)*24,2))|| ' Hours '|| to_char(mod(round(mod(st.complete_date-st.start_date,1)*24,2),1)*60) ||' Mins'
          else 'Else. Other'
      end
end time_taken
 from task_main tm, task_list tl, task_subtask_daily st
 where tm.taskid=tl.taskid
   and tm.work_task = st.work_task
   and trunc(st.start_date) = trunc(sysdate)
order by st.start_date
/

set timing on
