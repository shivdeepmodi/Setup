COLUMN ksppinm FORMAT A50
COLUMN ksppstvl FORMAT A50
 
SELECT
  ksppinm,
  ksppstvl
FROM
  x$ksppi a,
  x$ksppsv b
WHERE
  a.indx=b.indx 
 -- and ksppinm = '_and_pruning_enabled'
AND
  substr(ksppinm,1,1) = '_'
ORDER BY ksppinm
/