
prompt Detecting Contention for Space in the Redo Log Buffer (should be less than 1%) 	

SELECT ROUND(GREATEST((SUM(DECODE (ln.name, 'redo copy', misses,0)) / GREATEST(SUM(DECODE(ln.name, 'redo copy', gets,0)),1)), 
       (SUM(DECODE(ln.name, 'redo allocation', misses,0)) / GREATEST(SUM(DECODE(ln.name, 'redo allocation', gets,0)),1)), 
       (SUM(DECODE(ln.name, 'redo copy', immediate_misses,0)) / GREATEST(SUM(DECODE(ln.name, 'redo copy', immediate_gets,0)) + SUM(DECODE(ln.name, 'redo copy', immediate_misses,0)),1)),
       (SUM(DECODE(ln.name, 'redo allocation', immediate_misses,0)) / GREATEST(SUM(DECODE(ln.name, 'redo allocation', immediate_gets,0)) + SUM(DECODE(ln.name, 'redo allocation', immediate_misses,0)),1))) * 100,2) AS "Percentage"
  FROM gv$latch l, gv$latchname ln
  WHERE l.latch# = ln.latch#;