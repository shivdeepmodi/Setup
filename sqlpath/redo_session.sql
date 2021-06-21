SELECT module, osuser, sql_hash_value, value redo
  FROM gv$session s, gv$sesstat ss, gv$statname sn
 WHERE s.sid = ss.sid
   AND ss.statistic# = sn.statistic#
   AND name = 'redo size'
   AND username is not null
 ORDER BY redo;