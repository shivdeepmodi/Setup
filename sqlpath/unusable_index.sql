select index_name,owner,status
  from dba_indexes
 where status = 'UNUSABLE'
/

select index_name,index_owner,partition_name,status
  from dba_ind_partitions
 where status = 'UNUSABLE'
/
