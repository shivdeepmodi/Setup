
prompt <html>
col profile for a30
col username for a40

--prompt ==========================================================
--prompt PROFILES ON THE DATABASE
--prompt ==========================================================

--select distinct profile from dba_profiles;

prompt <table border="1" width="100%">
prompt <tr><td>NON-STANDARD PROFILES ON THIS DATABASE</td></tr>
prompt <tr><td>PROFILE</td></tr>
select distinct '<tr><td>'||profile ||'</td></tr>'
from dba_profiles where profile not in ('DEFAULT', 'APPLICATION_USER', 'HUMAN_USER', 'SYSTEM_USER', 'ADMIN_USER');


--prompt !! CHECKPOINT ACTION: There should only be DEFAULT, APPLICATION_USER, HUMAN_USER, SYSTEM_USER, ADMIN_USER. NOTE ANY EXCEPTIONS !!

prompt </table>

prompt <br>

prompt <table border="1" width="100%">
prompt <tr><td colspan=2>USERS THAT DO NOT BELONG TO STANDARD PROFILES</td></tr>
prompt <tr><td>USERNAME</td><td>COUNT</td><tr>
--select username, profile from dba_users where profile not in ('DEFAULT', 'APPLICATION_USER', 'HUMAN_USER', 'SYSTEM_USER', 'ADMIN_USER');
select '<tr><td>'||profile||'</td><td>'||count(*)||'</td><tr>'
   from dba_profiles where profile not in ('DEFAULT', 'APPLICATION_USER', 'HUMAN_USER', 'SYSTEM_USER', 'ADMIN_USER')
group by profile;

prompt </table>

--prompt !! CHECKPOINT ACTION:  Check users assigned to non-standard profiles. !!
--prompt !! Prepare a script to modify as necessary !!
prompt <br>

prompt <table border="1" width="100%">
prompt <tr><td colspan=2>USERS THAT BELONG TO DEFAULT PROFILE</td></tr>

prompt <tr><td>USERNAME</td></tr>

select '<tr><td>'||username||'</td><td>'||profile||'</td></tr>' from dba_users where profile = 'DEFAULT' and username <> 'XS$NULL';

--prompt !! CHECKPOINT ACTION: Only X$NULL should be on DEFAULT profile. Remediate as necessary !!

prompt </table>
prompt <br>

prompt <table border="1" width="100%">
prompt <tr><td colspan=3>CHECK UMS DEFAULT PROFILE: Should be HUMAN_USER</td></tr>

prompt <tr><td>USER_TYPE</td><td>BYPASS_RESOURCE_RESTRICTION</td><td>PROFILE_NAME</td></tr>
--SELECT * FROM user_management.UM_USER_TYPE_PROFILE WHERE user_type = 'HUMAN';
SELECT 
'<tr><td>'||USER_TYPE||'</td><td>'||        
BYPASS_RESOURCE_RESTRICTION||'</td><td>'||
PROFILE_NAME||'</td></tr>'
FROM user_management.UM_USER_TYPE_PROFILE WHERE user_type = 'HUMAN' and PROFILE_NAME <> 'HUMAN_USER';

prompt </table>
prompt <br>
--prompt !! CHECKPOINT ACTION:  Check if the profile above is HUMAN_USER (as it should be) !!

prompt <table border="1" width="100%">
prompt <tr><td colspan=2>CHECK ORACLE USERS WITH DEFAULT PASSWORD</td></tr>

col username for a40
col product for a40
prompt <tr><td>USERNAME</td><td>PRODUCT</td></tr>
select '<tr><td>'||username||'</td><td>'||product||'</td></tr>'
 from dba_users_with_defpwd;

prompt </table>
prompt <br>

--prompt !! CHECKPOINT ACTION:  Check if there are entries above. If there are !!
--prompt !! The password needs to be changed and stored in Cyberark !!

col username for a30
col profile for a20

prompt <table border="1" width="100%">
prompt <tr><td colspan=2>CHECK DBA's PROFILES are ADMIN_USERS</td></tr>

