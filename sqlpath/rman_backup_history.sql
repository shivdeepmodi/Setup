select start_time,end_time,round(input_bytes/1048576/1024,2) input_files_gb,
round(output_bytes/1048576/1024,2) output_pieces_gb,status,INPUT_TYPE,ELAPSED_SECONDS 
from V$RMAN_BACKUP_JOB_DETAILS order by 1;

