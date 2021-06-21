Prompt RULES 1-3: DATA TABLESPACES SHOULD HAVE UNIFORM EXTENT SIZE (128K, 4M, 128M)
Prompt To check for Data tablespaces that do not obey the uniform extent size
select tablespace_name, initial_extent, next_extent, pct_increase, min_extlen
from dba_tablespaces
where (initial_extent not in (128*1024, 4*1024*1024, 128*1024*1024)
or next_extent != initial_extent
or pct_increase != 0
or min_extlen != initial_extent)
and contents = 'PERMANENT'
and tablespace_name != 'SYSTEM'
and tablespace_name not in (select tablespace_name from dba_rollback_segs);

Prompt 	RULE 4: MONITOR AND POTENTIALLY RELOCATE SEGMENTS HAVING MORE THAN 1024 EXTENTS
--Prompt To check for segments having more than 1024 extents you can run the following query:
-- select owner, segment_name, extents from dba_segments
-- where extents > 1024 and segment_type != 'TEMPORARY';

--Prompt RULE 5: THE MAXIMUM SINGLE SEGMENT SIZE SHOULD BE SOMEWHERE BETWEEN 4G AND 128G
--Prompt To check for segments that are larger than 4G you can run the following query:

--select owner, segment_name, bytes from dba_segments
--where bytes > 4*1024*1024*1024 and segment_type != 'TEMPORARY';

--Prompt RULE 6: VERY LARGE TABLES AND INDEXES SHOULD BE PLACED IN A PRIVATE TABLESPACE
--Prompt To find tables or indexes that are larger than 4G you can run the following query:
--select owner, segment_name, sum(bytes) from dba_segments
--group by owner, segment_name
--having sum(bytes) > 4*1024*1024*1024;

Prompt RULE 7: TEMP SEGMENTS SHOULD BE RESTRICTED TO TEMP TABLESPACES
Prompt To identify users that do not have their TEMP TABLESPACE set to a tablespace of type TEMP you can run the
Prompt following query:
select username from dba_users, dba_tablespaces
where temporary_tablespace = tablespace_name
and contents != 'TEMPORARY';

--Prompt RULE 8: PLACE ROLLBACK SEGMENTS IN TABLESPACES DEDICATED TO ROLLBACK SEGMENTS
--Prompt To identify tablespaces which have both rollback segments and user data you can run the following query:
--select tablespace_name from dba_segments
--where segment_type != 'ROLLBACK'
--and tablespace_name != 'SYSTEM'
--and tablespace_name in (select tablespace_name from dba_rollback_segs);


Prompt RULE 9: TEMP AND UNDO TABLESPACES SHOULD CONTAIN BETWEEN 1024 AND 4096 EXTENTS
Prompt To check for UNDO and TEMP tablespaces that do not obey the extent size rules you can run the following query:
select tablespace_name, initial_extent, next_extent, pct_increase, min_extlen
from dba_tablespaces t,
(select tablespace_name tbspc,
sum(bytes) tbspc_sz,
count(*) num_files,
sum(bytes)/sum(blocks) blk_sz
from dba_data_files
group by tablespace_name) f
where
( initial_extent < (tbspc_sz - blk_sz * num_files) / 4096
or initial_extent > (tbspc_sz - blk_sz * num_files) / 1024
or next_extent != initial_extent
or pct_increase != 0
or min_extlen != initial_extent)
and tablespace_name = tbspc
and tablespace_name != 'SYSTEM'
and ( contents = 'TEMPORARY'
or tablespace_name in (select tablespace_name from dba_rollback_segs));

Prompt RULE 10: NEVER PLACE USER DATA IN THE SYSTEM TABLESPACE
Prompt To identify user data in the System Tablespace you can run the following query:
select owner, segment_name from dba_segments
where tablespace_name = 'SYSTEM'
and owner != 'SYS'
and owner != 'SYSTEM';
Prompt RULE 11: DATAFILE SIZE SHOULD BE A MULTIPLE OF EXTENT SIZE + 1
Prompt To check for datafiles that do not obey the file size rules you can run the following query:
select t.tablespace_name, file_name, bytes file_size, initial_extent
from dba_tablespaces t, dba_data_files f
where mod(f.bytes - f.bytes/f.blocks, initial_extent) != 0
and f.tablespace_name = t.tablespace_name;

Prompt RULE 12: NEVER DEFRAGMENT THE SPACE WITHIN A UNIFORM EXTENT TABLESPACE
Prompt To check for a tablespace using a uniform extent size that has a free extent that is not a multiple of the extent size you
Prompt can run the following query:
select t.tablespace_name, file_id, block_id, bytes, initial_extent
from dba_tablespaces t, dba_free_space s
where next_extent = initial_extent
and pct_increase = 0
and min_extlen = initial_extent
and t.tablespace_name != 'SYSTEM'
and t.tablespace_name = s.tablespace_name
and mod(bytes, initial_extent) != 0;