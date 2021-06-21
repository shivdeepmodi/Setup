--Use hash_value frmo sql_hash.sql to get sql_text
SELECT sql_text
  FROM v$sqltext
 WHERE sql_id = '&sql_id'
 ORDER BY piece ;