prompt <tr><td>USERNAME</td><td>PROFILE</td></tr>
--select username, profile from dba_users where username in (select grantee from  dba_role_privs where granted_role='DBA');
select '<tr><td>'||username||'</td><td>'|| profile||'</td></tr>'
 from dba_users where username in (select grantee from  dba_role_privs where granted_role='DBA')
and profile <> 'ADMIN_USER';

prompt </table>
prompt <br>
--prompt !! CHECKPOINT ACTION:  Check if the profile above is ADMIN_USER if a person or APPLICATION_USER of required for jobs (as it should be) !!

prompt <table border="1" width="100%">
prompt <tr><td colspan=2>CHECK OEM_TASKS's PROFILE is NOT APPLICATION_USER</td></tr>
col username for a30
col profile for a20
prompt <tr><td>USERNAME</td><td>PROFILE</td></tr>
--select username, profile from dba_users where username = 'OEM_TASKS';
select '<tr><td>'||username||'</td><td>'|| profile||'</td></tr>'
from dba_users where username = 'OEM_TASKS' and profile <> 'APPLICATION_USER';

prompt </table>
prompt <br>

prompt <table border="1" width="100%">
prompt <tr><td colspan=3>CHECK DEFAULT PROFILE IS TO NOT STANDARD</td></tr>
prompt <tr><td>PROFILE</td><td>RESOURCE_NAME</td><td>LIMIT</td></tr>

--prompt !! CHECKPOINT ACTION:  Check if the entries above are correct.
--prompt !! The profile needs to be changed, the password reset to not expire (moving the profil only does not do this)  and stored in Cyberark !!
--prompt ==========================================================
--prompt CHECK DEFAULT PROFILE IS TO NOT STANDARD
--prompt ==========================================================
--prompt PROFILE    RESOURCE_NAME                  LIMIT
--prompt ---------- ------------------------------ ---------------------
--prompt
--prompt DEFAULT              COMPOSITE_LIMIT                UNLIMITED
--prompt DEFAULT              CONNECT_TIME                   UNLIMITED
--prompt DEFAULT              CPU_PER_CALL                   UNLIMITED
--prompt DEFAULT              CPU_PER_SESSION                UNLIMITED
--prompt DEFAULT              FAILED_LOGIN_ATTEMPTS          10
--prompt DEFAULT              IDLE_TIME                      UNLIMITED
--prompt DEFAULT              LOGICAL_READS_PER_CALL         UNLIMITED
--prompt DEFAULT              LOGICAL_READS_PER_SESSION      UNLIMITED
--prompt DEFAULT              PASSWORD_GRACE_TIME            7
--prompt DEFAULT              PASSWORD_LIFE_TIME             180
--prompt DEFAULT              PASSWORD_LOCK_TIME             1
--prompt DEFAULT              PASSWORD_REUSE_MAX             9
--prompt DEFAULT              PASSWORD_REUSE_TIME            UNLIMITED
--prompt DEFAULT              PASSWORD_VERIFY_FUNCTION       MRKT_PASS_VERIFY
--prompt DEFAULT              PRIVATE_SGA                    UNLIMITED
--prompt DEFAULT              SESSIONS_PER_USER              UNLIMITED

col profile for a20
col resource_name for a30
col limit for a30

--select profile, resource_name, limit from dba_profiles where profile='DEFAULT' order by resource_name;

select 
'<tr><td>'||profile||'</td><td>'||resource_name||'</td><td>'|| limit||'</td>'
 from 
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

prompt </table>
prompt <br>

--prompt !! CHECKPOINT ACTION:  Check if there are entries above that do not match !!
--prompt !! A script needs to be run to change this !!

prompt <table border="1" width="100%">
prompt <tr><td colspan=3>CHECK HUMAN_USER PROFILE IS TO NOT STANDARD</td></tr>
prompt <tr><td>PROFILE</td><td>RESOURCE_NAME</td><td>LIMIT</td></tr>

