  SELECT
        substring_index(substring_index(B.zj, ',', A.help_topic_id + 1 ), ',', - 1 ) AS split_zj 
  FROM tmp_1 B,
       mysql.help_topic A 
  WHERE A.help_topic_id<length(B.zj)-length(regexp_replace(B.zj,',',''))+1
