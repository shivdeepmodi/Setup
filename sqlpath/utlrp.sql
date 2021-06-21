DOC
######################################################################
######################################################################
    Generic script to call utlrp.sql for different versions
    The following statement will cause an "ORA-01722: invalid number"
    error and terminate the SQLPLUS session if the user is not SYS.
    Disconnect and reconnect with AS SYSDBA.
######################################################################
######################################################################
#
set termout off verify off feedback off
WHENEVER SQLERROR EXIT
column db_ver    new_value db_ver
column file_name new_value file_name

SELECT TO_NUMBER('MUST_BE_AS_SYSDBA') FROM DUAL
WHERE USER != 'SYS';

WHENEVER SQLERROR CONTINUE;

select substr(banner,instr(banner,'Release')+8, instr(banner,'-') - instr(banner,'Release')-9) as db_ver
  from v$version 
 where rownum < 2
/

set termout on
select decode('&&db_ver','8.1.7.4.0' ,'%SQLPATH%\8.1.7.4.0\utlrp.sql'
                        ,'10.2.0.2.0','%SQLPATH%\10.2.0.2.0\utlrp.sql'
                        ,'10.2.0.3.0','%SQLPATH%\10.2.0.3.0\utlrp.sql'
                        ,'10.2.0.4.0','%SQLPATH%\10.2.0.4.0\utlrp.sql'
                        ,'%SQLPATH%\vns.sql') as file_name
       from dual;
set verify on feedback on
@&file_name
