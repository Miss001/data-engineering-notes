SELECT * FROM(
  SELECT
      zjhm,
      4 as dm01,
      6 as dm02,
      5 as dm03,
      8 as dm04
  FROM  dual 
)B unpivot(num for dm in(dm01,dm02,dm03,dm04))
