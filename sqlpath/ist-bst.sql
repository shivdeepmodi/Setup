REM 30-MAR-2008 06:59:59 08:00:00
REM 26-OCT-2008  06:59:59 09:00:00 
REM last Sunday of March and Oct
REM set NLS_DATE_FORMAT='DD-MON-YYYY HH24:MI:SS'
set verify off
Accept adate char prompt 'Give date[DD-MON-YYYY]:'
Accept atime char prompt 'Give time[HH24:MI:SS]:'
declare
  thishour   number;
  thisminute number;
  thissecond number;
  thismonth  varchar2(10);
  thisYear   number;
  lastday    varchar2(10);
  lastDayOfsunday varchar2(10);
  bdate date;
  gdate date;
  clockChangeDate1 date;
  clockChangeDate2 date;
  dateToday  date;
  vtime varchar2(10);
  vdate date;
  tempStr    varchar2(19);

begin
  select '&&atime' into vtime from dual;
  select '&&adate' into vdate from dual;
  select TRIM(to_char(to_date(vdate),'YYYY')) into thisYear from dual;
  thishour  :=substr(vtime,1,2);
  thisminute:=substr(vtime,4,2);
  thissecond:=substr(vtime,7,2);
  thismonth :=substr(vdate,4,3);
  select to_date('&&adate'||' '||'&&atime') into dateToday from dual;
  
    
  select TRIM(to_char(last_day(to_date('01-MAR-'||thisYear)),'DAY')) into lastday from dual;
  case lastday
  when 'SUNDAY'    then lastDayOfsunday:= 31;
  when 'MONDAY'    then lastDayOfsunday:= 30;
  when 'TUESDAY'   then lastDayOfsunday:= 29;
  when 'WEDNESDAY' then lastDayOfsunday:= 28;
  when 'THURSDAY'  then lastDayOfsunday:= 27;
  when 'FRIDAY'    then lastDayOfsunday:= 26;
  when 'SATURDAY'  then lastDayOfsunday:= 25;
  else dbms_output.put_line('Which day?:>'||lastday||'<');
  end case;
  --dbms_output.put_line('The last day of March is:'||lastday);
  tempStr:= lastDayOfSunday||'-'||'MAR'||'-'||thisYear;
  select to_date(tempStr)+13/24 into clockChangeDate1 from dual;
  --dbms_output.put_line('Clock Change date1 is:'||clockChangeDate1);
  
  select TRIM(to_char(last_day(to_date('01-OCT-'||thisYear)),'DAY')) into lastday from dual;
  case lastday
  when 'SUNDAY'    then lastDayOfsunday:= 31;
  when 'MONDAY'    then lastDayOfsunday:= 30;
  when 'TUESDAY'   then lastDayOfsunday:= 29;
  when 'WEDNESDAY' then lastDayOfsunday:= 28;
  when 'THURSDAY'  then lastDayOfsunday:= 27;
  when 'FRIDAY'    then lastDayOfsunday:= 26;
  when 'SATURDAY'  then lastDayOfsunday:= 25;
  else dbms_output.put_line('Which day?:>'||lastday||'<');
  end case;
  --dbms_output.put_line('The last day of Oct is:'||lastday);
  tempStr:= lastDayOfSunday||'-'||'OCT'||'-'||thisYear;
  select to_date(tempStr)+13/24 into clockChangeDate2 from dual;
  --dbms_output.put_line('Clock Change date2 is:'||clockChangeDate2);
  
  if ( (dateToday > clockChangeDate1) AND (dateToday < clockChangeDate2 )) then
    bdate:=to_date('&&adate'||' '||'&&atime')-4/24-30/(24*60);
    dbms_output.put_line('Date in BST is:'||bdate);
  else
    gdate:=to_date('&&adate'||' '||'&&atime')-5/24-30/(24*60);
    dbms_output.put_line('Date in GMT + 1 is:'||gdate);
  end if;

end;
/