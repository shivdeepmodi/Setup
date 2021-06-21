#!/bin/ksh
export RSDIR=/home/oracle/shivdeep/dbmon/script_log
export WORKDIR=/home/oracle/shivdeep/dbmon
export LOGDIR=${WORKDIR}/log
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2.1_1.3/racdbhome_1
export PATH=$ORACLE_HOME/bin:$WORKDIR:$PATH
export TNS_ADMIN=/home/oracle/shivdeep/TNS_ADMIN

trap cleanup 1 2 3 4 5 9 15
function cleanup 
{
echo "Cleanup script" >> /home/oracle/shivdeep/dbmon/script_log/report_scheduler.log 
#rm -f /home/oracle/shivdeep/dbmon/log/*
#ps -ef|grep '[w]rap_sqlplus'|awk '{print$2}'|xargs kill -9
#pkill -9 -P $$; rm -f /home/oracle/shivdeep/dbmon/script_log/report_scheduler.lck;rm -f /home/oracle/shivdeep/dbmon/log/*
#Final Cleanup
rm -f /home/oracle/shivdeep/dbmon/script_log/report_scheduler.lck;
#rm -f /home/oracle/shivdeep/dbmon/log/*
echo Listing remaining Child processes PIDs >> ${RSDIR}/report_scheduler.log
echo " " 
pgrep -P $$ >> ${RSDIR}/report_scheduler.log

echo " " 
echo " " 

echo Listing remaining Child processes TREE >> ${RSDIR}/report_scheduler.log
echo " " 
pstree -p $$ >> ${RSDIR}/report_scheduler.log

pstree -p $$ > ${RSDIR}/process.log

parent=$$
echo Parent PID: $$
ps -ef|grep $parent|grep -v grep

>${RSDIR}/process_temp.log
for ii in `grep -v 'pstree' ${RSDIR}/process.log|sed "s/[^0-9]/ /g"`
do
echo $ii >> ${RSDIR}/process_temp.log
done

for ii in `grep -vw $parent ${RSDIR}/process_temp.log`
do
echo killing $ii
ps -ef|grep -w $ii|grep -v grep
kill -9 $ii
done

echo Final Check Strt
pstree -p $$
echo Final Check End
exit
}

#trap "ps -ef|egrep 'daily|report_scheduler'|grep -v grep awk '{print$2}'|xargs kill -9; rm -f /home/oracle/shivdeep/dbmon/script_log/report_scheduler.lck" INT TERM

#Check if report is running

if [[ -f /home/oracle/shivdeep/dbmon/script_log/report_scheduler.lck ]];then
echo "Report is still running.
Time now: `date`
Report running since :`head -1 /home/oracle/shivdeep/dbmon/script_log/report_scheduler.log`"|mail -s 'Consolidated Report: Report Still Running' shivdeep.modi@ihsmarkit.com
sleep 2
exit 99
else
touch /home/oracle/shivdeep/dbmon/script_log/report_scheduler.lck
fi #Check if report is running

exec > /home/oracle/shivdeep/dbmon/script_log/report_scheduler.log 2>&1

RUN_ADHOC_SQL=N

