col attribute_name for a40
col value for a20
select aa.group_number, ad.name, aa.name attribute_name, aa.value 
from v$asm_attribute aa, v$asm_diskgroup ad
where (aa.name like '%compat%' or aa.name like '%sector_size%')
       and aa.group_number=ad.group_number;

