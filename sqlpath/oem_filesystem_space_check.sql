
alter session set current_schema=SYSMAN;
col target_name for a40
col mountpoint for a40
select
st.target_name,
mountpoint,
round((freeb/ 1073741824),2) as "Free (GB)",
round((sizeb/ 1073741824),2) as "Size (GB)",
round((((sizeb-freeb)/ sizeb)*100),2) as "Used (%)"
from MGMT$STORAGE_REPORT_LOCALFS st, mgmt$os_summary os
where
st.target_name=os.host 
and (st.mountpoint like ('/u01%') or st.mountpoint like ('/rman_backup%') )
and os.name like '%Linux%' and
round((((sizeb-freeb)/ sizeb)*100),2)  > 85
order by 1,2
/
