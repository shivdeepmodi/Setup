set verify off heading off feedback off

--ttitle off

column week format a80
undefine user_year
undefine def_year
undefine year
COLUMN def_year NEW_VALUE def_year NOPRINT format a1 trunc 
COLUMN pick_year NEW_VALUE year NOPRINT format a1 trunc 
select to_char(sysdate,'YYYY') def_year from dual; 
accept user_year char prompt 'Enter year to see the calender [&&def_year]: ' 
select decode('0&user_year', '0',&def_year, to_char(to_number('0&user_year','09999'))) pick_year 
  from dual;
prompt ====================================================================
prompt CALENDAR FOR YEAR &&year
prompt ====================================================================
select decode(marker, 1,     '                        ',
                      3,     'Su Mo Tu We Th Fr Sa    ',
                      2,
       decode(mon,    1,     '     J A N U A R Y      ',
                      4,     '       A P R I L        ',
                      7,     '        J U L Y         ',
                     10,     '     O C T O B E R      '),
                      4,
       decode(weekday1, '1', ' 1  2  3  4  5  6  7    ',
                        '2', '    1  2  3  4  5  6    ',
                        '3', '       1  2  3  4  5    ',
                        '4', '          1  2  3  4    ',
                        '5', '             1  2  3    ',
                        '6', '                1  2    ',
                        '7', '                   1    '),
                     32,
       decode(lastday1, '31',
       decode(weekday1, '1', '29 30 31                ',
                        '2', '28 29 30 31             ',
                        '3', '27 28 29 30 31          ',
                        '4', '26 27 28 29 30 31       ',
                        '5', '25 26 27 28 29 30 31    ',
                        '6', '24 25 26 27 28 29 30    ',
                        '7', '23 24 25 26 27 28 29    '),
       decode(weekday1, '1', '29 30                   ',
                        '2', '28 29 30                ',
                        '3', '27 28 29 30             ',
                        '4', '26 27 28 29 30          ',
                        '5', '25 26 27 28 29 30       ',
                        '6', '24 25 26 27 28 29 30    ',
                        '7', '23 24 25 26 27 28 29    ')),
                     39,
       decode(lastday1, '31',
       decode(weekday1, '6', '31                      ',
                        '7', '30 31                   ',
                             '                        '),
                        '30',
       decode(weekday1, '7', '30                      ',
                             '                        ')),
       decode(weekday1, '1', lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || ' ' ||
                             lpad(to_char(marker - 1), 2) || ' ' ||
                             lpad(to_char(marker), 2)     || ' ' ||
                             lpad(to_char(marker + 1), 2) || ' ' ||
                             lpad(to_char(marker + 2), 2) || ' ' ||
                             lpad(to_char(marker + 3), 2) || '    ',
                        '2', lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || ' ' ||
                             lpad(to_char(marker - 1), 2) || ' ' ||
                             lpad(to_char(marker), 2)     || ' ' ||
                             lpad(to_char(marker + 1), 2) || ' ' ||
                             lpad(to_char(marker + 2), 2) || '    ',
                        '3', lpad(to_char(marker - 5), 2) || ' ' ||
                             lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || ' ' ||
                             lpad(to_char(marker - 1), 2) || ' ' ||
                             lpad(to_char(marker), 2)     || ' ' ||
                             lpad(to_char(marker + 1), 2) || '    ',
                        '4', lpad(to_char(marker - 6), 2) || ' ' ||
                             lpad(to_char(marker - 5), 2) || ' ' ||
                             lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || ' ' ||
                             lpad(to_char(marker - 1), 2) || ' ' ||
                             lpad(to_char(marker), 2)     || '    ',
                        '5', lpad(to_char(marker - 7), 2) || ' ' ||
                             lpad(to_char(marker - 6), 2) || ' ' ||
                             lpad(to_char(marker - 5), 2) || ' ' ||
                             lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || ' ' ||
                             lpad(to_char(marker - 1), 2) || '    ',
                        '6', lpad(to_char(marker - 8), 2) || ' ' ||
                             lpad(to_char(marker - 7), 2) || ' ' ||
                             lpad(to_char(marker - 6), 2) || ' ' ||
                             lpad(to_char(marker - 5), 2) || ' ' ||
                             lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || '    ',
                        '7', lpad(to_char(marker - 9), 2) || ' ' ||
                             lpad(to_char(marker - 8), 2) || ' ' ||
                             lpad(to_char(marker - 7), 2) || ' ' ||
                             lpad(to_char(marker - 6), 2) || ' ' ||
                             lpad(to_char(marker - 5), 2) || ' ' ||
                             lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || '    ')) ||
      decode(marker,  1,     '                        ',
                      3,     'Su Mo Tu We Th Fr Sa    ',
                      2,
      decode(mon + 1, 2,     '    F E B R U A R Y     ',
                       5,    '         M A Y          ',
                       8,    '      A U G U S T       ',
                      11,    '    N O V E M B E R     '),
                       4,
       decode(weekday2, '1', ' 1  2  3  4  5  6  7    ',
                        '2', '    1  2  3  4  5  6    ',
                        '3', '       1  2  3  4  5    ',
                        '4', '          1  2  3  4    ',
                        '5', '             1  2  3    ',
                        '6', '                1  2    ',
                        '7', '                   1    '),
                      32,
       decode(mon + 1, 2,
       decode(lastday2, '28',
       decode(weekday2, '1', '28                      ',
                        '2', '27 28                   ',
                        '3', '26 27 28                ',
                        '4', '25 26 27 28             ',
                        '5', '24 25 26 27 28          ',
                        '6', '23 24 25 26 27 28       ',
                        '7', '23 24 25 26 27 28       '),
                        '29',
       decode(weekday2, '1', '29                      ',
                        '2', '28 29                   ',
                        '3', '27 28 29                ',
                        '4', '26 27 28 29             ',
                        '5', '25 26 27 28 29          ',
                        '6', '24 25 26 27 28 29       ',
                        '7', '23 24 25 26 27 28 29    ')),
       decode(lastday2, '31',
       decode(weekday2, '1', '29 30 31                ',
                        '2', '28 29 30 31             ',
                        '3', '27 28 29 30 31          ',
                        '4', '26 27 28 29 30 31       ',
                        '5', '25 26 27 28 29 30 31    ',
                        '6', '24 25 26 27 28 29 30    ',
                        '7', '23 24 25 26 27 28 29    '),
       decode(weekday2, '1', '29 30                   ',
                        '2', '28 29 30                ',
                        '3', '27 28 29 30             ',
                        '4', '26 27 28 29 30          ',
                        '5', '25 26 27 28 29 30       ',
                        '6', '24 25 26 27 28 29 30    ',
                        '7', '23 24 25 26 27 28 29    '))),
                      39,
       decode(mon + 1, 2,    '                        ',
       decode(lastday2, '31',
       decode(weekday2, '6', '31                      ',
                        '7', '30 31                   ',
                             '                        '),
                        '30',
       decode(weekday2, '7', '30                      ',
                             '                        '))),
       decode(weekday2, '1', lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || ' ' ||
                             lpad(to_char(marker - 1), 2) || ' ' ||
                             lpad(to_char(marker), 2)     || ' ' ||
                             lpad(to_char(marker + 1), 2) || ' ' ||
                             lpad(to_char(marker + 2), 2) || ' ' ||
                             lpad(to_char(marker + 3), 2) || '    ',
                        '2', lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || ' ' ||
                             lpad(to_char(marker - 1), 2) || ' ' ||
                             lpad(to_char(marker), 2)     || ' ' ||
                             lpad(to_char(marker + 1), 2) || ' ' ||
                             lpad(to_char(marker + 2), 2) || '    ',
                        '3', lpad(to_char(marker - 5), 2) || ' ' ||
                             lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || ' ' ||
                             lpad(to_char(marker - 1), 2) || ' ' ||
                             lpad(to_char(marker), 2)     || ' ' ||
                             lpad(to_char(marker + 1), 2) || '    ',
                        '4', lpad(to_char(marker - 6), 2) || ' ' ||
                             lpad(to_char(marker - 5), 2) || ' ' ||
                             lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || ' ' ||
                             lpad(to_char(marker - 1), 2) || ' ' ||
                             lpad(to_char(marker), 2)     || '    ',
                        '5', lpad(to_char(marker - 7), 2) || ' ' ||
                             lpad(to_char(marker - 6), 2) || ' ' ||
                             lpad(to_char(marker - 5), 2) || ' ' ||
                             lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || ' ' ||
                             lpad(to_char(marker - 1), 2) || '    ',
                        '6', lpad(to_char(marker - 8), 2) || ' ' ||
                             lpad(to_char(marker - 7), 2) || ' ' ||
                             lpad(to_char(marker - 6), 2) || ' ' ||
                             lpad(to_char(marker - 5), 2) || ' ' ||
                             lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || '    ',
                        '7', lpad(to_char(marker - 9), 2) || ' ' ||
                             lpad(to_char(marker - 8), 2) || ' ' ||
                             lpad(to_char(marker - 7), 2) || ' ' ||
                             lpad(to_char(marker - 6), 2) || ' ' ||
                             lpad(to_char(marker - 5), 2) || ' ' ||
                             lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || '    ')) ||
       decode(marker,  1,     '                        ',
                       3,     'Su Mo Tu We Th Fr Sa    ',
                       2,
       decode(mon + 2, 3,     '       M A R C H      ',
                       6,     '        J U N E       ',
                       9,     '   S E P T E M B E R  ',
                      12,     '    D E C E M B E R   '),
                       4,
       decode(weekday3, '1', ' 1  2  3  4  5  6  7  ',
                        '2', '    1  2  3  4  5  6  ',
                        '3', '       1  2  3  4  5  ',
                        '4', '          1  2  3  4  ',
                        '5', '             1  2  3  ',
                        '6', '                1  2  ',
                        '7', '                   1  '),
                      32,
       decode(lastday3, '31',
       decode(weekday3, '1', '29 30 31              ',
                        '2', '28 29 30 31           ',
                        '3', '27 28 29 30 31        ',
                        '4', '26 27 28 29 30 31     ',
                        '5', '25 26 27 28 29 30 31  ',
                        '6', '24 25 26 27 28 29 30  ',
                        '7', '23 24 25 26 27 28 29  '),
       decode(weekday3, '1', '29 30                 ',
                        '2', '28 29 30              ',
                        '3', '27 28 29 30           ',
                        '4', '26 27 28 29 30        ',
                        '5', '25 26 27 28 29 30     ',
                        '6', '24 25 26 27 28 29 30  ',
                        '7', '23 24 25 26 27 28 29  ')),
                      39,
       decode(lastday3, '31',
       decode(weekday3, '6', '31                    ',
                        '7', '30 31                 ',
                             '                      '),
                        '30',
       decode(weekday3, '7', '30                    ',
                             '                      ')),
       decode(weekday3, '1', lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || ' ' ||
                             lpad(to_char(marker - 1), 2) || ' ' ||
                             lpad(to_char(marker), 2)     || ' ' ||
                             lpad(to_char(marker + 1), 2) || ' ' ||
                             lpad(to_char(marker + 2), 2) || ' ' ||
                             lpad(to_char(marker + 3), 2) || '  ',
                        '2', lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || ' ' ||
                             lpad(to_char(marker - 1), 2) || ' ' ||
                             lpad(to_char(marker), 2)     || ' ' ||
                             lpad(to_char(marker + 1), 2) || ' ' ||
                             lpad(to_char(marker + 2), 2) || '  ',
                        '3', lpad(to_char(marker - 5), 2) || ' ' ||
                             lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || ' ' ||
                             lpad(to_char(marker - 1), 2) || ' ' ||
                             lpad(to_char(marker), 2)     || ' ' ||
                             lpad(to_char(marker + 1), 2) || '  ',
                        '4', lpad(to_char(marker - 6), 2) || ' ' ||
                             lpad(to_char(marker - 5), 2) || ' ' ||
                             lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || ' ' ||
                             lpad(to_char(marker - 1), 2) || ' ' ||
                             lpad(to_char(marker), 2)     || '  ',
                        '5', lpad(to_char(marker - 7), 2) || ' ' ||
                             lpad(to_char(marker - 6), 2) || ' ' ||
                             lpad(to_char(marker - 5), 2) || ' ' ||
                             lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || ' ' ||
                             lpad(to_char(marker - 1), 2) || '  ',
                        '6', lpad(to_char(marker - 8), 2) || ' ' ||
                             lpad(to_char(marker - 7), 2) || ' ' ||
                             lpad(to_char(marker - 6), 2) || ' ' ||
                             lpad(to_char(marker - 5), 2) || ' ' ||
                             lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || ' ' ||
                             lpad(to_char(marker - 2), 2) || '  ',
                        '7', lpad(to_char(marker - 9), 2) || ' ' ||
                             lpad(to_char(marker - 8), 2) || ' ' ||
                             lpad(to_char(marker - 7), 2) || ' ' ||
                             lpad(to_char(marker - 6), 2) || ' ' ||
                             lpad(to_char(marker - 5), 2) || ' ' ||
                             lpad(to_char(marker - 4), 2) || ' ' ||
                             lpad(to_char(marker - 3), 2) || '  ')) week
