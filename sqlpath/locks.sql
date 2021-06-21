col username for a20	
col sid_serial for a20
col tab for a30
col terminal for a20
col lmode for a20
col request for a20
select  nvl(S.USERNAME,'Internal') username,
         nvl(S.TERMINAL,'None') terminal,
         L.SID||','||S.SERIAL# sid_serial,
         U1.NAME||'.'||substr(T1.NAME,1,20) tab,
         decode(L.LMODE,1,'No Lock',
                 2,'Row Share',
                 3,'Row Exclusive',
                 4,'Share',
                 5,'Share Row Exclusive',
                 6,'Exclusive',null) lmode,
         decode(L.REQUEST,1,'No Lock',
                 2,'Row Share',
                 3,'Row Exclusive',
                 4,'Share',
                 5,'Share Row Exclusive',
                 6,'Exclusive',null) request
 from    V$LOCK L,
         V$SESSION S,
         SYS.USER$ U1,
         SYS.OBJ$ T1
 where   L.SID = S.SID
 and     T1.OBJ# = decode(L.ID2,0,L.ID1,L.ID2)
 and     U1.USER# = T1.OWNER#
 --and     S.TYPE != 'BACKGROUND'
 and s.username is not null
 order by 1,2,5
/