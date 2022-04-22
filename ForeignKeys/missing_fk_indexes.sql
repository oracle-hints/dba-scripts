-------------------------------------------------------------------------------------
-- https://oracle-hints.com/dba-scripts/ForeignKeys/missing_fk_indexes.sql
-- Lists the Foreign Keys defined on a Table
-- @missing_fk_indexes.sql
-------------------------------------------------------------------------------------
set pagesize 5000
set linesize 350
column index_status  format a15
column table_name    format a30
column fk_name       format a30
column fk_columns    format a30
column index_name    format a30
column index_columns format a30

select  decode(ix.table_name,null,'Missing Index','Index') as index_status
       ,ri.table_name      as table_name
       ,ri.constraint_name as fk_name
       ,ri.fk_columns      as fk_columns
       ,ix.index_name      as index_name
       ,ix.index_columns   as index_columns
 from
        (
           select a.table_name, a.constraint_name, listagg(a.column_name, ',') within group (order by a.position) fk_columns
             from dba_cons_columns a,
                  dba_constraints b
            where a.constraint_name = b.constraint_name
              and b.constraint_type = 'R'
              and a.owner = '&&Schema'
              and (a.table_name = '&&TableORNull' or '&&TableORNull' is null)
              and a.owner = b.owner
            group by a.table_name, a.constraint_name
        ) ri
       ,(
          select table_name, index_name, listagg(c.column_name, ',') within group (order by c.column_position) index_columns
            from dba_ind_columns c
           where c.index_owner = '&&Schema'
          group by table_name, index_name
        ) ix
 where ri.table_name = ix.table_name(+)
   and ix.index_columns(+) like ri.fk_columns || '%'
order by 1 desc, 2;