while getopts "a:s:c:" arg
do
  case $arg in
  a) echo In the Run adhoc sql section
     export RUN_ADHOC_SQL=Y
     if [[ "$OPTARG" = 'Y' ]];then
       EMAIL_LIST=shivdeep.modi@ihsmarkit.com
     fi
     egrep -i 'insert|update|delete' ${WORKDIR}/adhoc_dba.sql > /dev/null
     if [[ $? -eq 0 ]];then
      echo DMLS found...
      echo exiting ...
      exit 100
     fi
     ;;
  s) 
     echo OPTARG in schedule: ${OPTARG}
     if [[ "$OPTARG" = 'SCHEDULED' ]];then
       EMAIL_LIST=MK-GTSProductionSupportOracle@ihsmarkit.com
     else
       EMAIL_LIST=shivdeep.modi@ihsmarkit.com
     fi
     ;;
  c) RUN_ALL=NO
     echo OPTARG in check: ${OPTARG}
     case ${OPTARG} in
       "TABLESPACE_CHECK" )
        RUN_THE_REPORTS_FOR=${OPTARG}
        ;;
       "RESTORE_POINT_CHECK" )
        RUN_THE_REPORTS_FOR=${OPTARG}
        ;;
       "FRA_USAGE_CHECK" )
        RUN_THE_REPORTS_FOR=${OPTARG}
        ;;
       "STDBY_GAP_CHECK" )
        RUN_THE_REPORTS_FOR=${OPTARG}
        ;;
       "DB_FILES_CHECK" )
        RUN_THE_REPORTS_FOR=${OPTARG}
        ;;
       "TBS_FILES_COUNT" )
        RUN_THE_REPORTS_FOR=${OPTARG}
        ;;
       "RMAN_BACKUP" )
        RUN_THE_REPORTS_FOR=${OPTARG}
        ;;
       "ALL")
        RUN_ALL=YES
        RUN_THE_REPORTS_FOR='TABLESPACE_CHECK RESTORE_POINT_CHECK FRA_USAGE_CHECK STDBY_GAP_CHECK DB_FILES_CHECK TBS_FILES_COUNT RMAN_BACKUP'
        ;;
       *) echo Invalid check 
          rm /home/oracle/shivdeep/dbmon/script_log/report_scheduler.lck
        exit 10
        ;;
      esac
     ;;
  *) EMAIL_LIST=shivdeep.modi@ihsmarkit.com
     RUN_ALL=YES
     RUN_THE_REPORTS_FOR='TABLESPACE_CHECK RESTORE_POINT_CHECK FRA_USAGE_CHECK STDBY_GAP_CHECK DB_FILES_CHECK TBS_FILES_COUNT RMAN_BACKUP'
     echo run_for_me
     ;;
	esac
done

if [[ -z ${EMAIL_LIST} ]];then
 EMAIL_LIST=shivdeep.modi@ihsmarkit.com
fi

if [[ -z ${RUN_THE_REPORTS_FOR} ]];then
 RUN_ALL=YES
 RUN_THE_REPORTS_FOR='TABLESPACE_CHECK RESTORE_POINT_CHECK FRA_USAGE_CHECK STDBY_GAP_CHECK DB_FILES_CHECK TBS_FILES_COUNT RMAN_BACKUP'
fi

# check to account for adhoc run
if [[ ${RUN_ADHOC_SQL} = 'Y' ]];then
 RUN_THE_REPORTS_FOR=ADHOC_SQL
 RUN_ALL=ADHOC_SQL
fi

echo EMAIL_LIST : $EMAIL_LIST
echo RUN_THE_REPORTS_FOR : $RUN_THE_REPORTS_FOR
echo RUN_ALL : $RUN_ALL

export RUN_THE_REPORTS_FOR
export RUN_ALL

unset SQLPATH
unset ORACLE_PATH

#exec > /home/oracle/shivdeep/dbmon/script_log/report_scheduler.log 2>&1

cd $WORKDIR

echo "BEGIN Running report on : `date`" 

