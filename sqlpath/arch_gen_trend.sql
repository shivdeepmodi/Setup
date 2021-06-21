select trunc(FIRST_TIME),count(1),round(sum((BLOCKS*BLOCK_SIZE)/1024/1024/1024),2) gb from gv$archived_log where to_date(first_time) > sysdate -5 
group by trunc(FIRST_TIME) ;
