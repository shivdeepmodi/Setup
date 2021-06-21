--Query for dictonary objects
Column table_name heading 'Table Name' format a30
Column comments   heading 'Comments'   format a50

select table_name,comments
  from dict
 where table_name like upper('%&dict_obj%')
/