rm -f $LOGDIR/*

grep -v ^\# db_pass|sort -k 1 |sed '/^$/d' > db_pass.tmp.main
#egrep -i 'NWS|BVM' db_pass |grep -v ^\#> db_pass.tmp.main
LINES=$(wc -l db_pass.tmp.main |cut -d " " -f1)
FILE=db_pass.tmp.main
#echo LINES:$LINES
DEGREE=20
let PARTS=LINES/DEGREE
let REMPART=LINES%DEGREE
#echo PARTS:$PARTS
#echo REMPART:$REMPART

#LINES:19
#PARTS:3
#REMPART:4

let LOOP=PARTS
let ST=1
for ii in $(seq 1 $LOOP)
do
let EN=ST+DEGREE-1
#echo $ST:$EN
sed -n "${ST},${EN}p" ${FILE} > ${FILE}.${ii}
let ST=ST+DEGREE
done
let SCRIPT_DEGREE=PARTS

if [[ REMPART -ne 0 ]];then
	let EN=LINES
    let last=PARTS+1
	sed -n "${ST},${EN}p" ${FILE} > ${FILE}.${last}
	let SCRIPT_DEGREE=PARTS+1
fi
echo Script will be spawned: $SCRIPT_DEGREE times


function make_report
{
#for mk_ii in TABLESPACE_CHECK RESTORE_POINT_CHECK FRA_USAGE_CHECK STDBY_GAP_CHECK DB_FILES_CHECK TBS_FILES_COUNT RMAN_BACKUP
for mk_ii in `echo ${RUN_THE_REPORTS_FOR}`
do

if [[ -s ${WORKDIR}/log/${mk_ii}.check ]];then
    echo EMAIL: $mk_ii will be emailed

	case ${mk_ii} in 
	"TABLESPACE_CHECK" ) export THIS_SUBJECT='Consolidated Report: Tablespace Usage'
	sort -n -k 1 -r -t "|" < ${WORKDIR}/log/${mk_ii}.check > ${WORKDIR}/log/${mk_ii}.check.tmp
	mv ${WORKDIR}/log/${mk_ii}.check.tmp ${WORKDIR}/log/${mk_ii}.check
	;;
	"RESTORE_POINT_CHECK" ) export THIS_SUBJECT='Consolidated Report: Restore Points'
	;; 
	"FRA_USAGE_CHECK" ) export THIS_SUBJECT='Consolidated Report: Flash Recovery Area Usage'
	;;
	"STDBY_GAP_CHECK" ) export THIS_SUBJECT='Consolidated Report: Physical Standby GAP'
	;; 
	"DB_FILES_CHECK" ) export THIS_SUBJECT='Consolidated Report: DB_FILES Usage'
	;;
	"TBS_FILES_COUNT" ) export THIS_SUBJECT='Consolidated Report: TBS_FILES_COUNT'
	;;
	"RMAN_BACKUP" ) export THIS_SUBJECT='Consolidated Report: RMAN_BACKUP'
    #egrep -vi 'COMPLETED_SUCCESS|01QA|02QA|01DV|02DV|01LS|.*PHYSICAL STANDBY.*DB INCR.*|"Error : RMAN_BACKUP: ORA-00604"'  ${WORKDIR}/log/${mk_ii}.check|egrep -wv 'BDV|BVMQA|EDS|GDV|LNSQA|PDV|RDV|SSD|STFQA|UXSNYQA|mpcqa' > ${WORKDIR}/log/${mk_ii}.check.tmp
    egrep -vi '"Error : RMAN_BACKUP: ORA-00604"'  ${WORKDIR}/log/${mk_ii}.check|egrep -wv 'BDV|BVMQA|EDS|GDV|LNSQA|PDV|RDV|SSD|STFQA|UXSNYQA|mpcqa' > ${WORKDIR}/log/${mk_ii}.check.tmp
    mv ${WORKDIR}/log/${mk_ii}.check.tmp ${WORKDIR}/log/${mk_ii}.check
	;;
	esac

	cat ${WORKDIR}/${mk_ii}.html.head > ${WORKDIR}/log/${mk_ii}.html
	cat ${WORKDIR}/${mk_ii}.body_table_header >> ${WORKDIR}/log/${mk_ii}.html
	cat ${WORKDIR}/log/${mk_ii}.check |sed s'!^!<tr><td>!g'|sed 's!$!</td></tr>!g'|sed 's!|!</td><td>!g' >> ${WORKDIR}/log/${mk_ii}.html
	cat ${WORKDIR}/${mk_ii}.html.end >> ${WORKDIR}/log/${mk_ii}.html
     
	#(cat ${WORKDIR}/log/${mk_ii}.html ${mk_ii}.html|uuencode ${WORKDIR}/log/${mk_ii}.html ${mk_ii}.html) | mail -s ${mk_ii} ${EMAIL_LIST} -- -f oracle@markit.com
    #uuencode ${WORKDIR}/log/${mk_ii}.html ${mk_ii}.html > ${WORKDIR}/log/${mk_ii}.html.uue
	#cat ${WORKDIR}/log/${mk_ii}.html|mail -s ${mk_ii} ${EMAIL_LIST} -- -f oracle@markit.com
	#mailx -s ${mk_ii} ${EMAIL_LIST} -- -f oracle@markit.com < ${WORKDIR}/log/${mk_ii}.html.uue
    #uuencode ${WORKDIR}/log/${mk_ii}.html ${mk_ii}.html | mail -s ${mk_ii} ${EMAIL_LIST} -- -f "DBA Reports"

	#case ${mk_ii} in 
	#"TABLESPACE_CHECK" ) export THIS_SUBJECT='Consolidated Report: Tablespace Usage'
	#;;
	#"RESTORE_POINT_CHECK" ) export THIS_SUBJECT='Consolidated Report: Restore Points'
	#;; 
	#"FRA_USAGE_CHECK" ) export THIS_SUBJECT='Consolidated Report: Flash Recovery Area Usage'
	#;;
	#"STDBY_GAP_CHECK" ) export THIS_SUBJECT='Consolidated Report: Physical Standby GAP'
	#;; 
	#esac

	{
		echo "From: DBA-Reports@markit.com"
		echo "To: ${EMAIL_LIST}"
		echo "Subject: ${THIS_SUBJECT}"
		echo "MIME-Version: 1.0"
		echo "Content-Type: text/html"
		echo "Content-Disposition: inline"
		cat ${WORKDIR}/log/${mk_ii}.html
	} | /usr/sbin/sendmail ${EMAIL_LIST}
else
	echo make_report:$mk_ii: Nothing to Report
	case ${mk_ii} in 
	"TABLESPACE_CHECK" ) export THIS_SUBJECT='Consolidated Report: Tablespace Usage'
	;;
	"RESTORE_POINT_CHECK" ) export THIS_SUBJECT='Consolidated Report: Restore Points'
	;; 
	"FRA_USAGE_CHECK" ) export THIS_SUBJECT='Consolidated Report: Flash Recovery Area Usage'
	;;
	"STDBY_GAP_CHECK" ) export THIS_SUBJECT='Consolidated Report: Physical Standby GAP'
	;; 
	"DB_FILES_CHECK" ) export THIS_SUBJECT='Consolidated Report: DB_FILES Usage'
	;;
	"TBS_FILES_COUNT" ) export THIS_SUBJECT='Consolidated Report: TBS_FILES_COUNT'
	;;
	"RMAN_BACKUP" ) export THIS_SUBJECT='Consolidated Report: RMAN_BACKUP'
	;;
	esac
	{
		echo "From: DBA-Reports@markit.com"
		echo "To: ${EMAIL_LIST}"
		echo "Subject: ${THIS_SUBJECT}: CHECK_OK_NOTHING_TO_REPORT"
		echo "MIME-Version: 1.0"
		echo "Content-Type: text/html"
		echo "Content-Disposition: inline"
		cat ${WORKDIR}/EMPTY_REPORT.html
	} | /usr/sbin/sendmail ${EMAIL_LIST}

fi

done
}
#function make_report end

#Main

for ii in $(seq 1 $SCRIPT_DEGREE)
do

echo Running Daily check $ii of $SCRIPT_DEGREE ..
daily_checks.sh db_pass.tmp.main.${ii} ${ii} &
done 

wait

>${LOGDIR}/TABLESPACE_CHECK.check
#>${LOGDIR}/TABLESPACE_CHECK.skip
>${LOGDIR}/RESTORE_POINT_CHECK.check
>${LOGDIR}/FRA_USAGE_CHECK.check
>${LOGDIR}/STDBY_GAP_CHECK.check
>${LOGDIR}/DB_FILES_CHECK.check
>${LOGDIR}/TBS_FILES_COUNT.check
>${LOGDIR}/RMAN_BACKUP.check

for ii in $(seq 1 $SCRIPT_DEGREE)
do
cat ${LOGDIR}/TABLESPACE_CHECK.check.${ii} >> ${LOGDIR}/TABLESPACE_CHECK.check 
cat ${LOGDIR}/RESTORE_POINT_CHECK.check.${ii} >> ${LOGDIR}/RESTORE_POINT_CHECK.check
cat ${LOGDIR}/FRA_USAGE_CHECK.check.${ii} >> ${LOGDIR}/FRA_USAGE_CHECK.check
cat ${LOGDIR}/STDBY_GAP_CHECK.check.${ii} >> ${LOGDIR}/STDBY_GAP_CHECK.check
#cat ${LOGDIR}/TABLESPACE_CHECK.skip.${ii} >> ${LOGDIR}/TABLESPACE_CHECK.skip >/dev/null
cat ${LOGDIR}/DB_FILES_CHECK.check.${ii} >> ${LOGDIR}/DB_FILES_CHECK.check 
cat ${LOGDIR}/TBS_FILES_COUNT.check.${ii} >> ${LOGDIR}/TBS_FILES_COUNT.check 
cat ${LOGDIR}/RMAN_BACKUP.check.${ii} >> ${LOGDIR}/RMAN_BACKUP.check 
done

if [[ ${RUN_ADHOC_SQL} = 'N' ]];then
make_report

echo "END Running  report end on : `date`" 

echo "<html><body>" > ${WORKDIR}/skip.html
#egrep 'TIMEOUT|ORA-|TNS-|SP2-' /home/oracle/shivdeep/dbmon/script_log/report_scheduler.log |sed 's!^!<b>!g'|sed 's!$!<b><br>!g' >> ${WORKDIR}/skip.html
#egrep 'Error|FAILURE|TNS-|SP2-|TIMEOUT|"Error : RMAN_BACKUP: ORA-00604"' /home/oracle/shivdeep/dbmon/script_log/report_scheduler.log |sed 's!^!<b>!g'|sed 's!$!<b><br>!g' >> ${WORKDIR}/skip.html
egrep 'Error|FAILURE|TNS-|SP2-|TIMEOUT' /home/oracle/shivdeep/dbmon/script_log/report_scheduler.log|grep -v 'RMAN_BACKUP: ORA-00604: error occurred at recursive SQL level 2 ORA-00904' |sed 's!^!<b>!g'|sed 's!$!<b><br>!g' >> ${WORKDIR}/skip.html
echo "</body></html>" >> ${WORKDIR}/skip.html
{
        echo "From: DBA-Reports@markit.com"
        #echo "To: shivdeep.modi@markit.com"
        echo "To: ${EMAIL_LIST}"
        echo "Subject: Consolidated Report: Skipped DBS"
        echo "MIME-Version: 1.0"
        echo "Content-Type: text/html"
        echo "Content-Disposition: inline"
        cat ${WORKDIR}/skip.html
} | /usr/sbin/sendmail ${EMAIL_LIST}
else
 echo Adhoc sql run complete|mail -s 'Adhoc sql run complete' shivdeep.modi@ihsmarkit.com
fi

ls -l /home/oracle/shivdeep/dbmon/script_log/report_scheduler.lck >> /home/oracle/shivdeep/dbmon/script_log/report_scheduler.log
echo Removing lock file
rm -f /home/oracle/shivdeep/dbmon/script_log/report_scheduler.lck
cat /home/oracle/shivdeep/dbmon/script_log/report_scheduler.log >> /home/oracle/shivdeep/dbmon/script_log/report_scheduler_main.log
if [[ $(wc -l /home/oracle/shivdeep/dbmon/script_log/report_scheduler_main.log|cut -d " " -f1) -gt 20000 ]];then
	cp /home/oracle/shivdeep/dbmon/script_log/report_scheduler_main.log /home/oracle/shivdeep/dbmon/script_log/report_scheduler_main.log.1
    > /home/oracle/shivdeep/dbmon/script_log/report_scheduler_main.log
fi

#Final Cleanup
ps -ef|grep '[s]qlplus -s -l'|awk '{print$2}'|xargs kill -9
echo Normal Cleanup
cleanup
