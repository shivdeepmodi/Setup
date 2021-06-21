Column sid         heading SID                 format 9999
Column username    heading Username            format a20 
Column machine     heading Machine             format a10
Column used_ublk   heading 'Used|Undo|Blocks'  format 999999999
Column used_ublk   heading 'Used|Undo|Records' format 999999999
Column transaction heading Transaction         format a25
select sid,
       username,
       machine,
       used_ublk,
       used_urec,
       decode(substr(to_char(flag,'0000000X' ),8,1), '0', 'Normal User Transaction'
                                                   , '8', 'Rollback') transaction
  from v$session s, v$transaction t
 where t.addr = s.taddr;
clear columns