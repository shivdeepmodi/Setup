#!/bin/ksh
unset SQLPATH ORACLE_PATH
export ORACLE_SID=OEMPD1
export ORACLE_HOME=`cat /etc/oratab| grep OEMPD1|grep -vE "^\#"|cut -d ":" -f2|tail -1`
export PATH=$PATH:$ORACLE_HOME/bin
export Count=$(sqlplus -s / as sysdba << EOF
set echo off head off feed off
select count(*) from sysman.mgmt\$availability_current where target_type='oracle_emd' and availability_status not in ('Target Up', 'Blackout') and target_name like '%pd%';
exit;
EOF)
REP_HTML=/home/oracle/shivdeep/temp_work/agent_down.html
if [[ $Count -gt 0 ]]
then
sqlplus -S / as sysdba << EOT
set echo on
set lines 200
col JOB_NAME for a55
col TARGET_NAME for a35
col STATUS for a20
SET MARKUP HTML ON SPOOL ON
spool $REP_HTML replace
select target_name, availability_status from sysman.mgmt\$availability_current where target_type='oracle_emd' and availability_status not in ('Target Up', 'Blackout') and target_name like '%pd%';
SET MARKUP HTML OFF
spool off;
EOT

export MAILDBA="shivdeep.modi@ihsmarkit.com"
export THIS_SUBJECT="Agent Down Report"
    {
        echo "From: DBA-checks@markit.com"
        echo "To: ${MAILDBA}"
        echo "Subject: ${THIS_SUBJECT}"
        echo "MIME-Version: 1.0"
        echo "Content-Type: text/html"
        echo "Content-Disposition: inline"
        cat $REP_HTML
    } | /usr/sbin/sendmail ${MAILDBA}
else 
 echo All ok

fi

