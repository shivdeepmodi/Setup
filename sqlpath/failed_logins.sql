Column osuser      heading 'Osuser'    format a15
Column username    heading 'Username'  format a15
Column userhost    heading 'Userhost'  format a10
Column timestamp   heading 'Timestamp' format a20
Column action_name heading 'Action'    format a10
Column result      heading 'Result'    format a9
Column client_id   heading 'Client ID' format a10
Column terminal    heading 'Terminal'  format a10

select substr(os_username,1,10) osuser, 
       username, 
       substr(userhost,1,10) userhost, 
       timestamp, 
       action_name action,
       decode(returncode,'0','Succeeded','Failed') result,
       client_id,
       terminal
  from sys.dba_audit_session
/
clear columns