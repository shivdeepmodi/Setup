--Use hash_value frmo sql_hash.sql to get sql_text
SELECT sql_text
  FROM v$sqltext
 WHERE hash_value = &hash_value
 ORDER BY piece ;