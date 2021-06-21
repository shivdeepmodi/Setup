col stmt format a40
SELECT  substr(sql_text,1,40) "Stmt", count(*),
sum(sharable_mem)    "Mem",
sum(users_opening)   "Open",
sum(executions)      "Exec"
FROM v$sql
GROUP BY substr(sql_text,1,40)
--HAVING sum(sharable_mem)>10000000
having count(*) > 100
order by 2 desc;