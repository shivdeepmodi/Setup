rem Script to display audited objects
rem S Dodsworth - Version 1.0 - 18jan00
rem S Dodsworth - Version 1.1 - 18jan00 - renamed

col owner format a11 heading 'Owner'
col object_name format a19 heading 'Object'
col ot format a08 heading 'Type'
col cmd format a38 heading 'Command audited'

accept oname   prompt 'Enter value for object Owner : '
accept nullans prompt 'Audited Objects Only (Y)/N   : '


prompt
prompt Objects audit details setup :

select	OWNER,
	OBJECT_NAME,
	substr(OBJECT_TYPE,1,8) ot,
	nvl(
	decode(ALT,'-/-','',' ALT='||alt)||
	decode(AUD,'-/-','',' AUD='||aud)||
	decode(COM,'-/-','',' COM='||com)||
	decode(DEL,'-/-','',' DEL='||del)||
	decode(GRA,'-/-','',' GRA='||gra)||
	decode(IND,'-/-','',' IND='||ind)||
	decode(INS,'-/-','',' INS='||ins)||
	decode(LOC,'-/-','',' LOC='||loc)||
	decode(REN,'-/-','',' REN='||ren)||
	decode(SEL,'-/-','',' SEL='||sel)||
	decode(UPD,'-/-','',' UPD='||upd)||
	decode(REF,'-/-','',' REF='||ref)||
	decode(EXE,'-/-','',' EXE='||exe),
	'None') cmd
from	DBA_OBJ_AUDIT_OPTS
where	owner like upper('&oname%')
and	upper(nvl('&nullans','Y')) = 
	decode(nvl(
		decode(ALT,'-/-','','*')||
		decode(AUD,'-/-','','*')||
		decode(COM,'-/-','','*')||
		decode(DEL,'-/-','','*')||
		decode(GRA,'-/-','','*')||
		decode(IND,'-/-','','*')||
		decode(INS,'-/-','','*')||
		decode(LOC,'-/-','','*')||
		decode(REN,'-/-','','*')||
		decode(SEL,'-/-','','*')||
		decode(UPD,'-/-','','*')||
		decode(REF,'-/-','','*')||
		decode(EXE,'-/-','','*'),
		'N')
	       ,'N','N','Y'
	       )
/