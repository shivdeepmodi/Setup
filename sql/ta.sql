col logfile new_value logfile
set termout off
select '&&DB_UNIQUE_NAME'||to_char(sysdate,'DDMMYYY:HH24MISS') logfile from dual;
set termout on

@/home/oracle/shivdeep/dbmon/tbs_check.sql ON /tmp/&&logfile..lst
set colsep ' '
host rm /tmp/&&logfile..lst
