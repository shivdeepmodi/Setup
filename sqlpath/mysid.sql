col sid new_value sid 
select sid
from v$mystat
where rownum < 2
/

select sid,serial#,username,module from v$session where sid = &sid;
