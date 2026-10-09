 SELECT 
	  zjhm,
	  sum(case when dm='01' then num else 0 end) as "01",
	  sum(case when dm='02' then num else 0 end) as "02",
	  sum(case when dm='03' then num else 0 end) as "03",
	  sum(case when dm='04' then num else 0 end) as "04"
  FROM(
	  SELECT
	        zjhm,
		dm,
		num
	  FROM tmp_1 
   )B GROUP BY zjhm
