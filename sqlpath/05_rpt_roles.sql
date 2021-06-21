set feedback off echo off

--DROP TABLE sum_role_grants
--;

CREATE TABLE sum_role_grants 
AS 
SELECT grantee,
       granted_role 
FROM   dba_role_privs
WHERE  grantee NOT IN ('SYS','SYSTEM')
;

ALTER TABLE sum_role_grants MODIFY (granted_role NULL)
;

INSERT INTO sum_role_grants 
SELECT      distinct a.granted_role ,
            null
FROM        dba_role_privs a 
WHERE       not exists 
           (SELECT   b.grantee 
            FROM     dba_role_privs b 
            WHERE    a.granted_role = b.grantee
           )
/

ALTER TABLE sum_role_grants ADD (role_user VARCHAR(4));

UPDATE sum_role_grants
SET    role_user = 'USER'
WHERE  grantee IN (SELECT username FROM dba_users);

UPDATE sum_role_grants
SET    role_user = 'ROLE'
WHERE  grantee IN (SELECT role FROM dba_roles);

COMMIT;

column instance_name new_value new_instance
column odate new_value odate1

select instance_name,
       to_char(sysdate,'ddMonyyyy') odate
from   v$instance
;

DECLARE
    CURSOR c_role_privs
    IS
        SELECT     level,
                   rpad(a.grantee,30,' ') grantee,
                   a.role_user
        FROM       sum_role_grants a
        START WITH (a.grantee = a.grantee AND a.grantee IN (SELECT USERNAME FROM DBA_USERS))
        CONNECT BY PRIOR a.granted_role = a.grantee
        ;

    r_role_privs c_role_privs%ROWTYPE;

    s_grantee_1   varchar(40) := 'x';
    s_grantee_2   varchar(40) := 'x';
    s_grantee_3   varchar(40) := 'x';
    s_grantee_4   varchar(40) := 'x';
    s_grantee_5   varchar(40) := 'x';
    s_grantee_6   varchar(40) := 'x';

    first_time  number(10) :=0;
    
BEGIN

    OPEN c_role_privs;
    LOOP
        FETCH c_role_privs into r_role_privs;
        EXIT WHEN  c_role_privs%NOTFOUND;
        DBMS_OUTPUT.ENABLE(1000000);

        IF(first_time =0) 
        THEN
            first_time := 1;
            dbms_output.put_line('Hierarchical Report of Role Privileges  ');
            dbms_output.put_line(chr(0));
            dbms_output.put_line(chr(0));
            dbms_output.put_line('Level  Grantee                               Role       ');
            dbms_output.put_line('------ ------------------------------------- ---------- ');
        END IF;

        IF(r_role_privs.level = 1)
        THEN IF s_grantee_1 <> r_role_privs.grantee
            THEN 
--                dbms_output.put_line('1'); 
                dbms_output.put_line(r_role_privs.level||'      '||r_role_privs.grantee||'    '||r_role_privs.role_user);
                s_grantee_1 := r_role_privs.grantee;

                ----------------------------------------
                -- Re-initialise all the saved variables
                ----------------------------------------
                s_grantee_2  := 'x';
                s_grantee_3  := 'x';
                s_grantee_4  := 'x';
                s_grantee_5  := 'x';
                ----------------------------------------
            END IF;
        END IF;

        IF(r_role_privs.level = 2) 
        THEN IF s_grantee_2 <> r_role_privs.grantee
            THEN 
--                dbms_output.put_line('2'); 
                dbms_output.put_line('__'||r_role_privs.level||'      '||r_role_privs.grantee||'        '||r_role_privs.role_user);
                s_grantee_2 := r_role_privs.grantee;
            END IF;
        END IF;

        IF(r_role_privs.level = 3)
        THEN IF s_grantee_3 <> r_role_privs.grantee
            THEN 
--                dbms_output.put_line('3'); 
                dbms_output.put_line('____'||r_role_privs.level||'      '||r_role_privs.grantee||'      '||r_role_privs.role_user);
                s_grantee_3 := r_role_privs.grantee;
            END IF;
        END IF;

        IF(r_role_privs.level = 4)
        THEN IF s_grantee_4 <> r_role_privs.grantee
            THEN 
--                dbms_output.put_line('4'); 
                dbms_output.put_line('______'||r_role_privs.level||'      '||r_role_privs.grantee||'    '||r_role_privs.role_user);
                s_grantee_4 := r_role_privs.grantee;
            END IF;
        END IF;

        IF(r_role_privs.level = 5)
        THEN IF s_grantee_5 <> r_role_privs.grantee
            THEN 
--                dbms_output.put_line('5'); 
                dbms_output.put_line('________'||r_role_privs.level||'      '||r_role_privs.grantee||'  '||r_role_privs.role_user);
                s_grantee_5 := r_role_privs.grantee;
            END IF;
        END IF;

        IF(r_role_privs.level = 6)
        THEN IF s_grantee_6 <> r_role_privs.grantee
            THEN 
--                dbms_output.put_line('6'); 
                dbms_output.put_line('__________'||r_role_privs.level||'      '||r_role_privs.grantee||''||r_role_privs.role_user);
                s_grantee_6 := r_role_privs.grantee;
            END IF;
        END IF;
    END LOOP;
    CLOSE c_role_privs;
END;
/

DROP TABLE sum_role_grants
;
