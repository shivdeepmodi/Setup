REM skew_other.sql table_name column_name buckets
REM http://asktom.oracle.com/pls/asktom/f?p=100:11:3695167534265060::::P11_QUESTION_ID:30966075177614

column hist format a40
column RAT for a20                                                                                          
                         
define TNAME=&1
define CNAME=&2
define BUCKETS=&3
                                                                                          
                         
select wb,
       cnt,
       to_char(round( 100*cnt/(max(cnt) over ()),2),'999.00') rat,
       rpad( '*', 40*cnt/(max(cnt) over ()), '*' ) hist
  from (
select wb,
       count(*) cnt
  from (
select width_bucket( r, 0, (select count(distinct &cname) from &tname)+1, &buckets) wb
 from (
select dense_rank() over (order by &cname) r
  from &tname
      )
      )
group by wb
      )
 order by wb
/
