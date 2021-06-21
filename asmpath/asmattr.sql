col attribute_name for a40
col attribute_name for a40
col value for a20
select aa.group_number, ad.name, aa.name attribute_name, aa.value
 from v$asm_attribute aa, v$asm_diskgroup ad
where aa.name like 'compatible%'
  and aa.group_number=ad.group_number
  and ad.name in (select a.name from v$asm_diskgroup a, v$asm_client b where a.group_number = b.group_number and b.db_name = substr('&db_unique_name',1,8));

