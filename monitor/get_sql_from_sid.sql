-------------------------------------------------------------------------------------
-- https://oracle-hints.com/dba/sql_scripts/performance/get_sql_from_sid.sql
-- Displays SQL statement for a sid number
-- @get_sql_from_sid
-------------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 300
SET PAGESIZE 9999
SET LONG 2000
col SQL_TEXT format a120

SELECT a.sql_text
FROM   v$sqltext st,
       v$session s
WHERE  st.address    = s.sql_address
AND    st.hash_value = s.sql_hash_value
AND    s.sid = &sid
ORDER BY st.piece
/
SET VERIFY ON