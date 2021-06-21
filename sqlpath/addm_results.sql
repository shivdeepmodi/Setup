--The purpose of this script is to locate the latest set of ADDM recommendations and display them in a shortened form.  
--The script also produces the command that the DBA should run to create a full ADDM report.
declare

    cursor c_problems (i_task_name in varchar2) is
        select * from dba_advisor_findings
        where
            task_name = i_task_name and
            type = 'PROBLEM';


    cursor c_symptoms (i_task_name in varchar2, i_parent_id in integer) is
        select * from dba_advisor_findings
        where
            task_name = i_task_name and
            type = 'SYMPTOM' and
            parent = i_parent_id;


    cursor c_recommendations (i_task_name in varchar2, i_problem_id in integer) is
        select * from dba_advisor_recommendations
        where
            task_name = i_task_name and
            finding_id = i_problem_id
        order by rec_id;

    cursor c_actions (i_task_name in varchar2, i_rec_id in integer) is
        select * from dba_advisor_actions
        where
            task_name = i_task_name and
            rec_id = i_rec_id;

    cursor c_objects (i_task_name in varchar2, i_obj_id in integer) is
        select * from dba_advisor_objects
        where
            task_name = i_task_name and
            object_id = i_obj_id;

    v_task_owner      varchar2(50);
    v_task_time       date;
    v_task_name       varchar2(50);
    v_finding_id      integer;
    v_finding_type    varchar2(50);

begin

  -- find latest ADDM finding that actually produced recommendations
    select owner, task_name, execution_start into v_task_owner, v_task_name, v_task_time
    from dba_advisor_tasks
    where
        execution_end = (
            select max(execution_end)
            from
                dba_advisor_tasks dat,
                dba_advisor_recommendations dar
            where
                dat.task_name = dar.task_name);

    dbms_output.put_line('Last Set of Recommendations');
    dbms_output.put_line('Task Name: ' || v_task_name);
    dbms_output.put_line('Task Started: ' || to_char(v_task_time, 'DD-MON-YYYY HH24:MI:SS'));

--    v_task_name := 'ADDM:721159330_1_833';

    for v_problem in c_problems(v_task_name) loop

        v_finding_id := v_problem.finding_id;
        v_finding_type := v_problem.type;

        dbms_output.put_line(
            CHR(10) ||
            v_finding_type || ': ' ||
            v_problem.message);

      -- print out the symptom that led to this finding
        for v_symptom in c_symptoms(v_task_name, v_finding_id) loop
            dbms_output.put_line('Symptom: ' || v_symptom.message);
        end loop;

      -- recommendations for this finding
        for v_recommendation in c_recommendations(v_task_name, v_finding_id) loop
--            dbms_output.put_line('Recommendation: ' || v_recommendation.type);

          -- actions for this recommendation
            for v_action in c_actions(v_task_name, v_recommendation.rec_id) loop
                dbms_output.put_line('Action: ' || v_action.message);

              -- objects for this action
--                for v_object in c_objects(v_task_name, v_action.object_id) loop
--                    dbms_output.put_line(
--                        v_object.attr3 ||
--                        v_object.attr4 ||
--                        v_object.attr5);
--                end loop;

            end loop;

        end loop;

    end loop;

  -- final message
    dbms_output.put_line(CHR(10) || 'For full details:' || CHR(10) || 
        'Connect as ' || v_task_owner ||
        ' and run the command:' || CHR(10) || 
        'select dbms_advisor.get_task_report(''' || v_task_name || ''', ''TEXT'', ''TYPICAL'') from dual;');

end;
/
