select * from table(dbms_stats.diff_table_stats_in_history(
                    ownname => '&owner',
                    tabname => '&table_name',
                    time1 => systimestamp,
                    time2 => to_timestamp('&time2','DD-MON_YYYY hh24:mi:ss.FF'),
                    pctthreshold => 10))
/
