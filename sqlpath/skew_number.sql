REM http://asktom.oracle.com/pls/asktom/f?p=100:11:0::::P11_QUESTION_ID:707586567563
REM WIDTH_BUCKET function to measure skewness for numeric columns


Accept Column_name char   prompt 'Give the column name: '
Accept Table_name  char   prompt 'Give the table name: '
Accept buckets     number prompt 'Give the bucket number: ' default 5
set verify off
select min(&&column_name), max(&&column_name), count(&&column_name), wb
  from (
select &&column_name,
       width_bucket( &&column_name,
                     (select min(&&column_name)-1 from &&Table_name),
                     (select max(&&column_name)+1 from &&Table_name), &&buckets ) wb
  from &&Table_name
       )
 group by wb
/
set verify on