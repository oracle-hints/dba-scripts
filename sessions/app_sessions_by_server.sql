-------------------------------------------------------------------------------------
-- https://oracle-hints.com/dba-scripts/sessions/application_sessions.sql
-- Displays sessions from application users that are connected to the database
-- @app_sessions_by_server.sql
-------------------------------------------------------------------------------------
set heading on;
set lines 180 pages 9999;
col machine format a50;
col program format a30;
select b.machine,
       b.program,
       count(*) as session_count
 from v$session b, v$process a
where b.paddr = a.addr
  and b.username like ('%&1%')
group by b.machine,b.program;
