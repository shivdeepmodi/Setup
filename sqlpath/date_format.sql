set feedback off
Column "Query Format" format a60
Column "Date Format"  format a30
select * from
(
select 'trunc(SYSDATE)+ 01/24 ' "Query Format", trunc(SYSDATE) + 01/24 "Date Format" from dual
union
select 'trunc(SYSDATE)+ 23/24 ' "Query Format", trunc(SYSDATE) + 23/24 "Date Format" from dual
union
select 'trunc(SYSDATE)+ 24/24 ' "Query Format", trunc(SYSDATE) + 24/24 "Date Format" from dual
union
select 'trunc(SYSDATE)+ 48/24 ' "Query Format", trunc(SYSDATE) + 48/24 "Date Format" from dual
union
select 'trunc(SYSDATE)+ 01/24 + 5/(24*60) ' "Query Format", trunc(SYSDATE) + 1/24 + 5/(24*60) "Date Format" from dual
union
select 'trunc(SYSDATE)+ 01/24 + 5/(24*60) + 5/(24*60*60)' "Query Format", trunc(SYSDATE) + 1/24 + 5/(24*60) + 5/(24*60*60)"Date Format" from dual
)
/
set feedback on