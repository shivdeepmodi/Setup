col action_time for a20
col action for a10
col namespace for a10
col version for a10
col comments for a30
col bundle_series heading 'BUNDLE|SERIES' for a7


select cast(ACTION_TIME  as date) action_time,
 ACTION          ,
 NAMESPACE       ,
 VERSION         ,
 ID              ,
 BUNDLE_SERIES   ,
 COMMENTS        
from DBA_REGISTRY_HISTORY;
