column theclause new_value theclause
define tempsize=&1
set verify off termout off

select case 
       when sum(u.blocks*sz.block_size/1048576) <= decode(&&tempsize,NULL,0,&&tempsize) then '1=2'
       when sum(u.blocks*sz.block_size/1048576) > decode(&&tempsize,NULL,0,&&tempsize) then '1=1'
       end theclause
  from gV$TEMPSEG_USAGE u,
      (select distinct dt.tablespace_name, v.block_size, v.inst_id
         from dba_temp_files dt, gv$tempfile v
        where file#= file_id
          and file_name = name ) sz
/
set termout on
break on report
comput sum of SIZE_MB on report
select s.sid,s.serial#,s.username, substr(s.osuser,1,10) osuser,s.SQL_ID,
       substr(s.program,1,20) program, --segtype,
           s.logon_time,s.status,s.last_call_et,
           count(u.blocks) blk_count, sum(u.blocks*sz.block_size/1048576) size_mb
 from gV$TEMPSEG_USAGE u, gv$session s,
      (select distinct dt.tablespace_name, v.block_size, v.inst_id
         from dba_temp_files dt, gv$tempfile v
        where file#= file_id
          and file_name = name ) sz, v$SQLTEXT text
where u.session_addr = s.saddr
  and u.inst_id = s.inst_id
  and sz.inst_id=u.inst_id
  and tablespace=sz.tablespace_name
  and u.sqladdr=text.address
  and u.sqlhash=text.hash_value
  and u.sql_id=text.sql_id
  and &&theclause
group by s.sid,s.serial#,s.username, s.osuser, s.program,substr(s.osuser,1,10) ,s.SQL_ID,
       substr(s.program,1,20) , --segtype,
           s.logon_time,s.status,s.last_call_et
order by s.username, s.program
/

select v.sql_id,sql_text from
v$sqlarea v,
(select distinct sql_id from v$tempseg_usage) temp
where v.sql_id=temp.sql_id
  and &&theclause;
