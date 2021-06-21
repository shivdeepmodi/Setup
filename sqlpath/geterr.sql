rem geterr.sql
rem script to get the compilation errors of packages
rem Steve Dodsworth - Version 1.0 - 06jun96
rem Steve Dodsworth - Version 2.0 - 13jan01 - added owner
rem Shivdeep Modi   - Version 2.1 - 07nov06 - Changed the prompt, removed, added columns and done formatting

column "LINE/COL" format a8

accept xname prompt 'Name  of invalid object: '
accept owner prompt 'Owner of invalid object: '

Column type                    heading 'Type'      format a10
Column e.line||'/'||e.position heading 'Line/Col'  format a9
Column text                    heading 'Source'    format a30
Column substr(e.text,1,75)     heading 'Error'     format a75 wrapped

break on type
set verify off

select e.type,
       e.line||'/'||e.position,
       s.text,
       substr(e.text,1,75)
  from dba_source s, dba_errors e
 where e.name = s.name (+)
   and e.name = upper('&xname')
   and s.name (+) = upper('&xname')
   and e.type = s.type(+)
   and e.line = s.line(+)
   and e.owner = upper('&owner')
 order by e.sequence, e.line
/
set verify on
--clear columns
--clear breaks