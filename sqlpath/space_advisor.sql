select tablespace_name, segment_name, segment_type, partition_name,
recommendations, c1,c2,c3 from
table(dbms_space.asa_recommendations('FALSE', 'FALSE', 'FALSE'))
/