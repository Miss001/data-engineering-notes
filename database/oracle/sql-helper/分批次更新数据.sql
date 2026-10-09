/*分批次更新数据:update*/
declare
 start number;
 end number;
begin
  start :=0;
  end :=20000;
  while start<100000 loop
     update tb_dest set a='0'
     where id>=start and id<=end;
     commit;
  start :=end+1;
  end :=end+20000;
  end loop;
end;
