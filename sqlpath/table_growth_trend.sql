select * 
  from table(dbms_space.OBJECT_GROWTH_TREND('&table_owner','&table_name','TABLE'))
/