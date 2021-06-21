#!/bin/ksh
WORK_DIR=/home/oracle/shivdeep/asmmon
LOG_DIR=$WORK_DIR/logs
export ORACLE_HOME=/u01/app/oracle/product/12_2018_4_12./racdbhome_1
export PATH=$ORACLE_HOME/bin:$WORKDIR:/home/oracle/shivdeep/bin:$PATH

if [[ ${1} = 'SCHEDULED' ]];then
EMAIL_LIST=MK-GTSProductionSupportOracle@ihsmarkit.com
else
EMAIL_LIST=shivdeep.modi@ihsmarkit.com
fi

rm -f ${LOG_DIR}/*

sqls oempd_lon6 <<!
set lines 300 trimspool on pages 1000
spool ${LOG_DIR}/asmtargets.conf replace
set termout off
@$WORK_DIR/asmtargets.sql
spool off
!

unset SQLPATH
unset ORACLE_PATH
thisscript=`echo $0`


> ${LOG_DIR}/error.log
> ${LOG_DIR}/output.log
> ${LOG_DIR}/script_stdout.log

awk '$3=="Production"{printf "%30s %25s %20s\n",$1,$2,$3}' ${LOG_DIR}/asmtargets.conf > ${LOG_DIR}/asmtargets.tmp
#Additional hosts to be monitored
grep -v ^\# ${WORK_DIR}/additional_targets.conf > ${LOG_DIR}/additional_targets.tmp
grep -f ${LOG_DIR}/additional_targets.tmp ${LOG_DIR}/asmtargets.conf >> ${LOG_DIR}/asmtargets.tmp 
#Workarounds
perl -p -i -e 's!lon2infpdorc001a!lon2infpdorc001a-vip!g' ${LOG_DIR}/asmtargets.tmp

#

while read target host property
do
#echo $target : $host : $property
pasword=`/u01/app/oracle/dba_7.8/tools/pws/pw -u MARKITMON -t ${host} -J ${thisscript}`
#echo sqlplus -s markitmon/${pasword}@${host}:1521/+ASM as sysdba 
>${LOG_DIR}/${host}.check.log
exec 3<&1
exec 4<&2

exec 1>>${LOG_DIR}/${host}.check.log
exec 2>>${LOG_DIR}/${host}.check.log

sqlplus -s -l markitmon/${pasword}@${host}:1521/+ASM as sysdba <<!
set lines 300 trimspool on
col host_name for a40
col instance_name for a10
--select host_name,instance_name from v\$instance;
--select inst_id,count(*) from gv\$pwfile_users group by inst_id;
column host_name new_value host_name
select min(host_name) as host_name from gv\$instance;
set heading off
spool ${LOG_DIR}/${host}.log
@${WORK_DIR}/asmmon.sql
spool off
!

exec 1<&3
exec 2<&4

egrep 'ORA-|TNS' ${LOG_DIR}/${host}.check.log > /dev/null
if [[ $? -eq 0 ]];then
 echo "`date +'%d-%h-%y %H:%M:%S'` Error ${host} `egrep 'ORA-|TNS' ${LOG_DIR}/${host}.check.log` "  >> ${LOG_DIR}/error.log
 echo "`date +'%d-%h-%y %H:%M:%S'` Error ${host} `egrep 'ORA-|TNS' ${LOG_DIR}/${host}.check.log` "  >> ${LOG_DIR}/script_stdout.log
else
 grep 'no rows' ${LOG_DIR}/${host}.check.log > /dev/null
 if [[ $? -eq 0 ]];then
  echo "`date +'%d-%h-%y %H:%M:%S'` OK ${host}" >>${LOG_DIR}/script_stdout.log
 else
  egrep -v 'selected|Elapsed' ${LOG_DIR}/${host}.log >> ${LOG_DIR}/output.log
 fi
fi
done < ${LOG_DIR}/asmtargets.tmp

sed '/^$/d' ${LOG_DIR}/output.log > ${LOG_DIR}/output.log.tmp
if [[ `wc -l ${LOG_DIR}/output.log.tmp|awk '{print$1}'` -eq 0 ]];then
 echo "`date +'%d-%h-%y %H:%M:%S'` No_Issue_reported" >> ${LOG_DIR}/script_stdout.log
 echo No_Issue_reported| mail -s 'ASM Diskgroup ALERT: OK' ${EMAIL_LIST}
else
 cat ${WORK_DIR}/ASM_CHECK.html.head > ${LOG_DIR}/ASH_CHECK.html
 cat ${WORK_DIR}/ASM_CHECK.body_table_header >> ${LOG_DIR}/ASH_CHECK.html
 cat ${LOG_DIR}/output.log.tmp|sort -k 2|sed s'!^!<tr><td>!g'|sed 's!$!</td></tr>!g'|sed 's!|!</td><td>!g' >> ${LOG_DIR}/ASH_CHECK.html
 cat ${WORK_DIR}/ASM_CHECK.html.end >> ${LOG_DIR}/ASH_CHECK.html
fi

  {
     echo "From: DBA-Reports@markit.com"
     echo "To: ${EMAIL_LIST}"
     echo "Subject: ASM Diskgroup ALERT"
     echo "MIME-Version: 1.0"
     echo "Content-Type: text/html"
     echo "Content-Disposition: inline"
     cat ${LOG_DIR}/ASH_CHECK.html
  } | /usr/sbin/sendmail ${EMAIL_LIST}

if  [[ `wc -l ${LOG_DIR}/error.log|awk '{print$1}'` -ne 0 ]];then
  echo "`date +'%d-%h-%y %H:%M:%S'` Failed_Checks" >> ${LOG_DIR}/script_stdout.log
  cat ${WORK_DIR}/ERROR.html.head > ${LOG_DIR}/ERROR.html
  echo '<table border=1 width=100%><tr><td>Error</td><tr>' >> ${LOG_DIR}/ERROR.html
  cat ${LOG_DIR}/error.log|sed s'!^!<tr><td>!g'|sed 's!$!</td></tr>!g' >> ${LOG_DIR}/ERROR.html
  cat ${WORK_DIR}/ERROR.html.end >> ${LOG_DIR}/ERROR.html
  {
     echo "From: DBA-Reports@markit.com"
     echo "To: ${EMAIL_LIST}"
     echo "Subject: ASM Diskgroup ALERT: Failed Checks"
     echo "MIME-Version: 1.0"
     echo "Content-Type: text/html"
     echo "Content-Disposition: inline"
     cat ${LOG_DIR}/ERROR.html
  } | /usr/sbin/sendmail ${EMAIL_LIST}

fi
