Column comp_name heading 'Component Name' format a35
Column status    heading 'Status'         format a7
Column version   heading 'Version'        format a10
SELECT comp_name, status, version from dba_registry;
