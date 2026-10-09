create or replace procedure p_template
as
/*
  【模板】 
  版本号     
  编辑时间       
  编辑人       

----------------------------------
*/
last_time     date;
v_err  varchar2(4000);
V_ID   VARCHAR2(32);
begin

V_ID := SYS_GUID();

select max(end_time)into last_time from logs a where task_name='p_template' and bz='完成';
insert into logs(ID,TASK_NAME,TASK_DESC,begin_time,end_time)
  values (V_ID,'p_template', '任务名', sysdate, null);
commit;
----------------------------------------------需求说明--------------------------------------------------------

----------------------------------------------逻辑运算--------------------------------------------------------

--------------------------------------------------------------------------------------------------
update logs set end_time=sysdate,bz='完成' where task_name='p_template' and ID=V_ID;
commit;

exception
  when others then
    v_err:= sqlcode||'-'||sqlerrm;
    update logs set bz=v_err,end_time=sysdate where task_name='p_template' and ID=V_ID;
    commit;

end;
