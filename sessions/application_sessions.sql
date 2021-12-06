-------------------------------------------------------------------------------------
-- https://oracle-hints.com/dba-scripts/sessions/application_sessions.sql
-- Displays sessions from application users that are connected to the database
-- @application_sessions.sql
-------------------------------------------------------------------------------------
set heading on;
set lines 180 pages 9999;
col pid format a10;
col sid format a8;
col ser# format a8;
col box format a30;
col username format a15;
col program format a30;
select
       substr(a.spid,1,10) pid,
       substr(b.sid,1,5) sid,
       substr(b.serial#,1,15) ser#,
       substr(b.machine,1,30) box,
       substr(b.username,1,20) username,
       b.server,
       substr(b.osuser,1,8) os_user,
       substr(b.program,1,30) program
from v$session b, v$process a
where
b.paddr = a.addr
and (b.username like '%&1%')
order by spid;
