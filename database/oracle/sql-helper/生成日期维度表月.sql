/*生成日期维度表：月（自然月）*/
declare
 starts date :=to_date('2023-01-01 00:00:00','yyyy-mm-dd hh24:mi:ss');
 ends date :=to_date('2024-01-01 00:00:00','yyyy-mm-dd hh24:mi:ss');
begin
  while starts < ends loop
     /*逻辑操作*/
    insert into tb_dict_months(dm,mc,starttime,endtime)
          values(to_char(starts,'yyyymm'),  to_char(starts,'yyyy')||'年'to_char(starts,'mm')||'月',last_day(add_months(trunc(starts),-1))+1 ,last_day(trunc(starts)))
    starts := add_months(starts,1);
  end loop;
 commit;
end;
