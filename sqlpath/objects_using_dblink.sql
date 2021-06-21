PROMPT Objects using Database Links from DBA_DEPENDENCIES
Column "Link Name" format a20
Column "Used In"   format a60

select distinct referenced_link_name "Link Name",
       'Used in '||type||' '||owner||'.'||name "Used In"
  from dba_dependencies where referenced_link_name is not null
/
clear columns