set verify off
@print_table_call.sql 'select * from v$version'
col product for a50
col version for a10
col version_full for a15
SELECT * FROM PRODUCT_COMPONENT_VERSION;


set verify on
