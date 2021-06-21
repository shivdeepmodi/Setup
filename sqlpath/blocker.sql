Column Blocker heading Blocker format a20
Column Blockee heading Blockee format a20
select (select username||':-'||sid||':'||serial# from gv$session where sid=a.sid and inst_id = a.inst_id) blocker,
       a.sid,
       ' is blocking ',
       (select username||':-'||sid||':'||serial# from gv$session where sid=b.sid and inst_id = b.inst_id) blockee,
       b.sid
  from gv$lock a, gv$lock b
 where a.block <> 0
   and b.request > 0
   and a.id1 = b.id1
   and a.id2 = b.id2
 order by a.sid
/
