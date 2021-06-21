spool &2 replace
---------------------------------------
--REM setup to create drop user begin
---------------------------------------

--set lines 300 verify off head off timing off trimspool on
--col username for a20
--col created for a20
--col user_status format a50
--col name for a15

--define theuser=DIJOSHI 
define theuser=IMELDRUM 
--Create user
define comment=CHG0224704
--prompt Create user on  &&_connect_identifier
--prompt
create user /* &&comment */ &&theuser identified by NdUUPnZcWJEeA7ajAWt1#;

grant dba to &&theuser;
alter user &&theuser profile ADMIN_USER;


--Find user

select d.name,decode(u.username,NULL,'USER_STATUS NOT_FOUND :'||'&&_connect_identifier'||':'||'&&theuser','USER_STATUS FOUND :'||u.username||' Created on: ') user_status ,u.created
from 
(select 1 X,name from v$database) d,
(select 1 X,username,created from DBA_users where username ='&&theuser') u
where d.x=u.x(+)
/

--drop /*+ CHG0212534 */ user DIJOSHI  cascade;

---------------------------------------
--REM setup to create drop user begin
---------------------------------------
spool off
