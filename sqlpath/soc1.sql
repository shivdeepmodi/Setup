set lines 150 pages 30
col profile for a30
col username for a40

prompt ==========================================================
prompt PROFILES ON THE DATABASE
prompt ==========================================================

select distinct profile from dba_profiles;

prompt ==========================================================
prompt NON-STANDARD PROFILES ON THIS DATABASE
prompt ==========================================================

select distinct profile from dba_profiles where profile not in ('DEFAULT', 'APPLICATION_USER', 'HUMAN_USER', 'SYSTEM_USER', 'ADMIN_USER');

prompt !! CHECKPOINT ACTION: There should only be DEFAULT, APPLICATION_USER, HUMAN_USER, SYSTEM_USER, ADMIN_USER. NOTE ANY EXCEPTIONS !!

pause

prompt ==========================================================
prompt USERS THAT DO NOT BELONG TO STANDARD PROFILES
prompt ==========================================================

select username, profile from dba_users where profile not in ('DEFAULT', 'APPLICATION_USER', 'HUMAN_USER', 'SYSTEM_USER', 'ADMIN_USER');

prompt !! CHECKPOINT ACTION:  Check users assigned to non-standard profiles. !!
prompt !! Prepare a script to modify as necessary !!

pause

prompt ==========================================================
prompt USERS THAT BELONG TO DEFAULT PROFILE
prompt ==========================================================

select username, profile from dba_users where profile = 'DEFAULT';

prompt !! CHECKPOINT ACTION: Only X$NULL should be on DEFAULT profile. Remediate as necessary !!

pause

prompt ==========================================================
prompt CHECK UMS DEFAULT PROFILE
prompt ==========================================================

SELECT * FROM user_management.UM_USER_TYPE_PROFILE WHERE user_type = 'HUMAN';

prompt !! CHECKPOINT ACTION:  Check if the profile above is HUMAN_USER (as it should be) !!
pause

prompt ==========================================================
prompt CHECK ORACLE USERS WITH DEFAULT PASSWORD THAT ARE NOT LOCKED
prompt ==========================================================
col username for a40
col product for a40
select a.*,b.account_status from dba_users_with_defpwd a join dba_users b on (a.username = b.username);


prompt !! CHECKPOINT ACTION:  Check if there are entries above. If there are !!
prompt !! The password needs to be changed and stored in Cyberark!!
pause

prompt ==========================================================
prompt CHECK DBA's PROFILES are ADMIN_USERS
prompt ==========================================================
col username for a30
col profile for a20

select username, profile from dba_users where username in (select grantee from  dba_role_privs where granted_role='DBA');

prompt !! CHECKPOINT ACTION:  Check if the profile above is ADMIN_USER if a person or APPLICATION_USER of required for jobs (as it should be) !!
pause

prompt ==========================================================
prompt CHECK OEM_TASKS's PROFILE is APPLICATION_USER
prompt ==========================================================
col username for a30
col profile for a20

select username, profile from dba_users where username = 'OEM_TASKS';

prompt !! CHECKPOINT ACTION:  Check if the entries above are correct. 
prompt !! The profile needs to be changed, the password reset to not expire (moving the profil only does not do this)  and stored in Cyberark !!
pause

prompt ==========================================================
prompt CHECK DEFAULT PROFILE IS TO STANDARD 
prompt ==========================================================
prompt PROFILE    RESOURCE_NAME                  LIMIT
prompt ---------- ------------------------------ ---------------=
prompt
prompt DEFAULT              COMPOSITE_LIMIT                UNLIMITED
prompt DEFAULT              CONNECT_TIME                   UNLIMITED
prompt DEFAULT              CPU_PER_CALL                   UNLIMITED
prompt DEFAULT              CPU_PER_SESSION                UNLIMITED
prompt DEFAULT              FAILED_LOGIN_ATTEMPTS          10
prompt DEFAULT              IDLE_TIME                      UNLIMITED
prompt DEFAULT              LOGICAL_READS_PER_CALL         UNLIMITED
prompt DEFAULT              LOGICAL_READS_PER_SESSION      UNLIMITED
prompt DEFAULT              PASSWORD_GRACE_TIME            7
prompt DEFAULT              PASSWORD_LIFE_TIME             180
prompt DEFAULT              PASSWORD_LOCK_TIME             1
prompt DEFAULT              PASSWORD_REUSE_MAX             9
prompt DEFAULT              PASSWORD_REUSE_TIME            UNLIMITED
prompt DEFAULT              PASSWORD_VERIFY_FUNCTION       MRKT_PASS_VERIFY
prompt DEFAULT              PRIVATE_SGA                    UNLIMITED
prompt DEFAULT              SESSIONS_PER_USER              UNLIMITED
prompt ==========================================================
col profile for a20
col resource_name for a30
col limit for a20
select profile, resource_name, limit from dba_profiles where profile='DEFAULT' order by resource_name;


