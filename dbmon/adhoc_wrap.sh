#!/bin/ksh

export WORKDIR=/home/oracle/shivdeep/dbmon
export LOGDIR=${WORKDIR}/log

cd $WORKDIR

#Global
export WTIME=1        #Wait how many seconds
export FINAL_WAIT=900 #Final wait
export WAIT_TRY=5

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
#echo Report DB_NAME: $DB_NAME
#echo DB_ROLE: $DB_ROLE
#echo DB_CHECKS_TDB=$DB_CHECKS_TDB
#echo USR:$USR
#echo PASSWO:$PASSWO
#echo Run Reports: $DB_CHECKS_TDB
case $DB_ROLE in
"PRIMARY" )
	tablespace_check $DB_NAME $USR $PASSWO adhoc_dba.sql ADHOC_SCRIPT  &
	;;
esac


}
#function run_reports end



# Main start
DB_PASS=${1}
RUN_THREAD=${2}
>${WORKDIR}/log/ADHOC_SCRIPT.check.${RUN_THREAD}

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
sqlplus -s ${usr}/${password}@${db_name} as sysdba <<! > ${LOGDIR}/${db_name}.try 2>&1 &
prompt SUCCESS
set trimspool on lines 300 head off
select '${db_name}',database_role,open_mode from v\$database;
!
else
sqlplus -s ${usr}/${password}@${db_name} <<! > ${LOGDIR}/${db_name}.try 2>&1 &
prompt SUCCESS
set trimspool on lines 300 head off
select '${db_name}',database_role,open_mode from v\$database;
!
fi

#Check sqlplus begin

IS_WAIT=1
COUNTER=0

while [[ $IS_WAIT -eq 1 && $COUNTER -le $WAIT_TRY ]]
do
	DATABASE_ROLE=
	#echo ${db_name}~${RUN_THREAD}: TRY: Waiting $COUNTER of $WAIT_TRY ...

	if [[ $COUNTER -lt $WAIT_TRY ]]; then #out1
		pgrep -P $$ > /dev/null
			if [[ $? -eq 0 ]];then #out2
      			sleep $WTIME
			else
    			grep 'SUCCESS' ${LOGDIR}/${db_name}.try > /dev/null 
				if [[ $? -eq 0 ]];then
					#printf "%-20s:%10s:%-10s\n" ${db_name}~${RUN_THREAD} Connection SUCCESS
					DATABASE_ROLE=`grep ${db_name} ${LOGDIR}/${db_name}.try|awk '{print$2}`
					#echo DATABASE_ROLE in Check sqlplus:$DATABASE_ROLE
					IS_WAIT=0
					if [[ ${DATABASE_ROLE} = "PRIMARY" ]];then
						#Database is Primary
						export DB_CHECKS="ADHOC_SCRIPT"
						#echo $db_name:$DB_CHECKS
						run_reports ${db_name} ${DATABASE_ROLE} "${DB_CHECKS}" $usr $password
					elif [[ ${DATABASE_ROLE} = "PHYSICAL" ]];then
						echo ${db_name}: Database is Physical standby
					else
					:
					fi
				else 
					#echo ${db_name}: Connection : FAILURE : `egrep 'ORA-|TNS' ${LOGDIR}/${db_name}.try`
					printf "%-20s:%-7s:%-120s\n" ${db_name}~${RUN_THREAD} FAILURE "`egrep 'ORA-|TNS' ${LOGDIR}/${db_name}.try`" 
					IS_WAIT=0
				fi
			fi #out2
	else
		pgrep -P $$ > /dev/null
		if [[ $? -eq 0 ]];then #out3
			IS_WAIT=0
			#echo $db_name~${RUN_THREAD} TIMEOUT :  $WAIT_TRY seconds : DB not accesible/responding
			printf "%-20s:%10s:%-7s %-d %-7s: %-2s %-3s  %s %d\n" ${db_name} Connection TIMEOUT $WAIT_TRY seconds DB not accesible/responding $COUNTER
			pkill -P $$
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
