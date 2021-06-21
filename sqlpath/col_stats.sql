set verify off timing off
COL owner FOR A20
COL table_owner FOR A20
COL table_name FOR A30
COL column_name FOR A30
COL num_distinct FOR 9999999999999
COL density FOR 99
COL num_nulls FOR 99999
COL num_buckets FOR 999
COL histogram FOR A10
 


col data_type    form a12
col M            form a1
col num_vals     form 999999999999
col dnsty        form 0.9999
col num_nulls    form 99999,999
col low_v        form a18
col hi_v         form a18
col data_type    form a10

col partition_name for a25
col high_value for a90
col last_analyzed for a20

prompt Table Stats

select owner
      ,table_name
      ,column_name
      ,data_type
      ,decode (nullable,'N','Y','N')  M
      ,num_distinct num_vals
      ,num_nulls
      ,density dnsty
,decode(data_type
  ,'NUMBER'       ,to_char(utl_raw.cast_to_number(low_value))
  ,'VARCHAR2'     ,to_char(utl_raw.cast_to_varchar2(low_value))
  ,'NVARCHAR2'    ,to_char(utl_raw.cast_to_nvarchar2(low_value))
  ,'BINARY_DOUBLE',to_char(utl_raw.cast_to_binary_double(low_value))
  ,'BINARY_FLOAT' ,to_char(utl_raw.cast_to_binary_float(low_value))
  ,'DATE',to_char(1780+to_number(substr(low_value,1,2),'XX')
         +to_number(substr(low_value,3,2),'XX'))||'-'
       ||to_number(substr(low_value,5,2),'XX')||'-'
       ||to_number(substr(low_value,7,2),'XX')||' '
       ||(to_number(substr(low_value,9,2),'XX')-1)||':'
       ||(to_number(substr(low_value,11,2),'XX')-1)||':'
       ||(to_number(substr(low_value,13,2),'XX')-1)
,  low_value
       ) low_v
,decode(data_type
  ,'NUMBER'       ,to_char(utl_raw.cast_to_number(high_value))
  ,'VARCHAR2'     ,to_char(utl_raw.cast_to_varchar2(high_value))
  ,'NVARCHAR2'    ,to_char(utl_raw.cast_to_nvarchar2(high_value))
  ,'BINARY_DOUBLE',to_char(utl_raw.cast_to_binary_double(high_value))
  ,'BINARY_FLOAT' ,to_char(utl_raw.cast_to_binary_float(high_value))
  ,'DATE',to_char(1780+to_number(substr(high_value,1,2),'XX')
         +to_number(substr(high_value,3,2),'XX'))||'-'
       ||to_number(substr(high_value,5,2),'XX')||'-'
       ||to_number(substr(high_value,7,2),'XX')||' '
       ||(to_number(substr(high_value,9,2),'XX')-1)||':'
       ||(to_number(substr(high_value,11,2),'XX')-1)||':'
       ||(to_number(substr(high_value,13,2),'XX')-1)
,  high_value
       ) hi_v
from dba_tab_columns
where owner      = '&&owner'
and   table_name = '&&table_name'
ORDER BY owner,table_name,COLUMN_ID
/

prompt
prompt Stale Stats
prompt
select owner,table_name,partition_name,
       subpartition_name,
       stale_stats               /* YES or NO */
from   dba_tab_statistics
where  table_name = '&table_name' 
and owner = '&&owner'
and stale_stats='YES'
/

prompt Table Partition Type

select dpt.owner,dpt.table_name,dpkc.column_name,dpkc.column_position,dpt.PARTITIONING_TYPE,dpt.PARTITIONING_KEY_COUNT,dpt.SUBPARTITIONING_TYPE,dpt.SUBPARTITIONING_KEY_COUNT from dba_part_tables  dpt, dba_part_key_columns dpkc
where dpt.owner      = '&&owner'
  and dpt.owner = dpkc.owner
  and dpt.table_name = dpkc.name
and   table_name = '&&table_name';


/**
prompt
prompt Table Partition High Value
prompt


select dtp.table_name, dpkc.column_name,dtp.partition_name,dtp.last_analyzed,decode (nullable,'N','Y','N')  M
       ,dtp.high_value 
       ,num_distinct
      ,num_nulls
      ,dtp.last_analyzed
      ,dtp.high_value
from dba_tab_partitions dtp, dba_part_key_columns dpkc
where dtp.table_owner      = '&&owner'
and   dtp.table_name = '&&table_name' 
and dtp.table_owner = dpkc.owner
and dtp.table_name = dpkc.name
order by dtp.partition_position;
**/
prompt
prompt Table Part Col Stats
prompt

select part.table_owner
      ,part.table_name
	  ,part.partition_name
      ,dpkc.column_name
      ,dbc.data_type
      ,decode (nullable,'N','Y','N')  M
      ,num_distinct 
      ,num_nulls
      ,part.last_analyzed
	  ,part.high_value
from  dba_tab_partitions part, dba_tab_columns dbc, dba_part_key_columns dpkc
where part.table_owner = '&&owner'
  and   part.table_name = '&&table_name'
  and dbc.owner = part.table_owner
  and dbc.table_name = part.table_name
  and dbc.column_name = '&column_name'
  and dbc.column_name = dpkc.column_name
  and part.table_name = dpkc.name
  and part.table_owner = dpkc.owner
ORDER BY part.table_owner,part.table_name,part.partition_position
/



set timing on
