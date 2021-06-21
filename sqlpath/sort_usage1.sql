with   
temp_spc as (
select dt.tablespace_name, v.block_size,sum(dt.blocks) total_blocks
  from dba_temp_files dt, v$tempfile v
 where file#= file_id
   and file_name = name
 group by dt.tablespace_name, v.block_size
 ),
temp_usage as (
select tablespace,sum(blocks) blocks_in_use
  from gV$TEMPSEG_USAGE temp
  group by tablespace
 )
select temp_spc.tablespace_name,round(blocks_in_use/temp_spc.total_blocks,2) PCT_USAGE
  from temp_spc, temp_usage 
 where temp_spc.tablespace_name = temp_usage.tablespace
/


with   
temp_spc as (
select dt.tablespace_name, v.block_size,sum(dt.blocks) total_blocks
  from dba_temp_files dt, v$tempfile v
 where file#= file_id
   and file_name = name
 group by dt.tablespace_name, v.block_size
 ),
temp_usage as (
select instance_name,tablespace,sum(blocks) blocks_in_use
  from gV$TEMPSEG_USAGE temp, gv$instance inst
 where temp.inst_id = inst.inst_id
 group by instance_name,tablespace
 )
select temp_usage.instance_name,temp_spc.tablespace_name,round(blocks_in_use/temp_spc.total_blocks,2) PCT_USAGE
  from temp_spc, temp_usage 
 where temp_spc.tablespace_name = temp_usage.tablespace
/
