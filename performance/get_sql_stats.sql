-------------------------------------------------------------------------------------
-- https://oracle-hints.com/dba/sql_scripts/performance/get_sql_stats.sql
-- Displays SQL statement execution stats from v$sqlstats view
-- @get_sql_stats
-------------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 300
SET PAGESIZE 9999
SET LONG 2000
col SQL_ID format a16
col SQL_FULLTEXT format a70
col PLAN_HASH_VALUE format 9999999999
col EXECUTIONS format 999999999999
col ELAPSED_TIME_SECS format 99999999.99
col CPU_TIME_SECS format 99999999.99
col USER_IO_WAIT_TIME_SECS format 99999999.99
col APPLICATION_WAIT_TIME_SECS format 99999999.99
col CONCURRENCY_WAIT_TIME_SECS format 99999999.99
col AVG_SECS_PER_EXEC format 99999999.99999

select ss.SQL_ID
      ,ss.PLAN_HASH_VALUE
      ,ss.SQL_FULLTEXT
      ,ss.EXECUTIONS
      ,round(ss.ELAPSED_TIME/1000000,2)                 as ELAPSED_TIME_SECS          -- Elapsed Time
      ,round((ss.ELAPSED_TIME/1000000)/ss.EXECUTIONS,5) as AVG_SECS_PER_EXEC          -- Avg secs per execution
      ,round(ss.CPU_TIME/1000000,2)                     as CPU_TIME_SECS              -- CPU Time
      ,round(ss.USER_IO_WAIT_TIME/1000000,2)            as USER_IO_WAIT_TIME_SECS     -- User IO Wait Time  
      ,round(ss.APPLICATION_WAIT_TIME/1000000,2)        as APPLICATION_WAIT_TIME_SECS -- User IO Wait Time 
      ,round(ss.CONCURRENCY_WAIT_TIME/1000000,2)        as CONCURRENCY_WAIT_TIME_SECS -- Concurrency Wait Time  
  from V$SQLSTATS ss
--
-- Limit the Result Set
-- 
 where ss.SQL_ID = '&1'     -- Put your SQL_Id here. eg f34thrbt8rjt5
/
SET VERIFY ON
