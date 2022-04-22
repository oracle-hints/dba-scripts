-------------------------------------------------------------------------------------
-- https://oracle-hints.com/dba/sql_scripts/FRA/fra_usage.sql
-- Lists the contents of the FRA and the space used
-- @fra_usage.sql
-------------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 300
SET PAGESIZE 9999 
select file_type, PERCENT_SPACE_USED, PERCENT_SPACE_RECLAIMABLE, NUMBER_OF_FILES from V$FLASH_RECOVERY_AREA_USAGE; 
