select applied,deleted,decode(rectype,11,'YES','NO') reclaimable,count(*),min(sequence#),max(sequence#)
from v$archived_log left outer join sys.x$kccagf using(recid)
where is_recovery_dest_file='YES' group by applied,deleted,decode(rectype,11,'YES','NO') order by 5;