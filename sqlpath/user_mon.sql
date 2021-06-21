select SAMPLE_TIME, SESSION_ID,SESSION_SERIAL#
 from dba_hist_active_sess_history h, dba_users u
where h.user_id = u.user_id
  and u.username = 'KM62573'
  and SAMPLE_TIME between to_date('10-FEB-2015 13:00:00','DD-MON-YYYY HH24:MI:SS') and to_date('10-FEB-2015 13:10:00','DD-MON-YYYY HH24:MI:SS');