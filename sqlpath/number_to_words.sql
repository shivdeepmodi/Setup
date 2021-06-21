Accept num number prompt 'Give the number to translated to words :'
set verify off
Column num  heading 'Number'   format 99999999
Column word heading 'In Words' format a30
select &&num num,
       decode( sign( &num ), -1, 'Negative ', 0, 'Zero', NULL ) ||decode( sign( abs(&num) ), +1, to_char( to_date( abs(&num),'J'),'Jsp') ) word
from dual
/
set verify on