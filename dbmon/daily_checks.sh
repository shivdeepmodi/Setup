#!/bin/ksh93
trap 'pkill -9 -P $$' 1 2 3 4 5 9 15
export WORKDIR=/home/oracle/shivdeep/dbmon
export LOGDIR=${WORKDIR}/log

#Got from invoker
export RUN_THE_REPORTS_FOR_DAILY=${RUN_THE_REPORTS_FOR}
export RUN_ALL_DAILY=${RUN_ALL}

echo RUN_THE_REPORTS_FOR_DAILY: ${RUN_THE_REPORTS_FOR_DAILY}
echo RUN_ALL_DAILY: ${RUN_ALL_DAILY}

cd $WORKDIR

#Global
export WTIME=10        #Wait how many seconds
export FINAL_WAIT=600 #Final wait
#export FINAL_WAIT=20 #Final wait
export WAIT_TRY=10


function tablespace_check
{
db_name=${1}
usr=${2}
password=${3}

run_file=$WORKDIR/${4}
run_desc=${5}
log_file=$WORKDIR/log/${run_desc}.${db_name}.log
touch $log_file
#echo tablespace_check $db_name $usr $password $run_file $run_desc $log_file
#
export password
export usr
#
wrap_sqlplus.sh $db_name ${run_desc} $run_file $log_file
}


#function tablespace_check end

function run_reports
{

DB_NAME=${1}
DB_ROLE=${2}
DB_CHECKS_TDB=${3}
USR=${4}
PASSWO=${5}
IS_WAIT='Y'
echo function:run_reports:$DB_NAME:$DB_ROLE:$DB_CHECKS_TDB
#echo Report DB_NAME: $DB_NAME
#echo DB_ROLE: $DB_ROLE
#echo DB_CHECKS_TDB=$DB_CHECKS_TDB
#echo USR:$USR
#echo PASSWO:$PASSWO
#echo Run Reports: $DB_CHECKS_TDB
case $DB_ROLE in
"PRIMARY"|"SNAPSHOT" )
	for chk in $DB_CHECKS_TDB
	do
    touch $WORKDIR/log/${chk}.${DB_NAME}.log
	case ${chk} in
	"TABLESPACE_CHECK" )
	#echo $DB_NAME: Check: ${chk}
	tablespace_check $DB_NAME $USR $PASSWO tbs_check.sql TABLESPACE_CHECK  &
	;;
	"RESTORE_POINT_CHECK" ) 
	#echo $DB_NAME: Check: ${chk}
	tablespace_check $DB_NAME $USR $PASSWO rp.sql RESTORE_POINT_CHECK  &
	;;
	"FRA_USAGE_CHECK" )
	#echo $DB_NAME: Check: ${chk}
	tablespace_check $DB_NAME $USR $PASSWO fra1.sql FRA_USAGE_CHECK  &
	;;
	"DB_FILES_CHECK" ) 
	#echo $DB_NAME: Check: ${chk}
	tablespace_check $DB_NAME $USR $PASSWO db_files.sql DB_FILES_CHECK  &
	;;
	"TBS_FILES_COUNT" ) 
	#echo $DB_NAME: Check: ${chk}
	tablespace_check $DB_NAME $USR $PASSWO tbs_files_count.sql TBS_FILES_COUNT  &
	;;
	"RMAN_BACKUP" ) 
	#echo $DB_NAME: Check: ${chk}
    grep -wi $DB_NAME $WORKDIR/skip.rman > /dev/null
    if [[ $? -eq 0 ]];then
      echo  $DB_NAME: Check: ${chk}: Skipping backup check since NON-PROD
      touch $WORKDIR/log/RMAN_BACKUP.${DB_NAME}.log
    else
	  tablespace_check $DB_NAME $USR $PASSWO backup.sql RMAN_BACKUP  &
    fi
	;;
    "ADHOC_SQL" )
	#echo $DB_NAME: Check: ${chk}
	tablespace_check $DB_NAME $USR $PASSWO adhoc_dba.sql ADHOC_SQL  &
	;;
	esac
    
	done

