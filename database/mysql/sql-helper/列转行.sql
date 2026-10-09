WITH
dt as(
select '01' as dm
union all 
select '02'
union all 
select '03'
union all 
select '04'
)
	 
SELECT 
	zjhm,
        dt.dm,
        (case dt.dm  when '01' then dm01  when '02' then dm02 when '03' then dm03 when '04' then dm04 else null end) as num
FROM (
 SELECT
      '1' zjhm,
      4 as dm01,
      6 as dm02,
      5 as dm03,
      8 as dm04
  FROM  DUAL 
)t CROSS JOIN dt
