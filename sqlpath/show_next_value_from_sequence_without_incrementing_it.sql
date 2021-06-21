--http://www.akadia.com/services/scripts/show_next_value_from_sequence.txt
-- #############################################################################################
--
-- %Purpose: Show next sequence number from sequence (without to increment it with NEXTVAL)
--
-- Use:      Needs SYS access
--
-- #############################################################################################
--
set tab on;
set scan on;
set verify off
--
ttitle left 'Shows next sequence number without incrementing it' skip 2
--
accept sequence_owner char prompt "Sequence Owner <% for all>: " default %
accept sequence_name char prompt  "Sequence Name  <% for all>: " default %
--
col sequence_owner format a20 heading 'Sequence|Owner'
col sequence_name  format a25 heading 'Sequence|Name'
col next_seq       format 99999999 heading 'Next|Value'
col cache          format a25 heading 'Cache'

select sequence_owner, sequence_name, next_seq, cache
from (select sequence_owner, sequence_name,
       nextvalue next_seq, 'in cache' cache
      from v$_sequences
      where nextvalue is not null
       union
      select sequence_owner, sequence_name,
       highwater next_seq, 'created nocache' cache
      from v$_sequences
      where nextvalue is null
       union
      select sequence_owner, sequence_name,
       last_number next_seq, 'not in cache' cache
      from dba_sequences s
      where not exists (select  sequence_owner, sequence_name
                        from v$_sequences v
                        where v.sequence_name = s.sequence_name
                        and   v.sequence_owner = s.sequence_owner))
where   sequence_owner like upper('&sequence_owner')
and     sequence_name like upper('&sequence_name')
order by sequence_owner, sequence_name
/
undefine sequence_owner
undefine sequence_name
col sequence_owner clear
col sequence_name clear
set verify on



