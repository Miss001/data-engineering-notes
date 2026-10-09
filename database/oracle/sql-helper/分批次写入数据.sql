/*分批次写入数据：insert into select*/
DECLARE
  CURSOR cur IS SELECT * FROM tb_source;
  TYPE rec IS TABLE OF tb_source%ROWTYPE;
  recs rec;
BEGIN
  OPEN cur;
  WHILE(TRUE) LOOP
   FETCH cur BULK COLLECT INTO recs LIMIT 100;
   FORALL i IN 1 .. recs.COUNT
        INSERT INTO tb_dest VALUES recs (i);
        COMMIT;
   EXIT WHEN cur%NOTFOUND;
 END LOOP;
 CLOSE cur;
END;
