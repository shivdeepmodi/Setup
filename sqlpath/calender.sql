col Sun for a2
col Mon for a2
col Tue for a2
col Wed for a2
col Thu for a2
col Fri for a2
col Sat for a2
col month for a8 justify right
col month newline
break on month

SELECT Month,"Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"
  FROM (
         --SELECT TO_CHAR(dt,'fmMonthfm YYYY') month,
         SELECT TO_CHAR(dt,'fmMonfm YYYY') month,
                TO_CHAR(dt+1,'iw') week,
                MAX(DECODE(TO_CHAR(dt,'d'),'1',LPAD(TO_CHAR(dt,'fmdd'),2))) "Sun",
                MAX(DECODE(TO_CHAR(dt,'d'),'2',LPAD(TO_CHAR(dt,'fmdd'),2))) "Mon",
                MAX(DECODE(TO_CHAR(dt,'d'),'3',LPAD(TO_CHAR(dt,'fmdd'),2))) "Tue",
                MAX(DECODE(TO_CHAR(dt,'d'),'4',LPAD(TO_CHAR(dt,'fmdd'),2))) "Wed",
                MAX(DECODE(TO_CHAR(dt,'d'),'5',LPAD(TO_CHAR(dt,'fmdd'),2))) "Thu",
                MAX(DECODE(TO_CHAR(dt,'d'),'6',LPAD(TO_CHAR(dt,'fmdd'),2))) "Fri",
                MAX(DECODE(TO_CHAR(dt,'d'),'7',LPAD(TO_CHAR(dt,'fmdd'),2))) "Sat"
           FROM ( SELECT TRUNC(SYSDATE,'y')-1+ROWNUM dt
                    FROM all_objects
                   WHERE ROWNUM <= ADD_MONTHS(TRUNC(SYSDATE,'y'),12) - TRUNC(SYSDATE,'y')
                )
          GROUP BY TO_CHAR(dt,'fmMonfm YYYY'), TO_CHAR( dt+1, 'iw' )
        )
  ORDER BY TO_DATE( month, 'Month YYYY' ), TO_NUMBER(week)
/
