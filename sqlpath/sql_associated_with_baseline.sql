set serveroutput on
set verify off
declare

-- Purpose:     Return SQL_ID or PLAN_HASH_VALUE associated with a SQL Plan Management Baseline.
--
-- Author:      Kerry Osborne
--
-- Usage:       This scripts creates a function called basline_info. The function returns a
--              SQL_ID or a PLAN_HASH_VALUE for a baseline It takes as input a PLAN_NAME
--              for a Baseline and a text field that specifies what info to return (at
--              this point the valid values are SQL_ID or PLAN_HASH_VALUE). 
--
-- Description:
--
--              This function is based on work done by Marcin Przepiorowski published 
--              here: http://oracleprof.blogspot.com/2011/07/how-to-find-sqlid-and-planhashvalue-in.html
--              Marcin's work was based on research by Tanel Poder.
--
--              See kerryosborne.oracle-guy.com for additional information.
---------------------------------------------------------------------------------------
  v_sqlid VARCHAR2(13);
  v_num number;
p_info_type varchar2(32):='SQL_ID';
begin
  for a in (select sql_handle, plan_name, trim(substr(g.PLAN_TABLE_OUTPUT,instr(g.PLAN_TABLE_OUTPUT,':')+1)) plan_hash_value, sql_text
              from (select t.*, c.sql_handle, c.plan_name, c.sql_text from dba_sql_plan_baselines c, table(dbms_xplan.DISPLAY_SQL_PLAN_BASELINE(c.sql_handle, c.plan_name)) t
              where c.plan_name = '&p_plan_name') g
              where PLAN_TABLE_OUTPUT like 'Plan hash value%') loop
    v_num := to_number(sys.UTL_RAW.reverse(sys.UTL_RAW.SUBSTR(sys.dbms_crypto.hash(src => UTL_I18N.string_to_raw(a.sql_text || chr(0),'AL32UTF8'), typ => 2),9,4)) || 
             sys.UTL_RAW.reverse(sys.UTL_RAW.SUBSTR(sys.dbms_crypto.hash(src => UTL_I18N.string_to_raw(a.sql_text || chr(0),'AL32UTF8'), typ => 2),13,4)),RPAD('x', 16, 'x'));
    v_sqlid := '';
    for i in 0 .. floor(ln(v_num) / ln(32)) loop
        v_sqlid := substr('0123456789abcdfghjkmnpqrstuvwxyz',floor(mod(v_num / power(32, i), 32)) + 1,1) || v_sqlid;
    end loop;
   /* if upper(p_info_type) = 'SQL_ID' then
       dbms_output.put_line(lpad(v_sqlid,13,'0')) ;
    elsif upper(p_info_type) = 'PLAN_HASH_VALUE' then
       dbms_output.put_line(a.plan_hash_value,15);
    else
       dbms_output.put_line('Null...');
    end if;
	*/
	dbms_output.put_line(chr(10));
	dbms_output.put_line('SQL_Handle          '||chr(9)||'PLAN_NAME                     '||chr(9)||'SQL_ID       '||chr(9)||'PLAN_HASH_VALUE');
	dbms_output.put_line('--------------------'||chr(9)||'------------------------------'||chr(9)||'-------------'||chr(9)||'---------------');
	dbms_output.put_line(a.sql_handle||chr(9)||a.plan_name||chr(9)||v_sqlid||chr(9)||a.plan_hash_value);
	/*dbms_output.put_line(a.sql_handle) ;
	dbms_output.put_line(a.plan_name) ;
	dbms_output.put_line(lpad(v_sqlid,13,'0')) ;
	dbms_output.put_line(a.plan_hash_value);*/
	
  end loop;
--  dbms_output.put_line('UNKOWN');
exception when others then
  dbms_output.put_line( 'UNKOWN');
end;
/