column pid new_value Smon

set termout off
select
  p.pid
from
  sys.v_$bgprocess b,
  sys.v_$process p
where
  b.name = 'SMON' and
  p.addr = b.paddr
/
set termout on

oradebug wakeup &Smon

undefine Smon