--prompt PROFILE    RESOURCE_NAME                  LIMIT
--prompt ---------- ------------------------------ ---------------
--prompt
--prompt HUMAN_USER           COMPOSITE_LIMIT                UNLIMITED
--prompt HUMAN_USER           CONNECT_TIME                   UNLIMITED
--prompt HUMAN_USER           CPU_PER_CALL                   UNLIMITED
--prompt HUMAN_USER           CPU_PER_SESSION                UNLIMITED
--prompt HUMAN_USER           FAILED_LOGIN_ATTEMPTS          5
--prompt HUMAN_USER           IDLE_TIME                      60
--prompt HUMAN_USER           LOGICAL_READS_PER_CALL         UNLIMITED
--prompt HUMAN_USER           LOGICAL_READS_PER_SESSION      UNLIMITED
--prompt HUMAN_USER           PASSWORD_GRACE_TIME            7
--prompt HUMAN_USER           PASSWORD_LIFE_TIME             90
--prompt HUMAN_USER           PASSWORD_LOCK_TIME             1
--prompt HUMAN_USER           PASSWORD_REUSE_MAX             9
--prompt HUMAN_USER           PASSWORD_REUSE_TIME            180
--prompt HUMAN_USER           PASSWORD_VERIFY_FUNCTION       MRKT_PASS_VERIFY
--prompt HUMAN_USER           PRIVATE_SGA                    UNLIMITED
--prompt HUMAN_USER           SESSIONS_PER_USER              5
--prompt ==========================================================
col profile for a20
col resource_name for a30
col limit for a60

select 
'<tr><td>'||profile||'</td><td>'||resource_name||'</td><td>'|| limit||'</td>'
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

prompt </table>
prompt <br>
--select profile, resource_name, limit from dba_profiles where profile='HUMAN_USER' order by resource_name;

prompt <table border="1" width="100%">
prompt <tr><td colspan=3>CHECK APPLICATION_USER PROFILE IS NOT STANDARD</td></tr>
prompt <tr><td>PROFILE</td><td>RESOURCE_NAME</td><td>LIMIT</td></tr>

--prompt PROFILE    RESOURCE_NAME                  LIMIT
--prompt ---------- ------------------------------ ---------------
--prompt
--prompt APPLICATION_USER     COMPOSITE_LIMIT                UNLIMITED
--prompt APPLICATION_USER     CONNECT_TIME                   UNLIMITED
--prompt APPLICATION_USER     CPU_PER_CALL                   UNLIMITED
--prompt APPLICATION_USER     CPU_PER_SESSION                UNLIMITED
--prompt APPLICATION_USER     FAILED_LOGIN_ATTEMPTS          UNLIMITED
--prompt APPLICATION_USER     IDLE_TIME                      UNLIMITED
--prompt APPLICATION_USER     LOGICAL_READS_PER_CALL         UNLIMITED
--prompt APPLICATION_USER     LOGICAL_READS_PER_SESSION      UNLIMITED
--prompt APPLICATION_USER     PASSWORD_GRACE_TIME            UNLIMITED
--prompt APPLICATION_USER     PASSWORD_LIFE_TIME             UNLIMITED
--prompt APPLICATION_USER     PASSWORD_LOCK_TIME             1
--prompt APPLICATION_USER     PASSWORD_REUSE_MAX             9
--prompt APPLICATION_USER     PASSWORD_REUSE_TIME            UNLIMITED
--prompt APPLICATION_USER     PASSWORD_VERIFY_FUNCTION       MRKT_PASS_VERIFY_SER
--prompt APPLICATION_USER     PRIVATE_SGA                    UNLIMITED
--prompt APPLICATION_USER     SESSIONS_PER_USER              UNLIMITED
--prompt ==========================================================
col profile for a20
col resource_name for a30
col limit for a60
--select profile, resource_name, limit from dba_profiles where profile='APPLICATION_USER' order by resource_name;

select 
'<tr><td>'||profile||'</td><td>'||resource_name||'</td><td>'|| limit||'</td>' 
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

prompt </table>
prompt <br>

prompt <table border="1" width="100%">
prompt <tr><td colspan=3>CHECK ADMIN_USER PROFILE IS NOT STANDARD</td></tr>
prompt <tr><td>PROFILE</td><td>RESOURCE_NAME</td><td>LIMIT</td></tr>

