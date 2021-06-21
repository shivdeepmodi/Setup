col username for a30
col profile for a30
col account_status for a30
select username,profile,account_status from dba_users where profile = 'SYSTEM_USER' and account_status = 'OPEN';

select username,profile,account_status from dba_users where username in
(
'CMDBRO',
'DBSNMP',
'MARKITDBA',
'MARKITMON',
'SYSMAN',
'SYS',
'SYSTEM',
'USER_MANAGEMENT'
) order by username;
