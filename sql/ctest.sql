delete daily where work_task like 'TEST_%';
delete sub where work_task like 'TEST_%';
delete main where work_task like 'TEST_%';
commit;