--prompt PROFILE    RESOURCE_NAME                  LIMIT
--prompt ---------- ------------------------------ ---------------
--prompt
--prompt ADMIN_USER           COMPOSITE_LIMIT                UNLIMITED
--prompt ADMIN_USER           CONNECT_TIME                   UNLIMITED
--prompt ADMIN_USER           CPU_PER_CALL                   UNLIMITED
--prompt ADMIN_USER           CPU_PER_SESSION                UNLIMITED
--prompt ADMIN_USER           FAILED_LOGIN_ATTEMPTS          5
--prompt ADMIN_USER           IDLE_TIME                      60
--prompt ADMIN_USER           LOGICAL_READS_PER_CALL         UNLIMITED
--prompt ADMIN_USER           LOGICAL_READS_PER_SESSION      UNLIMITED
--prompt ADMIN_USER           PASSWORD_GRACE_TIME            7
--prompt ADMIN_USER           PASSWORD_LIFE_TIME             90
--prompt ADMIN_USER           PASSWORD_LOCK_TIME             1
--prompt ADMIN_USER           PASSWORD_REUSE_MAX             9
--prompt ADMIN_USER           PASSWORD_REUSE_TIME            180
--prompt ADMIN_USER           PASSWORD_VERIFY_FUNCTION       MRKT_PASS_VERIFY_PRI
--prompt ADMIN_USER           PRIVATE_SGA                    UNLIMITED
--prompt ADMIN_USER           SESSIONS_PER_USER              5
--prompt ==========================================================
col profile for a20
col resource_name for a30
col limit for a60
--select profile, resource_name, limit from dba_profiles where profile='ADMIN_USER' order by resource_name;


select 
'<tr><td>'||profile||'</td><td>'||resource_name||'</td><td>'|| limit||'</td>' 
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


prompt </table>
prompt <br>

prompt <table border="1" width="100%">
prompt <tr><td colspan=3>CHECK SYSTEM_USER PROFILE IS NOT STANDARD</td></tr>
prompt <tr><td>PROFILE</td><td>RESOURCE_NAME</td><td>LIMIT</td></tr>

--prompt PROFILE    RESOURCE_NAME                  LIMIT
--prompt ---------- ------------------------------ ---------------
--prompt
--prompt SYSTEM_USER          COMPOSITE_LIMIT                UNLIMITED
--prompt SYSTEM_USER          CONNECT_TIME                   UNLIMITED
--prompt SYSTEM_USER          CPU_PER_CALL                   UNLIMITED
--prompt SYSTEM_USER          CPU_PER_SESSION                UNLIMITED
--prompt SYSTEM_USER          FAILED_LOGIN_ATTEMPTS          UNLIMITED
--prompt SYSTEM_USER          IDLE_TIME                      UNLIMITED
--prompt SYSTEM_USER          LOGICAL_READS_PER_CALL         UNLIMITED
--prompt SYSTEM_USER          LOGICAL_READS_PER_SESSION      UNLIMITED
--prompt SYSTEM_USER          PASSWORD_GRACE_TIME            7
--prompt SYSTEM_USER          PASSWORD_LIFE_TIME             UNLIMITED
--prompt SYSTEM_USER          PASSWORD_LOCK_TIME             UNLIMITED
--prompt SYSTEM_USER          PASSWORD_REUSE_MAX             9
--prompt SYSTEM_USER          PASSWORD_REUSE_TIME            180
--prompt SYSTEM_USER          PASSWORD_VERIFY_FUNCTION       MRKT_PASS_VERIFY_SER
--prompt SYSTEM_USER          PRIVATE_SGA                    UNLIMITED
--prompt SYSTEM_USER          SESSIONS_PER_USER              UNLIMITED
--prompt ==========================================================
col profile for a20
col resource_name for a30
col limit for a60
--select profile, resource_name, limit from dba_profiles where profile='SYSTEM_USER' order by resource_name;

select 
'<tr><td>'||profile||'</td><td>'||resource_name||'</td><td>'|| limit||'</td>' 
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
prompt </table>
prompt <br>
prompt </html>