prompt !! CHECKPOINT ACTION:  Check if there are entries above that do not match !!
prompt !! A script needs to be run to change this !!
pause

prompt ==========================================================
prompt CHECK HUMAN_USER PROFILE IS TO STANDARD
prompt ==========================================================
prompt PROFILE    RESOURCE_NAME                  LIMIT
prompt ---------- ------------------------------ ---------------=
prompt
prompt HUMAN_USER           COMPOSITE_LIMIT                UNLIMITED
prompt HUMAN_USER           CONNECT_TIME                   UNLIMITED
prompt HUMAN_USER           CPU_PER_CALL                   UNLIMITED
prompt HUMAN_USER           CPU_PER_SESSION                UNLIMITED
prompt HUMAN_USER           FAILED_LOGIN_ATTEMPTS          5
prompt HUMAN_USER           IDLE_TIME                      60
prompt HUMAN_USER           LOGICAL_READS_PER_CALL         UNLIMITED
prompt HUMAN_USER           LOGICAL_READS_PER_SESSION      UNLIMITED
prompt HUMAN_USER           PASSWORD_GRACE_TIME            7
prompt HUMAN_USER           PASSWORD_LIFE_TIME             90
prompt HUMAN_USER           PASSWORD_LOCK_TIME             1
prompt HUMAN_USER           PASSWORD_REUSE_MAX             9
prompt HUMAN_USER           PASSWORD_REUSE_TIME            180
prompt HUMAN_USER           PASSWORD_VERIFY_FUNCTION       MRKT_PASS_VERIFY
prompt HUMAN_USER           PRIVATE_SGA                    UNLIMITED
prompt HUMAN_USER           SESSIONS_PER_USER              5
prompt ==========================================================
col profile for a20
col resource_name for a30
col limit for a20
select profile, resource_name, limit from dba_profiles where profile='HUMAN_USER' order by resource_name;

prompt !! CHECKPOINT ACTION:  Check if there are entries above that do not match !!
prompt !! A script needs to be run to change this !!
pause

prompt ==========================================================
prompt CHECK APPLICATION_USER PROFILE IS TO STANDARD
prompt ==========================================================
prompt PROFILE    RESOURCE_NAME                  LIMIT
prompt ---------- ------------------------------ ---------------=
prompt
prompt APPLICATION_USER     COMPOSITE_LIMIT                UNLIMITED
prompt APPLICATION_USER     CONNECT_TIME                   UNLIMITED
prompt APPLICATION_USER     CPU_PER_CALL                   UNLIMITED
prompt APPLICATION_USER     CPU_PER_SESSION                UNLIMITED
prompt APPLICATION_USER     FAILED_LOGIN_ATTEMPTS          UNLIMITED
prompt APPLICATION_USER     IDLE_TIME                      UNLIMITED
prompt APPLICATION_USER     LOGICAL_READS_PER_CALL         UNLIMITED
prompt APPLICATION_USER     LOGICAL_READS_PER_SESSION      UNLIMITED
prompt APPLICATION_USER     PASSWORD_GRACE_TIME            UNLIMITED
prompt APPLICATION_USER     PASSWORD_LIFE_TIME             UNLIMITED
prompt APPLICATION_USER     PASSWORD_LOCK_TIME             1
prompt APPLICATION_USER     PASSWORD_REUSE_MAX             9
prompt APPLICATION_USER     PASSWORD_REUSE_TIME            UNLIMITED
prompt APPLICATION_USER     PASSWORD_VERIFY_FUNCTION       MRKT_PASS_VERIFY_SER
prompt APPLICATION_USER     PRIVATE_SGA                    UNLIMITED
prompt APPLICATION_USER     SESSIONS_PER_USER              UNLIMITED
prompt ==========================================================
col profile for a20
col resource_name for a30
col limit for a20
select profile, resource_name, limit from dba_profiles where profile='APPLICATION_USER' order by resource_name;


