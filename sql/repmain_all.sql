col taskid noprint
col time_taken for a20
col description for a25 trunc
col work_task heading MAIN_TASK for a20 trunc
col WORK_TASK_DESC heading TASK_DESC for a20 trunc
col comments for a20 trunc

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
 order by tm.status
/
ttitle off