from
(select m.r mon,
       s.r marker,
       to_char(to_date('01' ||
       lpad(rtrim(ltrim(to_char(m.r))),     2, '0') ||
       '&year', 'DDMMYYYY'), 'D') weekday1,
       to_char(to_date('01' ||
       lpad(rtrim(ltrim(to_char(m.r + 1))), 2, '0') ||
       '&year', 'DDMMYYYY'), 'D') weekday2,
       to_char(to_date('01' ||
       lpad(rtrim(ltrim(to_char(m.r + 2))), 2, '0') ||
       '&year', 'DDMMYYYY'), 'D') weekday3,
       to_char(last_day(to_date('01'  ||
       lpad(rtrim(ltrim(to_char(m.r))),     2, '0') ||
       '&year', 'DDMMYYYY')), 'DD') lastday1,
       to_char(last_day(to_date('01'  ||
       lpad(rtrim(ltrim(to_char(m.r + 1))), 2, '0') ||
       '&year', 'DDMMYYYY')), 'DD') lastday2,
       to_char(last_day(to_date('01'  ||
       lpad(rtrim(ltrim(to_char(m.r + 2))), 2, '0') ||
       '&year', 'DDMMYYYY')), 'DD') lastday3
      from
         (select r
            from
             (select 1  r from dual union
              select 4  r from dual union
              select 7  r from dual union
              select 10 r from dual)) m,
         (select r
            from
             (select 1  r from dual union
              select 2  r from dual union
              select 3  r from dual union
              select 4  r from dual union
              select 11 r from dual union
              select 18 r from dual union
              select 25 r from dual union
              select 32 r from dual union
              select 39 r from dual)) s
      order by m.r, s.r)
/
prompt ====================================================================
--ttitle off
set verify on heading on feed on