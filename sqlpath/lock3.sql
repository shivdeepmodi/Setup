Column sid         heading SID            format 99999
Column username    heading Username       format a20
Column osuser      heading Osuser         format a20
Column terminal    heading Terminal       format a20
Column object_name heading 'Object Name'  format a20
Column type        heading 'Lock Type'    format a15
Column lm          heading 'Lock Mode'    format a16
Column rm          heading 'Request Mode' format a12

select b.sid,
c.username,
c.osuser,
--c.terminal,
--decode(b.id2, 0, a.object_name, 'Trans-'||to_char(b.id1)) object_name,
--decode(b.type,'TM','DML Enqueue','TX','Transaction enqueue','UL','User supplied',b.type),
t.name type,
decode(b.lmode,
0, 'None',
1, 'Null',
2, 'Row Share(SS)',
3, 'Row Excl(SX)',
4, 'Share(S)',
5, 'Sha Row Exc(SSX)',
6, 'Exclusive(X)',
'Other') lm,
decode(b.request,
0, 'None',
1, 'Null',
2, 'Row Share(SS)',
3, 'Row Excl(SX)',
4, 'Share(S)',
5, 'Sha Row Exc(SSX)',
6, 'Exclusive(X)') rm
from 
--dba_objects a,
v$lock b,
v$session c,
v$locked_object la,
v$lock_type t
where 
--a.object_id (+) = b.id1 and 
b.sid = c.sid
and la.session_id = b.sid
and t.type = b.type
and c.username is not null
and c.type = 'USER'
--and c.sid in (select sid from v$session where username is not null)
order by
b.sid,
b.id2
/
clear columns