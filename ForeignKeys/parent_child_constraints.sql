-------------------------------------------------------------------------------------
-- https://oracle-hints.com/dba-scripts/ForeignKeys/parent_child_constraints.sql
-- Lists the Child Tables for a Supplied Parent Table based RI
-- @parent_child_constraints.sql 
-------------------------------------------------------------------------------------
SET VERIFY OFF
SET LINESIZE 300
SET PAGESIZE 9999
col owner format a25
col child_table format a30
col child_column format a30
col constraint_name format a50
SELECT p.table_name "Parent Table", c.table_name "Child Table",
     p.constraint_name "Parent Constraint", c.constraint_name "Child Constraint"
     FROM dba_constraints p
     JOIN dba_constraints c ON(p.constraint_name=c.r_constraint_name)
     WHERE (p.constraint_type = 'P' OR p.constraint_type = 'U')
     AND c.constraint_type = 'R'
     AND p.table_name = UPPER('&Table');
