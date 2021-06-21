select
      extract( day from snap_interval) *24*60+extract( hour from snap_interval) *60+extract( minute from snap_interval ) "Snapshot Interval in Minutes",
      extract( day from retention) *24*60+ extract( hour from retention) *60+extract( minute from retention ) "Retention Interval in Minutes",
      extract( day from retention) + extract( hour from retention)/24+extract( minute from retention )/(24*60) "Retention Interval in Days"
from dba_hist_wr_control;