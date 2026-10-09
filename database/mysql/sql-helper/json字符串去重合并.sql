CREATE DEFINER=`root`@`%` FUNCTION `json_merge_distinct`(sourcedata text, type VARCHAR(10)) RETURNS text CHARSET utf8mb4
    READS SQL DATA
    DETERMINISTIC
BEGIN
  /*
  【功能：将'["1","2"],["1","2"]' 字符串去重】
  
  版本号     编辑时间       编辑人       修改描述
  
  ----------------------------------
  */
    DECLARE list_data text;
    DECLARE json_arr JSON DEFAULT null;
    DECLARE json_text text DEFAULT null;
    -- 格式化字符串
    SELECT REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(regexp_replace(sourcedata,', *',','), '\\]', '' ), '\\[', ''),'"','') INTO list_data;
    
    
    WITH RECURSIVE split AS (
        SELECT 1 AS pos, REGEXP_SUBSTR(list_data, '[^,]+', 1, 1) AS item
        UNION ALL
        SELECT pos + 1, REGEXP_SUBSTR(list_data, '[^,]+', 1, pos + 1)
        FROM split
        WHERE REGEXP_SUBSTR(list_data, '[^,]+', 1, pos + 1) IS NOT NULL
    )
    SELECT JSON_ARRAYAGG(item),
           GROUP_CONCAT(item)
           INTO json_arr ,json_text 
    from(
      select distinct item
      from split  
    )t; 
    
    IF type = 'text' THEN
        RETURN json_text;
    ELSE
        RETURN json_arr;
    END IF;
    
END
