REM Use hash value to get PLAN from v$SQL_PLAN
REM Source: http://jonathanlewis.wordpress.com/2006/12/12/plans-in-memory/

set verify off
Column simple_plan for a80

with plan_subq as (
	select
		/*+ materialize */
		child_number,
		id,
		parent_id,
		depth,
		operation || ' ' ||
		object_name || ' ' ||
		options 		simple_plan,cost,cpu_cost,io_cost
	from
		GV$sql_plan
	where
		sql_id = '&m_sql_id'
)
select
	--child_number,
	--id,
	--parent_id,
	depth,
	lpad(' ',2 * level) || simple_plan simple_plan,
	cost,cpu_cost/1048576,io_cost
from
	plan_subq
start with
	id = 0
connect by
		parent_id = prior id
	and	child_number = prior child_number
order by
	child_number,
	id
/

set verify on