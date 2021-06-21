set lines 150 pages 30
col profile for a30
col username for a40

prompt ==========================================================
prompt NON-STANDARD PROFILES ON THIS DATABASE
prompt ==========================================================

select distinct profile 
from dba_profiles where profile not in ('DEFAULT', 'APPLICATION_USER', 'HUMAN_USER', 'SYSTEM_USER', 'ADMIN_USER');

prompt ==========================================================
prompt USERS THAT DO NOT BELONG TO STANDARD PROFILES
prompt ==========================================================

select profile ,count(*)
   from dba_profiles where profile not in ('DEFAULT', 'APPLICATION_USER', 'HUMAN_USER', 'SYSTEM_USER', 'ADMIN_USER')
group by profile;



prompt ==========================================================
prompt USERS THAT BELONG TO DEFAULT PROFILE
prompt ==========================================================

select username, profile from dba_users where profile = 'DEFAULT'and username <> 'XS$NULL';

prompt ==========================================================
prompt CHECK UMS DEFAULT PROFILE OTHER THAN HUMAN_USER
prompt ==========================================================

SELECT * FROM user_management.UM_USER_TYPE_PROFILE WHERE user_type = 'HUMAN' and PROFILE_NAME <> 'HUMAN_USER';

prompt ==========================================================
prompt CHECK ORACLE USERS WITH DEFAULT PASSWORD
prompt ==========================================================
col username for a40
col product for a40
col account_status for a20
select p.username,u.account_status,substr(p.product,1,40) product 
from dba_users_with_defpwd p, dba_users u
where p.username = u.username;

prompt ==========================================================
prompt CHECK DBA's PROFILES are ADMIN_USERS
prompt ==========================================================
col username for a30
col profile for a20

select username, profile from dba_users where username in (select grantee from  dba_role_privs where granted_role='DBA')
and profile <> 'ADMIN_USER';

prompt ==========================================================
prompt CHECK OEM_TASKS's PROFILE is APPLICATION_USER
prompt ==========================================================
col username for a30
col profile for a20

select username, profile from dba_users where username = 'OEM_TASKS' and profile <> 'APPLICATION_USER';

prompt ==========================================================
prompt CHECK DEFAULT PROFILE IS TO STANDARD
prompt ==========================================================

col profile for a20
col resource_name for a30
col limit for a60
select profile, resource_name, limit from 
(
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='COMPOSITE_LIMIT'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='CONNECT_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='CPU_PER_CALL'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='CPU_PER_SESSION'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,10,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||10) LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='FAILED_LOGIN_ATTEMPTS'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='IDLE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='LOGICAL_READS_PER_CALL'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='LOGICAL_READS_PER_SESSION'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,7,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||7) LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='PASSWORD_GRACE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,180,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||180) LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='PASSWORD_LIFE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,1,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||1) LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='PASSWORD_LOCK_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,9,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||9) LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='PASSWORD_REUSE_MAX'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='PASSWORD_REUSE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'MRKT_PASS_VERIFY',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'MRKT_PASS_VERIFY') LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='PASSWORD_VERIFY_FUNCTION'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='PRIVATE_SGA'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'DEFAULT' and RESOURCE_NAME='SESSIONS_PER_USER'
)
where LIMIT like '%LIMIT Should be%'
;


prompt ==========================================================
prompt CHECK HUMAN_USER PROFILE IS TO STANDARD
prompt ==========================================================

col profile for a20
col resource_name for a30
col limit for a60
select profile, resource_name, limit 
from
(
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='COMPOSITE_LIMIT'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='CONNECT_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='CPU_PER_CALL'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='CPU_PER_SESSION'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,5,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||5) LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='FAILED_LOGIN_ATTEMPTS'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,60,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||60) LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='IDLE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='LOGICAL_READS_PER_CALL'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='LOGICAL_READS_PER_SESSION'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,7,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||7) LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='PASSWORD_GRACE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,90,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||90) LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='PASSWORD_LIFE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,1,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||1) LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='PASSWORD_LOCK_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,9,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||9) LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='PASSWORD_REUSE_MAX'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,180,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||180) LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='PASSWORD_REUSE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'MRKT_PASS_VERIFY',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'MRKT_PASS_VERIFY') LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='PASSWORD_VERIFY_FUNCTION'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='PRIVATE_SGA'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,5,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||5) LIMIT from dba_profiles where profile = 'HUMAN_USER' and RESOURCE_NAME='SESSIONS_PER_USER'
)
where LIMIT like '%LIMIT Should be%'
;


