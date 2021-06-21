Column owner    heading 'Owner'     format a13
Column db_link  heading 'DB Link'   format a30
Column username heading 'Link User' format a15
Column host     heading 'Host'      format a10
Column created  heading 'Created'   format a20

select owner,db_link,username,host,created
  from dba_db_links
/
--clear columns