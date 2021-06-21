# $1 is db_name
# $2 is the check. Not used

export run_file=$3
export log_file=$4
# usr and password are passed here by the invoker
unset SQLPATH
unset ORACLE_PATH
#echo usr: $usr
#echo password: $password
> $log_file
if [[ ${usr} = 'sys' ]];
then
sqlplus -s -l ${usr}/${password}@$1 as sysdba <<! 
set heading off feedback on 
@$run_file off $log_file
!
else
sqlplus -s -l ${usr}/${password}@$1  <<!
set heading off feedback on
@$run_file
!
fi
