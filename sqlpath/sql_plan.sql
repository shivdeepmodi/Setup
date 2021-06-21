column id          format 999 newline
column operation   format a20
column operation   format a20
column options     format a15
column object_name format a22 trunc
column optimizer   format a3  trunc

SELECT id
     , lpad (' ', depth) || operation operation
     , options
     , object_name
     , optimizer
     , cost
  FROM V$SQL_PLAN
 WHERE hash_value = &hash_value
   AND address    = '&address'
 START WITH id = 0
 CONNECT BY 
       (     prior id           = parent_id
         AND prior hash_value   = hash_value
         AND prior child_number = child_number
       )
 ORDER SIBLINGS BY id, position;
