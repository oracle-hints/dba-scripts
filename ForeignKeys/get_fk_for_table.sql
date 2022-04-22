-------------------------------------------------------------------------------------
-- https://oracle-hints.com/dba/sql_scripts/performance/get_fk_for_table.sql
-- Lists the Foreign Keys defined on a Table
-- @get_fk_for_table.sql
-------------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 300
SET PAGESIZE 9999
col table_schema_name format a25
col table_name format a30
col column_name format a30
col constraint_name format a30
col primary_table_schema_name format a30
col primary_table_name format a30
col primary_table_column format a30
select foreign_table.owner as table_schema_name, 
       foreign_table.table_name, 
       foreign_table.column_name, 
       constr.constraint_name, 
       primary_table.owner as primary_table_schema_name, 
       primary_table.table_name as primary_table_name, 
       primary_table.column_name as primary_table_column, 
       foreign_table.table_name || '.' || foreign_table.column_name || ' = ' || primary_table.table_name || '.' || primary_table.column_name as join_condition 
       from all_constraints constr 
       inner join all_cons_columns foreign_table 
       on foreign_table.owner = constr.owner and foreign_table.constraint_name = constr.constraint_name 
       inner join all_cons_columns primary_table 
       on primary_table.constraint_name = constr.r_constraint_name and primary_table.owner = constr.r_owner and primary_table.position = foreign_table.position 
          where constr.r_owner    = '&Owner' 
            and constr.table_name = '&Table' 
order by foreign_table.table_name, foreign_table.column_name;
