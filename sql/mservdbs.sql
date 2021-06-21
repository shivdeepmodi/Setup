select distinct replace(target_name,'.markit.partners','') from (
select
tar.TARGET_NAME,
tar.TARGET_TYPE,
--tar.DISPLAY_NAME,
tar.TYPE_DISPLAY_NAME,
--tar.HOST_NAME,
decode(prop.PROPERTY_NAME,'orcl_gtp_lifecycle_status','LIFECYCLE',
                          'orcl_gtp_line_of_bus','LINE_OF_BUSINESS',
                          'orcl_gtp_department','DEPARTMENT',
                          prop.PROPERTY_NAME) PROPERTY_NAME,
prop.PROPERTY_VALUE
from SYSMAN.mgmt_targets tar, sysman.MGMT$TARGET_PROPERTIES prop
where 
tar.TARGET_TYPE like '%database%'
and tar.target_name = prop.TARGET_NAME
and tar.TARGET_TYPE = prop.TARGET_TYPE
and tar.TARGET_GUID = prop.TARGET_GUID
and prop.PROPERTY_NAME in (
'orcl_gtp_lifecycle_status','orcl_gtp_line_of_bus','orcl_gtp_department'
--,'Version'
--,'OracleHome'
)
and property_value in
(
'FXW',
'MIM',
'MIS',
'MSV',
'MTM',
'MWW',
'Markit Wire',
'MarkitSERV',
'MarkitServ',
'Markitwire',
'Mserv'
)
and tar.TARGET_TYPE='rac_database'
)
/
