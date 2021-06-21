SELECT  substr(sql_text,1,80) "Stmt", count(*),
sum(sharable_mem)    "Mem",
sum(users_opening)   "Open",
sum(executions)      "Exec"
FROM v$sql
GROUP BY substr(sql_text,1,80)
HAVING sum(sharable_mem)>10000000
/