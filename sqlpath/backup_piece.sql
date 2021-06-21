select recid,bs_key,handle from RC_BACKUP_PIECE 
 where media='RVE633JB'
   AND trunc(start_time) >= '01-FEB-2011'
   AND trunc(completion_time) < '02-FEB-2011'
   and db_id in (304259110) ;

select handle from RC_BACKUP_PIECE 
 where media='RVE654JB'
   and db_id in (304259110,3752020805) ;

select dbid,name from rc_database;

 304259110 FXPD
3752020805 FXPDMIS