/*生成日期维度表周（周一至周五）*/
declare
 starts date :=to_date('2023-01-01 00:00:00','yyyy-mm-dd hh24:mi:ss');
 ends date :=to_date('2024-01-01 00:00:00','yyyy-mm-dd hh24:mi:ss');
 st date;
 en date;
begin
  while starts < ends loop
    /*逻辑操作*/
    if to_char(starts,'day')='星期一' then
       st :=starts;
       en :=starts+7;
       starts :=starts+8;
    elsif to_char(starts,'day')='星期二' then
       st :=starts-1;
       en :=starts+6;
       starts :=starts+7;
    elsif to_char(starts,'day')='星期三' then
       st :=starts-2;
       en :=starts+5;
       starts :=starts+6;
    elsif to_char(starts,'day')='星期四' then
       st :=starts-3;
       en :=starts+4;
       starts :=starts+5;
     elsif to_char(starts,'day')='星期五' then
       st :=starts-4;
       en :=starts+3;
       starts :=starts+4;
    elsif to_char(starts,'day')='星期六' then
       st :=starts-5;
       en :=starts+2;
       starts :=starts+3;
    elsif to_char(starts,'day')='星期日' then
       st :=starts-6;
       en :=starts+1;
       starts :=starts+2;
     end if;
    insert into tb_dict_months(dm,mc,starttime,endtime)
          values(to_char(st,'iyyyiw'),  to_char(st,'iyyy')||'年'to_char(st,'iw')||'周', trunc(st), trunc(en-1))
  end loop;
 commit;
end;
