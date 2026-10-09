 SELECT
        regexp_substr(B.zj,'[^,]+',1,A.n) as split_zj
  FROM tmp_1 B,
      (select level n from dual connect by level <=20)A
  WHERE A.n(+)<=length(B.zj)-length(regexp_replace(B.zj,',',''))+1
