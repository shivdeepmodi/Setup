Column username      heading Username         format a20
Column osuser        heading Osuser           format a20
Column terminal      heading Terminal         format a20
Column program       heading Program          format a20
Column value         heading Value            format 99999999
Column name          heading 'Statistic Name' format a50
select username,osuser,terminal,program,st.value,name.name
  from v$session s, v$sesstat st, v$statname name
 where s.sid = st.sid
   and st.statistic# = name.statistic#
   and s.sid = &sid;
clear columns