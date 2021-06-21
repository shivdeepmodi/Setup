set verify off heading off feedback off
Accept year number prompt 'Give year :'

select &&year ||' is a '||
       decode( mod(&&year, 4), 0,
          decode( mod(&&year, 400), 0, 'leap year',
             decode( mod(&&year, 100), 0, 'not a Leap &&year', 'Leap year')
          ), 'Not a Leap year'
       ) as leapyear_indicator
from   dual
/
Prompt
set verify on heading on feedback on
undefine year