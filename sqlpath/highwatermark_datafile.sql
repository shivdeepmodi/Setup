column file_name format a50; 
column tablespace_name format a17; 
column highwater format 9999999999;

SELECT   /*+choose*/A.TABLESPACE_NAME,
         A.FILE_NAME,
         A.BYTES/1024/1024 "File_Size MB",
         (B.MAXIMUM + C.BLOCKS - 1) * D.DB_BLOCK_SIZE/1024/1024 "HighWater MB",
         A.BYTES / 1024 / 1024 - (B.MAXIMUM + C.BLOCKS - 1) * D.DB_BLOCK_SIZE/1024/1024 "MB above highwater"
FROM     DBA_DATA_FILES A,
         (SELECT   FILE_ID, MAX(BLOCK_ID) MAXIMUM 
            FROM   DBA_EXTENTS
           GROUP BY FILE_ID) B,
         DBA_EXTENTS C,
         (SELECT VALUE DB_BLOCK_SIZE
          FROM   V$PARAMETER
          WHERE  NAME = 'db_block_size') D
WHERE    A.FILE_ID = B.FILE_ID
         AND C.FILE_ID = B.FILE_ID
         AND C.BLOCK_ID = B.MAXIMUM
ORDER BY A.TABLESPACE_NAME,5
/