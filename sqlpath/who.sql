column current_user heading 'Current User'  format a15
column isdba        heading 'Is DBA?'       format a6
select SYS_CONTEXT('USERENV','SESSION_USER') Current_user,
       SYS_CONTEXT('USERENV','ISDBA') ISDBA
  from dual
/