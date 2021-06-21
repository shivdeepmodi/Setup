Column sid                      heading 'Blocked Session'                     format 99999
Column serial#                  heading 'SERIAL#'                 format 99999
Column osuser                   heading 'Osuser'                  format a10
Column program                  heading 'Program'                 format a20
Column command                  heading 'Command'                 format a10
Column username                 heading 'Username'                format a13
Column machine                  format a12
Column blocker                  heading 'Blocker'       format a15
Column Waiter                  heading 'Waiter'       format a15
Column blocked_session          heading 'Waiter'        format a20
Column Waiting format a30

prompt Blockers
prompt ========
select blocker.sid||':'||blocker.serial# blocker,blocker.username ,blocker.osuser ,blocker.machine, blocker.program,blocker.logon_time
  from gv$session blocker, gv$session blocking_session
 where blocker.sid = blocking_session.blocking_session
;


prompt Waiter
prompt ========
select sid||':'||serial# Waiter,username ,osuser ,machine, program,
LPAD (TO_CHAR (TRUNC (last_call_et / 3600)), 2, '0')|| ':'|| LPAD (TO_CHAR (MOD (TRUNC (last_call_et / 60), 60)), 2, '0')|| ':'
|| LPAD (TO_CHAR (MOD (last_call_et, 60)), 2, '0') WAITING
  from gv$session
 where blocking_session is not null
;