#!/bin/ksh

trap "pkill -P $$; rm -f /home/oracle/shivdeep/dbmon/script_log/adhoc_dba_script.lck;rm -f /home/oracle/shivdeep/dbmon/log/ADHOC_SCRIPT*" INT TERM
#trap "ps -ef|egrep 'daily|purge_dba_recyclebin'|grep -v grep awk '{print$2}'|xargs kill -9; rm -f /home/oracle/shivdeep/dbmon/script_log/purge_dba_recyclebin.lck" INT TERM
export WORKDIR=/home/oracle/shivdeep/dbmon
export LOGDIR=${WORKDIR}/log
export ORACLE_HOME=/u01/app/oracle/product/12.1.0.2.1_1.13/racdbhome_2
export PATH=$ORACLE_HOME/bin:$WORKDIR:$PATH
export TNS_ADMIN=/home/oracle/shivdeep/TNS_ADMIN
export EMAIL_LIST=shivdeep.modi@ihsmarkit.com
#export EMAIL_LIST=MK-GTSProductionSupportOracle@markit.com
#export EMAIL_LIST=shivdeep.modi@ihsmarkit.com
export EMAIL_LIST=akshay.verma@ihsmarkit.com
unset SQLPATH
unset ORACLE_PATH
cd $WORKDIR
exec > /home/oracle/shivdeep/dbmon/script_log/adhoc_dba_script.log 2>&1

echo "BEGIN Script on : `date`" 

rm -f $LOGDIR/*

grep -v ^\# db_pass|sort -k 1 |sed '/^$/d' > db_pass.tmp.main
grep -v ^\# db_pass|sort -k 1 |sed '/^$/d' |egrep -v 'OEM' > db_pass.tmp.main
#grep -f temp_work/db.np db_pass > db_pass.tmp.main
LINES=$(wc -l db_pass.tmp.main |cut -d " " -f1)
FILE=db_pass.tmp.main
#echo LINES:$LINES
DEGREE=30
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
for mk_ii in ADHOC_SCRIPT
do

if [[ -s ${WORKDIR}/log/${mk_ii}.check ]];then
    echo EMAIL: $mk_ii will be emailed

	case ${mk_ii} in 
	"ADHOC_SCRIPT" ) export THIS_SUBJECT='Consolidated Report: ADHOC_SCRIPT'
	sort -n -k 8 -r -t "|" < ${WORKDIR}/log/${mk_ii}.check > ${WORKDIR}/log/${mk_ii}.check.tmp
	mv ${WORKDIR}/log/${mk_ii}.check.tmp ${WORKDIR}/log/${mk_ii}.check
	;;
	esac

	cat ${WORKDIR}/${mk_ii}.html.head > ${WORKDIR}/log/${mk_ii}.html
	cat ${WORKDIR}/${mk_ii}.body_table_header >> ${WORKDIR}/log/${mk_ii}.html
	cat ${WORKDIR}/log/${mk_ii}.check |sed s'!^!<tr><td>!g'|sed 's!$!</td></tr>!g'|sed 's!|!</td><td>!g' >> ${WORKDIR}/log/${mk_ii}.html
	cat ${WORKDIR}/${mk_ii}.html.end >> ${WORKDIR}/log/${mk_ii}.html
     
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
	"ADHOC_SCRIPT" ) export THIS_SUBJECT='Consolidated Report: ADHOC_SCRIPT'
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
#Check if report is running

if [[ -f /home/oracle/shivdeep/dbmon/script_log/adhoc_dba_script.lck ]];then
echo "Report is still running.
Time now: `date`
Report running since :`head -1 /home/oracle/shivdeep/dbmon/script_log/adhoc_dba_script.log`"|mail -s 'Adhoc Script: Still Running' shivdeep.modi@markit.com,neelesh.sharma@markit.com

else
touch /home/oracle/shivdeep/dbmon/script_log/adhoc_dba_script.lck
for ii in $(seq 1 $SCRIPT_DEGREE)
do

echo Running Daily check $ii of $SCRIPT_DEGREE ..
adhoc_wrap.sh db_pass.tmp.main.${ii} ${ii} &
done 

wait

>${LOGDIR}/ADHOC_SCRIPT.check

for ii in $(seq 1 $SCRIPT_DEGREE)
do
cat ${LOGDIR}/ADHOC_SCRIPT.check.${ii} >> ${LOGDIR}/ADHOC_SCRIPT.check 
done

#make_report

echo "END Running  report end on : `date`" 

egrep 'TIMEOUT|ORA-|TNS-' /home/oracle/shivdeep/dbmon/script_log/adhoc_dba_script.log |sort -k 1|mail -s 'Adhoc Script: Skipped DBS' shivdeep.modi@ihsmarkit.com

ls -l /home/oracle/shivdeep/dbmon/script_log/adhoc_dba_script.lck >> /home/oracle/shivdeep/dbmon/script_log/adhoc_dba_script.log
echo Removing lock file
rm -f /home/oracle/shivdeep/dbmon/script_log/adhoc_dba_script.lck
cat /home/oracle/shivdeep/dbmon/script_log/adhoc_dba_script.log >> /home/oracle/shivdeep/dbmon/script_log/adhoc_dba_script_main.log
if [[ $(wc -l /home/oracle/shivdeep/dbmon/script_log/adhoc_dba_script_main.log|cut -d " " -f1) -gt 20000 ]];then
	cp /home/oracle/shivdeep/dbmon/script_log/adhoc_dba_script_main.log /home/oracle/shivdeep/dbmon/script_log/adhoc_dba_script_main.log.1
    > /home/oracle/shivdeep/dbmon/script_log/adhoc_dba_script_main.log
fi
fi #Check if report is running