##	let IS_WAIT=1 # Run the while loop indefinitely unless IS_WAIT <> 1
##	let LETS_WAIT=0 # Wait until $LETS_WAIT < $ FINAL_WAIT
##
##	while [[ ${IS_WAIT} -eq 1 && ${LETS_WAIT} -lt ${FINAL_WAIT} ]]
##	do
##			#JOB_COUNT=`jobs|wc -l|awk '{print $1}'`
##			if [[ `jobs|wc -l`  -ne 0 ]];then
##				let LETS_WAIT=LETS_WAIT+1
##                for ii in `pgrep -P $$`
##                do
##                  ps -ef|grep $ii|grep -v grep
##                done
##
##				sleep $WTIME 
##			else
##				#echo $ii: job is not running
##				#echo  $DB_NAME: Jobs are complete
##				let IS_WAIT=0
##			fi
##	done
##
##	pgrep -P $$ > /dev/null # Job is running
##    if [[ $? -eq 0 ]]; then
##		jobs
##		echo ${DB_NAME}: Background job will be killed: `jobs`
##		echo ${DB_NAME}: Killing jobs:run_reports:$DB_ROLE
##		pkill -P $$
##        IS_WAIT=0
##    fi 

    #Instead of waiting wait for $FINAL_WAIT
    #wait 

    ii=0
    while [[ $ii -lt ${FINAL_WAIT} ]];
    do
     pgrep -P $$ > /dev/null
     if [[ $? -ne 0 ]];then
      break
     fi
     let ii=ii+1
     sleep 1
    done


	for chk in $DB_CHECKS_TDB
	do
	log_file=$LOGDIR/${chk}.${DB_NAME}.log
	if [[ $(grep 'no rows selected' ${log_file}|sed '/^$/d'|wc -l) -eq 1 ]];then
	    echo $db_name : $chk did not return rows
	else
		grep ORA- ${log_file} > /dev/null
		if [[ $? -eq 0 ]];then
			echo ${db_name}: Error : $chk: `grep ORA- ${log_file}`
		else
			cat ${log_file}|egrep -v 'row.* selected|Elapsed' ${log_file}|sed '/^$/d' >> ${WORKDIR}/log/${chk}.check.${RUN_THREAD}
		fi
	fi
	done
	;;
"PHYSICAL")
	#echo In run_reports ROLE is PHYSICAL
	#echo DB checks are: $DB_CHECKS_TDB
	for chk in $DB_CHECKS_TDB
	do
    touch $WORKDIR/log/${chk}.${DB_NAME}.log
	case ${chk} in
	"RESTORE_POINT_CHECK" ) 
	#echo $DB_NAME: Check: ${chk}
	tablespace_check $DB_NAME $USR $PASSWO rp.sql RESTORE_POINT_CHECK  &
	;;
	"FRA_USAGE_CHECK" )
	#echo $DB_NAME: Check: ${chk}
	tablespace_check $DB_NAME $USR $PASSWO fra1.sql FRA_USAGE_CHECK  &
	;;
	"STDBY_GAP_CHECK" ) 
	#echo $DB_NAME: Check: ${chk}
	tablespace_check $DB_NAME $USR $PASSWO gap1.sql STDBY_GAP_CHECK  &
	;;
	"DB_FILES_CHECK" ) 
	#echo $DB_NAME: Check: ${chk}
	tablespace_check $DB_NAME $USR $PASSWO db_files.sql DB_FILES_CHECK  &
	;;
	"TBS_FILES_COUNT" )
      touch $WORKDIR/log/TBS_FILES_COUNT.${DB_NAME}.log
    ;; 
	"RMAN_BACKUP" ) 
	#echo $DB_NAME: Check: ${chk}
    grep -wi $DB_NAME $WORKDIR/skip.rman > /dev/null
    if [[ $? -eq 0 ]];then
      echo  $DB_NAME: Check: ${chk}: Skipping backup check since Local Standby
      touch $WORKDIR/log/RMAN_BACKUP.${DB_NAME}.log
    else
rman $USR/$PASSWO@$DB_NAME <<! > /dev/null
!
	  tablespace_check $DB_NAME $USR $PASSWO backup.sql RMAN_BACKUP  &
    fi
	;;
	esac
	done

