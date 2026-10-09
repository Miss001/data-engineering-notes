SELECT id,
       listagg(mc,',')within group(order by mc )as mc
FROM tmp_1 GROUP BY id

SELECT id,
       listagg(mc,',')within group(order by mc ) over(partition by id)as mc
FROM tmp_1
