select target_name, mountpoint,
round((freeb/ 1073741824),2) as "Free (GB)",
round((sizeb/ 1073741824),2) as "Size (GB)",
round(((usedb/ sizeb)*100),2) as "Used (%)"
from MGMT$STORAGE_REPORT_LOCALFS where mountpoint = '/u01/app/oracle' order by target_name
/
