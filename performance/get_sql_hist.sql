-------------------------------------------------------------------------------------
-- https://oracle-hints.com/dba/sql_scripts/performance/get_sql_hist.sql
-- Displays SQL statements from DBA_HIST ... views
-- @get_sql_hist
-------------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 300
SET PAGESIZE 9999
SET LONG 2000
col SQL_ID format a20
col SQL_TEXT format a200
col PLAN_HASH_VALUE format a20
col EXECUTIONS_DELTA format 9999999999999
col PARSING_SCHEMA_NAME format a24
col ELAPSED_TIME_DELTA_SECS format 999999999.99
col CPU_TIME_DELTA_SECS format 999999999.99
col IOWAIT_DELTA_SECS format 999999999.99
col CCWAIT_DELTA_SECS format 999999999.99
col SNAP_ID format 9999999
col END_INTERVAL_TIME format a40
col AVG_SECS_PER_EXEC format 999999999.99999

select stat.SQL_ID
      ,txt.SQL_TEXT
      ,stat.PLAN_HASH_VALUE
      ,stat.EXECUTIONS_DELTA
      ,stat.PARSING_SCHEMA_NAME
      ,round(stat.ELAPSED_TIME_DELTA/1000000,2)                         as ELAPSED_TIME_DELTA_SECS      -- Elapsed Time
      ,round((stat.ELAPSED_TIME_DELTA/1000000)/stat.EXECUTIONS_DELTA,5) as AVG_SECS_PER_EXEC            -- Avg time per execution
      ,round(stat.CPU_TIME_DELTA/1000000,2)                             as CPU_TIME_DELTA_SECS          -- CPU Time
      ,round(stat.IOWAIT_DELTA/1000000,2)                               as IOWAIT_DELTA_SECS            -- IO Wait
      ,round(stat.CCWAIT_DELTA/1000000,2)                               as CCWAIT_DELTA_SECS            -- Concurrency Wait
      ,stat.SNAP_ID 
      ,ss.END_INTERVAL_TIME 
  from DBA_HIST_SQLSTAT stat
      ,DBA_HIST_SQLTEXT txt      
      ,DBA_HIST_SNAPSHOT ss
 where stat.SQL_ID                     = txt.SQL_ID 
   and stat.DBID                       = txt.DBID 
   and ss.DBID                         = stat.DBID 
   and ss.INSTANCE_NUMBER              = stat.INSTANCE_NUMBER 
   and stat.SNAP_ID                    = ss.SNAP_ID 
   and stat.DBID                       = (select dbid from v$database)
 -- Limit the Result Set
   and stat.SNAP_ID                    >= 0
   and stat.SNAP_ID                    <= 999999
   and stat.INSTANCE_NUMBER            in (1,2) 
   and ss.BEGIN_INTERVAL_TIME          >= sysdate-30
   and UPPER(stat.PARSING_SCHEMA_NAME) = '<SCHEMA NAME>'
   and UPPER(txt.SQL_TEXT)             LIKE '<%SOME STRING%>' 
--   and stat.sql_id = '<sql id here>'
-- Order the Output based on what yopu are looking for
--order by stat.ELAPSED_TIME_DELTA desc
--order by stat.CPU_TIME_DELTA desc
--order by stat.IOWAIT_DELTA desc
--order by stat.CCWAIT_DELTA desc
order by AVG_SECS_PER_EXEC desc
/
SET VERIFY OFF
SET LINESIZE 300
