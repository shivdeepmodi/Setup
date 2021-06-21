set serveroutput off

REM If serveroutput is on when you call this function, the last statement you will have run  will be the (hidden) 
REM call to dbms_output that follows your execution of any other statement - so you won’t get the plan and statistics.


Accept SQL_ID          char   prompt 'Give the SQL_ID      : ' default ''
Accept CURSOR_CHILD_NO number prompt 'Give CURSOR_CHILD_NO : ' default ''
Accept FORMAT          char   prompt 'Give the FORMAT      : ' default 'ALLSTATS LAST'
select * from table(dbms_xplan.display_cursor('&&SQL_ID',&&CURSOR_CHILD_NO,'&&FORMAT'));

set serveroutput on