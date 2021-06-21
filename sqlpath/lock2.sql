Column sid for 99999
column serial# for 999999
Column kill         heading 'Kill Statement' format a48 newline
Column spid for a10
Column username     format a15
Column osuser           format a10
Column status           format a10
Column machine format a10
Column object_name      format a20
Column object_type      format a20
Column program          format a20
Column terminal for a20
column module for a10
column client_info for a10
set null --NULL--

select * from 
(
 select a.sid,a.serial#,
        a.osuser,
        a.status,
        substr(b.oracle_username,1,15) ora_user,
        c.object_name,
        c.object_type,
        substr(a.program,1,20) program,
       terminal,
       --b.locked_mode,
        'alter system kill session '''||a.sid||','||''||a.serial#||''' immediate;' kill
   from gv$session a, gv$locked_object b, sys.dba_objects c
  where a.sid = b.session_id
    and a.inst_id = b.inst_id
    and a.type = 'USER'
    and c.object_id = b.object_id
union 
select a.sid,a.serial#,
       a.osuser,
       a.status,
       a.username,
	   c.object_name,
       c.object_type,
       substr(a.program,1,20) program,
       terminal,
       'alter system kill session '''||a.sid||','||''||a.serial#||''' immediate;' kill
  from gv$session a, gv$lock b, sys.dba_objects c
 where a.sid = b.sid
   and a.inst_id = b.inst_id
   and c.object_id = b.id1
   and b.type='TO'
)
/
--clear columns