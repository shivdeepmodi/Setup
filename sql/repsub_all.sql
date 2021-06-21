col taskid noprint
col description for a30
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
order by st.status
/

