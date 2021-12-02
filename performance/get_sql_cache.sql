-------------------------------------------------------------------------------------
-- https://oracle-hints.com/dba/sql_scripts/performance/get_sql_cache.sql
-- Displays SQL statements from SQL Cache Views
-- @get_sql_cache
-------------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 300
SET PAGESIZE 9999
SET LONG 2000
col SQL_ID format a16
col SQL_FULLTEXT format a70
col PLAN_HASH_VALUE format 9999999999
col PARSING_SCHEMA_NAME format a24
col ELAPSED_TIME_SECS format 99999999.99
col CPU_TIME_SECS format 99999999.99
col USER_IO_WAIT_TIME_SECS format 99999999.99
col APPLICATION_WAIT_TIME_SECS format 99999999.99
col CONCURRENCY_WAIT_TIME_SECS format 99999999.99
col EXECUTIONS format 9999999999
col AVG_SEC_PER_EXEC format 99999999.999

select PARSING_SCHEMA_NAME
      ,SQL_ID
      ,PLAN_HASH_VALUE
      ,SQL_FULLTEXT
      ,round(ELAPSED_TIME/1000000,2)              as ELAPSED_TIME_SECS          -- Elapsed Time
      ,EXECUTIONS                                 as EXECUTIONS                 -- Number of Executions
      ,round((ELAPSED_TIME/1000000)/EXECUTIONS,3) as AVG_SEC_PER_EXEC           -- Avg per exec
      ,round(CPU_TIME/1000000,2)                  as CPU_TIME_SECS              -- CPU Time
      ,round(USER_IO_WAIT_TIME/1000000,2)         as USER_IO_WAIT_TIME_SECS     -- User IO Wait Time  
      ,round(APPLICATION_WAIT_TIME/1000000,2)     as APPLICATION_WAIT_TIME_SECS -- User IO Wait Time 
      ,round(CONCURRENCY_WAIT_TIME/1000000,2)     as CONCURRENCY_WAIT_TIME_SECS -- Concurrency Wait Time  
  from V$SQL
--
-- Limit the Result Set
-- 
 where UPPER(PARSING_SCHEMA_NAME) = '<schema name>' 
   and UPPER(SQL_FULLTEXT)        LIKE '%<some string>%' 
--
-- List Results by the Criteria you are intersted in
--
order by ELAPSED_TIME desc
/
SET VERIFY ON
