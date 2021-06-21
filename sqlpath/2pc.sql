column local_tran_id  heading 'Local Transaction ID' format a20
column global_tran_id heading 'Global Transaction ID'format a30
column tran_comment   heading 'Transaction Comment'  format a20
column retry_time     heading 'Retry Time'           format a20      
column os_user        heading 'Osuser'               format a20 
column os_terminal    heading 'Terminal'             format a20
column db_user        heading 'Username'             format a20                
column commit#        heading 'Commit#'              format a20
Column state          heading 'State'                format a14
Column mixed          heading 'Mixed'                format a5
Column host           heading 'Host'                 format a10
select local_tran_id, global_tran_id, mixed,state, os_user, mixed, host
  from dba_2pc_pending;
clear columns