##	let IS_WAIT=1 # Run the while loop indefinitely unless IS_WAIT <> 1
##	let LETS_WAIT=0 # Wait until $LETS_WAIT < $ FINAL_WAIT
##
##	while [[ ${IS_WAIT} -eq 1 && ${LETS_WAIT} -lt ${FINAL_WAIT} ]]
##	do
##			#JOB_COUNT=`jobs|wc -l|awk '{print $1}'`
##			if [[ `jobs|wc -l`  -ne 0 ]];then
##				let LETS_WAIT=LETS_WAIT+1
##				sleep $WTIME 
##			else
##				#echo $ii: job is not running
##				#echo  $DB_NAME: Jobs are complete
##				let IS_WAIT=0
##			fi
##	done
##
##	pgrep -P $$ > /dev/null # Job is running
##    if [[ $? -eq 0 ]]; then
##		jobs
##		echo ${DB_NAME}: Background job will be killed: `jobs`
##		echo ${DB_NAME}: Killing jobs:run_reports:$DB_ROLE
##		pkill -P $$
##		IS_WAIT=0
##    fi 

    #Instead of waiting wait for $FINAL_WAIT
    #wait 

    ii=0
    while [[ $ii -lt ${FINAL_WAIT} ]];
    do
     pgrep -P $$ > /dev/null
     if [[ $? -ne 0 ]];then
      break
     fi
     let ii=ii+1
     sleep 1
    done

	for chk in $DB_CHECKS_TDB
	do
	log_file=$LOGDIR/${chk}.${DB_NAME}.log
	if [[ $(grep 'no rows selected' ${log_file}|sed '/^$/d'|wc -l) -eq 1 ]];then
	    echo $db_name : $chk did not return rows
	else
		grep ORA- ${log_file} > /dev/null
		if [[ $? -eq 0 ]];then
			echo ${db_name}: Error : $chk: `grep ORA- ${log_file}`
		else
			cat ${log_file}|egrep -v 'row.* selected|Elapsed' ${log_file}|sed '/^$/d' >> ${WORKDIR}/log/${chk}.check.${RUN_THREAD}
		fi
	fi
	done

;;
esac


}
#function run_reports end



# Main start
DB_PASS=${1}
RUN_THREAD=${2}
>${WORKDIR}/log/TABLESPACE_CHECK.check.${RUN_THREAD}
#>${WORKDIR}/log/TABLESPACE_CHECK.skip.${RUN_THREAD}
>${WORKDIR}/log/RESTORE_POINT_CHECK.check.${RUN_THREAD}
>${WORKDIR}/log/FRA_USAGE_CHECK.check.${RUN_THREAD}
>${WORKDIR}/log/STDBY_GAP_CHECK.check.${RUN_THREAD}
>${WORKDIR}/log/DB_FILES_CHECK.check.${RUN_THREAD}
>${WORKDIR}/log/TBS_FILES_COUNT.check.${RUN_THREAD}
>${WORKDIR}/log/RMAN_BACKUP.check.${RUN_THREAD}

#grep -v ^\# db_pass|sort -k 1 |sed '/^$/d' > db_pass.tmp1
LINES=$(wc -l ${DB_PASS} |cut -d " " -f1)
for ii in $(seq 1 ${LINES})
do


set -A set1 `sed -n "${ii},${ii}p" ${DB_PASS}`

db_name=${set1[0]}; 
usr=${set1[1]}; 
password=${set1[2]}; 

#echo $db_name : User in use: $usr
#echo $db_name : Password is: $password

rm -f ${LOGDIR}/${db_name}.try 2>/dev/null

if [[ ${usr} = 'sys' ]]; then
sqlplus -s -l ${usr}/${password}@${db_name} as sysdba <<! > ${LOGDIR}/${db_name}.try 2>&1 &
prompt SUCCESS
set trimspool on lines 300 head off
select '${db_name}',database_role,open_mode from v\$database;
!
else
sqlplus -s -l ${usr}/${password}@${db_name} <<! > ${LOGDIR}/${db_name}.try 2>&1 &
prompt SUCCESS
set trimspool on lines 300 head off
select '${db_name}',database_role,open_mode from v\$database;
!
fi

#Check sqlplus begin

export IS_WAIT=1
COUNTER=0

