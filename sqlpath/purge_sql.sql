col purge_sql for a80
select inst_id,'exec dbms_shared_pool.purge('||''''||address||','||hash_value||''''||','||''''||'C'||''''||')' purge_sql from gv$sql where sql_id = '&1';