prompt !! CHECKPOINT ACTION:  Check if there are entries above that do not match !!
prompt !! A script needs to be run to change this !!
pause



prompt ==========================================================
prompt CHECK ADMIN_USER PROFILE IS TO STANDARD
prompt ==========================================================
prompt PROFILE    RESOURCE_NAME                  LIMIT
prompt ---------- ------------------------------ ---------------=
prompt ADMIN_USER           COMPOSITE_LIMIT                UNLIMITED
prompt ADMIN_USER           CONNECT_TIME                   UNLIMITED
prompt ADMIN_USER           CPU_PER_CALL                   UNLIMITED
prompt ADMIN_USER           CPU_PER_SESSION                UNLIMITED
prompt ADMIN_USER           FAILED_LOGIN_ATTEMPTS          5
prompt ADMIN_USER           IDLE_TIME                      60
prompt ADMIN_USER           LOGICAL_READS_PER_CALL         UNLIMITED
prompt ADMIN_USER           LOGICAL_READS_PER_SESSION      UNLIMITED
prompt ADMIN_USER           PASSWORD_GRACE_TIME            7
prompt ADMIN_USER           PASSWORD_LIFE_TIME             90
prompt ADMIN_USER           PASSWORD_LOCK_TIME             1
prompt ADMIN_USER           PASSWORD_REUSE_MAX             9
prompt ADMIN_USER           PASSWORD_REUSE_TIME            180
prompt ADMIN_USER           PASSWORD_VERIFY_FUNCTION       MRKT_PASS_VERIFY_PRI
prompt ADMIN_USER           PRIVATE_SGA                    UNLIMITED
prompt ADMIN_USER           SESSIONS_PER_USER              5
prompt ==========================================================
col profile for a20
col resource_name for a30
col limit for a20
select profile, resource_name, limit from dba_profiles where profile='ADMIN_USER' order by resource_name;


prompt !! CHECKPOINT ACTION:  Check if there are entries above that do not match !!
prompt !! A script needs to be run to change this !!
pause


prompt ==========================================================
prompt CHECK SYSTEM_USER PROFILE IS TO STANDARD
prompt ==========================================================
prompt PROFILE    RESOURCE_NAME                  LIMIT
prompt ---------- ------------------------------ ---------------=
prompt SYSTEM_USER          COMPOSITE_LIMIT                UNLIMITED
prompt SYSTEM_USER          CONNECT_TIME                   UNLIMITED
prompt SYSTEM_USER          CPU_PER_CALL                   UNLIMITED
prompt SYSTEM_USER          CPU_PER_SESSION                UNLIMITED
prompt SYSTEM_USER          FAILED_LOGIN_ATTEMPTS          UNLIMITED
prompt SYSTEM_USER          IDLE_TIME                      UNLIMITED
prompt SYSTEM_USER          LOGICAL_READS_PER_CALL         UNLIMITED
prompt SYSTEM_USER          LOGICAL_READS_PER_SESSION      UNLIMITED
prompt SYSTEM_USER          PASSWORD_GRACE_TIME            7
prompt SYSTEM_USER          PASSWORD_LIFE_TIME             UNLIMITED
prompt SYSTEM_USER          PASSWORD_LOCK_TIME             UNLIMITED
prompt SYSTEM_USER          PASSWORD_REUSE_MAX             9
prompt SYSTEM_USER          PASSWORD_REUSE_TIME            180
prompt SYSTEM_USER          PASSWORD_VERIFY_FUNCTION       MRKT_PASS_VERIFY_SER
prompt SYSTEM_USER          PRIVATE_SGA                    UNLIMITED
prompt SYSTEM_USER          SESSIONS_PER_USER              UNLIMITED
prompt ==========================================================
col profile for a20
col resource_name for a30
col limit for a20
select profile, resource_name, limit from dba_profiles where profile='SYSTEM_USER' order by resource_name;


prompt !! CHECKPOINT ACTION:  Check if there are entries above that do not match !!
prompt !! A script needs to be run to change this !!
pause



exit;
