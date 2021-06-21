col description for a15
col time_taken for a22
col work_task heading SUB_TASK for a20 trunc
col TASK_CLOSE_DATE for a20
col COMPLETE_DATE for a20
col TASK_CLOSE_DATE for a20
col WORK_TASK_SUB for a20
col comments for a10
col ASSIGNED for a10

select tl.description,st.*,
  case when sysdate-st.start_date = 0 then 'IF. Are you sure it completed in 0?'
       when sysdate-st.start_date > 1 then to_char(trunc(sysdate-st.start_date)) || ' Days '|| to_char(round(mod(sysdate-st.start_date,1)*24,2))|| ' Hours '
       when sysdate-st.start_date < 1 then to_char(round(mod(sysdate-st.start_date,1)*24,2))|| ' Hours '|| to_char(mod(round(mod(sysdate-st.start_date,1)*24,2),1)*60) ||' Mins'
  else 'If. Other'
  end  time_taken
 from task_main tm, task_list tl, task_subtask st
 where tm.taskid=tl.taskid
   and tm.work_task = st.work_task
   and st.status = 'InProgress'
order by st.status
/
