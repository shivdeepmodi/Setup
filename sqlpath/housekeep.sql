delete tsreport where trunc(report_date) = trunc(sysdate);
delete tsreport_date where trunc(report_date) = trunc(sysdate);
commit;
