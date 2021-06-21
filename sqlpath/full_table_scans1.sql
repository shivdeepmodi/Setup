REM Change sql text 
select unique  a.sql_id, substr(a.sql_text,1,30), b.options, b.object_owner, b.object_name, c.bytes from v$sql a , v$sql_plan b, DBA_segments C
where sql_text like 'SELECT ati.value, ab.tran_status,  ab.tran_num,  ab.deal_tracking_num,  buy_sell.name verbStr%' 
and a.sql_id = b.sql_id 
and options='FULL' 
AND B.OBJECT_NAME=C.segment_NAME;