prompt ==========================================================
prompt CHECK APPLICATION_USER PROFILE IS TO STANDARD
prompt ==========================================================
col profile for a20
col resource_name for a30
col limit for a60
select profile, resource_name, limit
from
(
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='COMPOSITE_LIMIT'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='CONNECT_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='CPU_PER_CALL'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='CPU_PER_SESSION'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='FAILED_LOGIN_ATTEMPTS'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='IDLE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='LOGICAL_READS_PER_CALL'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='LOGICAL_READS_PER_SESSION'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='PASSWORD_GRACE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='PASSWORD_LIFE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,1,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||1) LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='PASSWORD_LOCK_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,9,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||9) LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='PASSWORD_REUSE_MAX'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='PASSWORD_REUSE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'MRKT_PASS_VERIFY_SERVICE',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'MRKT_PASS_VERIFY_SERVICE') LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='PASSWORD_VERIFY_FUNCTION'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='PRIVATE_SGA'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'APPLICATION_USER' and RESOURCE_NAME='SESSIONS_PER_USER'
)
where LIMIT like '%LIMIT Should be%'
;

prompt ==========================================================
prompt CHECK ADMIN_USER PROFILE IS TO STANDARD
prompt ==========================================================

col profile for a20
col resource_name for a30
col limit for a60
select profile, resource_name, limit 
from
(
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='COMPOSITE_LIMIT'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='CONNECT_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='CPU_PER_CALL'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='CPU_PER_SESSION'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,5,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||5) LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='FAILED_LOGIN_ATTEMPTS'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,60,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||60) LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='IDLE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='LOGICAL_READS_PER_CALL'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='LOGICAL_READS_PER_SESSION'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,7,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||7) LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='PASSWORD_GRACE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,90,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||90) LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='PASSWORD_LIFE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,1,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||1) LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='PASSWORD_LOCK_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,9,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||9) LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='PASSWORD_REUSE_MAX'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,180,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||180) LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='PASSWORD_REUSE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'MRKT_PASS_VERIFY_PRIVILEGED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'MRKT_PASS_VERIFY_PRIVILEGED') LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='PASSWORD_VERIFY_FUNCTION'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='PRIVATE_SGA'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,5,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||5) LIMIT from dba_profiles where profile = 'ADMIN_USER' and RESOURCE_NAME='SESSIONS_PER_USER'
)
where LIMIT like '%LIMIT Should be%'
;

prompt ==========================================================
prompt CHECK SYSTEM_USER PROFILE IS TO STANDARD
prompt ==========================================================

col profile for a20
col resource_name for a30
col limit for a60
select profile, resource_name, limit 
from
(
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='COMPOSITE_LIMIT'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='CONNECT_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='CPU_PER_CALL'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='CPU_PER_SESSION'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='FAILED_LOGIN_ATTEMPTS'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='IDLE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='LOGICAL_READS_PER_CALL'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='LOGICAL_READS_PER_SESSION'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,7,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||7) LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='PASSWORD_GRACE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='PASSWORD_LIFE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='PASSWORD_LOCK_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,9,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||9) LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='PASSWORD_REUSE_MAX'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,180,LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||180) LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='PASSWORD_REUSE_TIME'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'MRKT_PASS_VERIFY_SERVICE',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'MRKT_PASS_VERIFY_SERVICE') LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='PASSWORD_VERIFY_FUNCTION'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='PRIVATE_SGA'
union
select PROFILE,RESOURCE_NAME,decode(LIMIT,'UNLIMITED',LIMIT,'LIMIT is '||LIMIT||'.'||'LIMIT Should be '||'UNLIMITED') LIMIT from dba_profiles where profile = 'SYSTEM_USER' and RESOURCE_NAME='SESSIONS_PER_USER'
)
where LIMIT like '%LIMIT Should be%'
;


