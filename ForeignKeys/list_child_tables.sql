-------------------------------------------------------------------------------------
-- https://oracle-hints.com/dba-scripts/ForeignKeys/list_child_tables.sql
-- Lists the Child Tables for a Supplied Parent Table based on the FK Definition
-- @list_child_tables.sql
-------------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 300
SET PAGESIZE 9999
col owner format a25
col child_table format a30
col child_column format a30
col constraint_name format a50
select a.owner, a.table_name as child_table, b.column_name as child_column, a.constraint_name
from all_constraints a, all_cons_columns b
where a.constraint_name = b.constraint_name
  and r_constraint_name in (select c.constraint_name
                            from all_constraints c
                            where c.table_name = '&ParentTable'
                              and c.constraint_type = 'P')
 order by 1,2;
