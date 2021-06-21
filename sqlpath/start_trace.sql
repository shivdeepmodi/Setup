set verify off
EXEC DBMS_SYSTEM.set_ev(&sid, &serial, 10046, &level, '');
set verify on
