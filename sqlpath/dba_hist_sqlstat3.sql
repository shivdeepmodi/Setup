select cast(b.BEGIN_INTERVAL_TIME as date) snapshot_time,a.sql_id, 
       a.plan_hash_value, round(a.ELAPSED_TIME_TOTAL/1000000,2) ELAPSED,
       round(a.ELAPSED_TIME_TOTAL/decode(a.EXECUTIONS_TOTAL/1000000,0,1,a.EXECUTIONS_TOTAL/1000000),3) tpe, 
       a.EXECUTIONS_TOTAL EXECUTIONS
	   --, a.executions_delta
	   ,a.ROWS_PROCESSED_TOTAL
	   ,a.OPTIMIZER_COST
	   ,a.sql_profile 
  from dba_hist_sqlstat a, dba_hist_snapshot b , dba_hist_sqltext c
 where a.snap_id=b.snap_id
 and c.sql_id =a.sql_id
 and c.sql_text like 'select exp.price_curve as ori_price_curve, exp.volatility_curve, exp.expiration_%'
 and cast(b.BEGIN_INTERVAL_TIME as date) > to_date('25-MAY-2011 09:00:00')
 order by 1
/