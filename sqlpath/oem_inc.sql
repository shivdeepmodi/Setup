define target_name=&1
col summary_msg for a90 newline
col target_name for a60
col target_type for a30
col resolution_state heading RES_STATE for a10
SELECT 
a.INCIDENT_NUM , 
  a.severity, 
  a.resolution_state ,
  decode(a.open_status,0,'CLOSED',1,'OPEN') open_status,
  a.CREATION_DATE,
  a.LAST_UPDATED_DATE,
  a.closed_date,
  b.target_type, 
  b.target_name, 
  a.summary_msg
FROM   
  sysman.mgmt$incidents a,
  sysman.mgmt$target b
WHERE a.target_guid = b.target_guid
AND   a.creation_date >= SYSDATE - 30
and upper(b.target_name) like upper('%&&target_name%')
and rownum <3
ORDER BY creation_date
/
