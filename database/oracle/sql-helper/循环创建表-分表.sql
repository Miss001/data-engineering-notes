declare
/*
传参：
${tablename} 分表的表名前缀
${fbzs}  分表的总数
*/
 YBBM varchar2(100); 
 FBBM varchar2(100);
 FBZS number;
 i number;
 v_sql varchar2(4000);
begin
  i :=0;
  FBBM :='${tablename}';
  FBZS :=to_number('${fbzs}');
  
  /*通过分表表名推算原表表名*/
  if instr(FBBM,'_',1,1)<=0 then
    YBBM :=FBBM;
  else
    YBBM :=substr(FBBM,1,instr(FBBM,'_',1,1)-1);
  end if;
  
  /*根据原表表结构创建分表*/
 loop exit when(i>=FBZS);
   begin
     /*创建表*/
     v_sql := 'create table '||FBBM||to_char(i)||' nologging as select * from '||YBBM||' where 1=0';
     execute immediate v_sql; 
     /*创建主键*/
     v_sql := 'alter table '||FBBM||to_char(i)||' add constraint PK_'||FBBM||to_char(i)||' primary key(ID)';
     execute immediate v_sql; 
     /*创建索引*/
     v_sql := 'create index IDX_'||FBBM||to_char(i)||'_ZJHM ON '||FBBM||to_char(i)||'(ZJHM)';
     execute immediate v_sql; 
     exception 
       when others then
         dbms_output.put_line(sqlcode||':'||sqlerrm);
   end;
   i :=i+1;
  end loop;
end;
