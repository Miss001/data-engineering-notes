/*根据创建的配置表，批量查询数据。表中的分表按规律创建表名*/
declare
 Cursor sqlconfig is select 'a' as tbn,'0' as fb from dual;
 v_sql varchar2(4000);
 j number;
 tablenames varchar2(100);
begin
  select 'b' into tablenames from dual;
  
  for i in sqlconfig loop
    begin
      if i.fb=0 then
        for k in(select ''as sqls from user_tab_columns a 
                  where a.column_name='ID' 
                  and a.table_name=upper(i.tbn) ) loop
         begin
           v_sql := k.sqls;
           execute immediate v_sql;
           commit;
           exception 
             when others then
               dbms_output.put_line(sqlcode||':'||sqlerrm);
         end;
        end loop;
       -------分表标识-----
       else 
         j :=0;
         loop exit when(j>=i.fb);
           begin
             for k in(select ''as sqls from user_tab_columns a 
                        where a.column_name='ID' 
                            and a.table_name=upper(i.tbn||to_char(j)) ) loop
               begin
                 v_sql := k.sqls;
                 execute immediate v_sql;
                 commit;
                 exception 
                   when others then
                     dbms_output.put_line(sqlcode||':'||sqlerrm);
               end;
              end loop;
           end;
           j :=j+1;
         end loop;
        end if;
        
    end;
   end loop;
end;