while [[ $IS_WAIT -eq 1 && $COUNTER -le $WAIT_TRY ]]
do
	DATABASE_ROLE=
	echo ${db_name}~${RUN_THREAD}: TRY:IS_WAIT:$IS_WAIT: COUNTER $COUNTER of $WAIT_TRY ...

	if [[ $COUNTER -le $WAIT_TRY ]]; then #out1
		pgrep -P $$ > /dev/null
			if [[ $? -eq 0 ]];then #out2
      			sleep $WTIME
			else
    			grep 'SUCCESS' ${LOGDIR}/${db_name}.try > /dev/null 
				if [[ $? -eq 0 ]];then
					printf "%-20s:%10s:%-10s\n" ${db_name}~${RUN_THREAD} Connection SUCCESS
					DATABASE_ROLE=`grep ${db_name} ${LOGDIR}/${db_name}.try|awk '{print$2}`
					#echo DATABASE_ROLE in Check sqlplus:$DATABASE_ROLE
					IS_WAIT=0
					if [[ ${DATABASE_ROLE} = "PRIMARY" || ${DATABASE_ROLE} = "SNAPSHOT" ]];then
						#Database is Primary
						#export DB_CHECKS="TABLESPACE_CHECK RESTORE_POINT_CHECK FRA_USAGE_CHECK DB_FILES_CHECK TBS_FILES_COUNT RMAN_BACKUP"
						export DB_CHECKS=${RUN_THE_REPORTS_FOR_DAILY}
						#export DB_CHECKS="TABLESPACE_CHECK"
						#echo $db_name:$DB_CHECKS
						run_reports ${db_name} ${DATABASE_ROLE} "${DB_CHECKS}" $usr $password
					elif [[ ${DATABASE_ROLE} = "PHYSICAL" ]];then
                        echo ${db_name}:RUN_ALL_DAILY: $RUN_ALL_DAILY
                        echo ${db_name}:RUN_THE_REPORTS_FOR_DAILY: $RUN_THE_REPORTS_FOR_DAILY
						#export DB_CHECKS="RESTORE_POINT_CHECK FRA_USAGE_CHECK STDBY_GAP_CHECK DB_FILES_CHECK RMAN_BACKUP"
                        if [[ ${RUN_ALL_DAILY} = 'ALL' ]];then
                          export DB_CHECKS=${RUN_THE_REPORTS_FOR_DAILY}
                        elif [[ ${RUN_ALL_DAILY} = 'NO' && ${RUN_THE_REPORTS_FOR_DAILY} = 'TABLESPACE_CHECK' ]];then
                          echo ${db_name}: ${RUN_ALL_DAILY}: Skipping Physical Standby 
                          touch $WORKDIR/log/TABLESPACE_CHECK.${DB_NAME}.log
                        else
						  export DB_CHECKS=${RUN_THE_REPORTS_FOR_DAILY}
                        fi
						#echo $db_name:$DB_CHECKS
						run_reports ${db_name} ${DATABASE_ROLE} "${DB_CHECKS}" $usr $password
					else
					:
					fi
				else 
					#echo ${db_name}:~${RUN_THREAD} Connection : FAILURE : `egrep 'ORA-|TNS' ${LOGDIR}/${db_name}.try`
					printf "%-20s:%-7s:%-120s\n" ${db_name} FAILURE "`egrep 'ORA-|TNS' ${LOGDIR}/${db_name}.try`" 
					IS_WAIT=0
				fi
			fi #out2
	else
		pgrep -P $$ > /dev/null
		if [[ $? -eq 0 ]];then #out3
			IS_WAIT=0
			#echo $db_name: TIMEOUT :  $WAIT_TRY seconds : DB not accesible/responding
			printf "%-20s:%10s:%-7s %-d %-7s: %-2s %-3s  %s %d\n" ${db_name}~${RUN_THREAD} Connection TIMEOUT $WAIT_TRY seconds DB not accesible/responding $COUNTER
            #leave it don't kill it
			#pkill -P $$
		fi # out3
	fi #out1
	let COUNTER=COUNTER+1


done


#Check sqlplus end

# List all elements
#echo ${set1[*]}
# List subscripts
#echo ${!set1[@]}

done 

#Main End
