set verify off heading off

accept username prompt 'Enter username: '

spool become_user_&&username._&&_CONNECT_IDENTIFIER..sql

select 'alter user &username identified by values ''' || password || ''';'
 from dba_users
where username = upper('&username')
/

spool off

alter user &username identified by p4r32rnw
/

conn &username/p4r32rnw

@become_user_&&username._&&_CONNECT_IDENTIFIER..sql

select 'Connected as user ' || user from dual;
@prompt
set verify on heading on
