column name for a21
column value for a10
column type  for a10
column description for a35
column update_comment for a30
column IS_MODIFIED for a12
column IS_ADJUSTED for a12
column isdefault for a10
column ISSES_MODIFIABLE for a17
column ISSYS_MODIFIABLE for a20
accept vparam prompt 'Enter search value : '

set verify off

SELECT
  x.ksppinm name,
  y.ksppstvl VALUE,
  decode(ksppity,
    1,   'BOOLEAN',
    2,   'STRING',
    3,   'INTEGER',
    4,   'PARAMETER FILE',
    5,   'RESERVED',
    6,   'BIG INTEGER',
    'UNKNOWN') type,
  decode(ksppstdf,
    'TRUE',   'DEFAULT VALUE',
    'FALSE',   'INIT.ORA') isdefault,
  decode(bitand(ksppiflg / 256,   1),
    1,   'IS_SESS_MOD(TRUE)',
    'FALSE') isses_modifiable,
  decode(bitand(ksppiflg / 65536,   3),
    1,   'MODSYS(NONDEFERED)',
    2,   'MODSYS(DEFERED)',
    3,   'MODSYS(*NONDEFERED*)',
    'FALSE') issys_modifiable,
  decode(bitand(ksppstvf,   7),
    1,   'MODIFIED_BY(SESSION)',
    4,   'MODIFIED_BY(SYSTEM)',
    'FALSE') is_modified,
  decode(bitand(ksppstvf,   2),
    2,   'ORA_STARTUP_MOD(TRUE)',
    'FALSE') is_adjusted,
  ksppdesc description,
  ksppstcmnt update_comment
FROM x$ksppi x,
  x$ksppcv y
WHERE x.inst_id = userenv('Instance')
 AND y.inst_id = userenv('Instance')
 AND x.indx = y.indx
 AND x.ksppinm LIKE lower('%&vparam%')
/
set verify on