-- connect as dba on oempd to get results
--
col TARGET_NAME for a40
col PROPERTY_VALUE for a30
col host for a30
select target_name,host,PROPERTY_VALUE from (
select target_name,host,hoststr,property_name,PROPERTY_VALUE, rank() over (partition by hoststr order by target_name) rank from
(
select
tar.TARGET_NAME,
substr(tar.target_name,1,instr(tar.target_name, '.',1)-1) host,
substr(tar.target_name,1,instr(tar.target_name, '.',1)-2) hoststr,
--tar.TARGET_TYPE,
--tar.HOST_NAME,
decode(prop.PROPERTY_NAME,'orcl_gtp_lifecycle_status','LIFECYCLE',
                          'orcl_gtp_line_of_bus','LINE_OF_BUSINESS',
                          'orcl_gtp_department','DEPARTMENT',
                          prop.PROPERTY_NAME) PROPERTY_NAME,
prop.PROPERTY_VALUE
from SYSMAN.mgmt_targets tar, sysman.MGMT$TARGET_PROPERTIES prop
where tar.TARGET_TYPE ='host'
and tar.target_name = prop.TARGET_NAME
and tar.TARGET_TYPE = prop.TARGET_TYPE
and tar.TARGET_GUID = prop.TARGET_GUID
and prop.PROPERTY_NAME = 'orcl_gtp_lifecycle_status'
--and prop.PROPERTY_VALUE = 'Production'
and tar.target_name like '%orc%'
and tar.TARGET_NAME not like '%mserv%' 
--and tar.TARGET_NAME not like 'viv%info.corp'
--and tar.TARGET_NAME not like 'lov%info.corp'
and tar.TARGET_NAME not like '%info.corp'
and tar.target_name not like 'lon6sap%'
and tar.target_name not like 'ric1sap%'
order by tar.TARGET_NAME
))
where rank = 1
;
