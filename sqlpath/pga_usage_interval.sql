col sample_time for a20
col username for a30

select cast(h.sample_time as date) sample_time,i.instance_name,u.username,round(h.pga_allocated/1048576,2) pga_mb, round(h.pga_allocated/1048576/1024,2) pga_gb
  from dba_users u, dba_hist_active_sess_history h, gv$instance i
 where i.inst_id = h.instance_number
   and u.user_id = h.user_id
   and cast(h.sample_time as date) between to_date('&dt1') and to_date('&dt2')
   order by 1;
   
