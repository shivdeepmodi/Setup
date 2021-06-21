REM Script to find space usage of segment

set verify off serverout on
Prompt
accept p_segname   char prompt 'Give Segment Name        :'
accept p_owner     char prompt 'Give Segment Owner[user] :'
prompt Select the Segment Type :[TABLE|TABLE PARTITION|TABLE SUBPARTITION|INDEX|INDEX PARTITION|INDEX SUBPARTITION|CLUSTER|LOB]
accept p_type      char prompt 'Give Segment Type[TABLE] :'
accept p_partition char prompt 'Give Partition Name[NULL]:'

column p_owner     new_value p_owner
column p_segname   new_value p_segname
column p_partition new_value p_partition
column p_type      new_value p_type

set termout off
select decode('&&p_owner',NULL,user,upper('&&p_owner')) p_owner from dual;
select upper('&&p_segname') p_segname from dual;
select decode('&&p_partition',NULL,'NULL',''''||upper('&&p_partition')||'''') p_partition from dual;
select decode('&&p_type',NULL,'TABLE',upper('&&p_type')) p_type from dual;
set termout on


declare
l_free_blks          number;
l_total_blocks       number;
l_total_bytes        number;
l_unused_blocks      number;
l_unused_bytes       number;
l_LastUsedExtFileId  number;
l_LastUsedExtBlockId number;
l_last_used_block    number;
l_count              number;

l_unformatted_blocks number; -- Total number of blocks that are unformatted
l_unformatted_bytes  number; -- Total number of bytes that are unformatted
l_fs1_blocks         number; -- Number of blocks that has at least 0 to 25% free space
l_fs1_bytes          number; -- Number of bytes that has at least 0 to 25% free space
l_fs2_blocks         number; -- Number of blocks that has at least 25 to 50% free space
l_fs2_bytes          number; -- Number of bytes that has at least 25 to 50% free space
l_fs3_blocks         number; -- Number of blocks that has at least 50 to 75% free space
l_fs3_bytes          number; -- Number of bytes that has at least 50 to 75% free space
l_fs4_blocks         number; -- Number of blocks that has at least 75 to 100% free space
l_fs4_bytes          number; -- Number of bytes that has at least 75 to 100% free space
l_ful1_blocks        number; -- Total number of blocks that are full in the segment
l_full_bytes         number; -- Total number of bytes that are full in the segment


procedure p( p_label in varchar2, p_num in number )
is
  begin
  dbms_output.put_line( rpad(p_label,60,'.') ||p_num );
end;

begin
  select count(*)
    into l_count
   from dba_tablespaces
  where tablespace_name = (select tablespace_name 
                             from dba_segments
                            where segment_name = '&&p_segname'
                             and owner = '&&p_owner'
                          )
              and segment_space_management = 'MANUAL';
              
  if (l_count>0) then
    dbms_space.free_blocks( 
      segment_owner     => '&&p_owner',
      segment_name      => '&&p_segname',
      segment_type      => '&&p_type',
      partition_name    => &&p_partition,
      freelist_group_id => 0,
      free_blks         => l_free_blks );

    dbms_space.unused_space(
      segment_owner             => '&&p_owner',
      segment_name              => '&&p_segname',
      segment_type              => '&&p_type',
      partition_name            => &&p_partition,
      total_blocks              => l_total_blocks,
      total_bytes               => l_total_bytes,
      unused_blocks             => l_unused_blocks,
      unused_bytes              => l_unused_bytes,
      last_used_extent_file_id  => l_LastUsedExtFileId,
      last_used_extent_block_id => l_LastUsedExtBlockId,
      last_used_block           => l_last_used_block );

    dbms_output.put_line( rpad(' ',70,'-'));
    p( 'Free Blocks', l_free_blks );
    p( 'Total Blocks', l_total_blocks );
    p( 'Total Bytes', l_total_bytes );
    p( 'Unused Blocks', l_unused_blocks );
    p( 'Unused Bytes', l_unused_bytes );
    p( 'Last Used Ext FileId', l_LastUsedExtFileId );
    p( 'Last Used Ext BlockId', l_LastUsedExtBlockId );
    p( 'Last Used Block', l_last_used_block );
  else
    dbms_output.put_line( rpad(' ',70,'-'));
    dbms_space.space_usage(
      segment_owner      => '&&p_owner',
      segment_name       => '&&p_segname',
      segment_type       => '&&p_type',
      unformatted_blocks => l_unformatted_blocks,
      unformatted_bytes  => l_unformatted_bytes,
      fs1_blocks         => l_fs1_blocks,
      fs1_bytes          => l_fs1_bytes,
      fs2_blocks         => l_fs2_blocks,
      fs2_bytes          => l_fs2_bytes,
      fs3_blocks         => l_fs3_blocks,
      fs3_bytes          => l_fs3_bytes,
      fs4_blocks         => l_fs4_blocks,
      fs4_bytes          => l_fs4_bytes,
      full_blocks        => l_ful1_blocks,
      full_bytes         => l_full_bytes,
      partition_name     => &&p_partition);
      
      

    p( 'Unformatted Blocks', l_unformatted_blocks );
    p( 'Unformatted Bytes', l_unformatted_bytes );
    p( 'Number of blocks that has at least 0 to 25% free space', l_fs1_blocks );
    p( 'Number of bytes  that has at least 0 to 25% free space', l_fs1_bytes );
    p( 'Number of blocks that has at least 25 to 50% free space', l_fs2_blocks );
    p( 'Number of bytes  that has at least 25 to 50% free space', l_fs2_bytes );
    p( 'Number of blocks that has at least 50 to 75% free space', l_fs3_blocks );
    p( 'Number of bytes  that has at least 50 to 75% free space', l_fs3_bytes );
    p( 'Number of blocks that has at least 75 to 100% free space', l_fs4_blocks );
    p( 'Number of bytes  that has at least 75 to 100% free space', l_fs4_bytes );
    p( 'Total number of blocks that are full in the segment', l_ful1_blocks );
    p( 'Total number of bytes  that are full in the segment', l_full_bytes );

  end if;
dbms_output.put_line( rpad(' ',70,'-'));
end;
/
set verify on