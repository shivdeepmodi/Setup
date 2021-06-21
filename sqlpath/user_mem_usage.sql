Column username  heading 'Username'      format a20
Column SID_SER#  heading 'Sid Serial#'   format a10
Column osuser    heading 'Osuser'        format a10
Column program   heading 'Program'       format a10
Column module    heading 'Module'        format a10
Column value     heading 'Memory Usage'  format 99999999

break on report

Compute sum label 'Total Memory Usage' of value on report

select  substr(s.username,1,8) username,
        s.sid ||','|| s.serial# SID_SER#,
        substr(s.osuser,1,10) osuser,
        substr(s.program,1,10) program, 
        substr(s.module,1,10) module,
        v1.value
 from v$sesstat v1, v$session s
where v1.statistic# = 20 
  and v1.sid = s.sid
  and s.username is not null
 order by v1.value desc
/
clear breaks
clear columns