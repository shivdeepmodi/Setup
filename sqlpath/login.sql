define _editor=vi
set serveroutput on size 1000000 lines 300 trimspool on pages 10000 long 10000000 head on feedback on sqlnumber off
set time off
--set null NULL
rem Settings for autotrace begin

column parent_id_plus_exp	format 999
column id_plus_exp		format 990
column plan_plus_exp 		format a90
column other_plus_exp		format a90
column other_tag_plus_exp	format a29
column object_node_plus_exp	format a14

rem Settings for autotrace end
set termout off
@date
set termout on
@prompt
@db1
set feedback off verify off
@db
set feedback on verify on
set head off feedback off
@name
set head on feedback on
--ho title &&_connect_identifier
set timing on
