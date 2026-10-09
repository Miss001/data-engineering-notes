SELECT * FROM(
  SELECT
        zjhm,
	dm,
	num
  FROM tmp_1 
)B pivot(sum(num) for dm in('01','02','03','04'))
