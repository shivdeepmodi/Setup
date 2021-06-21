define target_name=&1
col TARGET_NAME for a60

select ac.TARGET_NAME,tar.HOST_NAME,ac.START_TIMESTAMP,ac.AVAILABILITY_STATUS
 from sysman.MGMT$AVAILABILITY_CURRENT ac, SYSMAN.mgmt_targets tar
where upper(ac.TARGET_NAME) like upper('&target_name%')
  and tar.target_name = ac.TARGET_NAME
  order by ac.START_TIMESTAMP desc
/
