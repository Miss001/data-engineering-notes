CREATE DEFINER=`root`@`%` FUNCTION `json_reverse_match`(json_text text) RETURNS text CHARSET utf8mb4
    DETERMINISTIC
BEGIN
  /*
  【功能：将["1","2","3"] 数组返回最后一位】
  
  版本号     编辑时间       编辑人       修改描述  
  ----------------------------------
  */
    DECLARE json_array JSON;
    DECLARE result_value text;

    IF LEFT(json_text, 2) = '["' AND RIGHT(json_text, 2) = '"]' THEN 
       SET json_array=json_text;
    ELSEIF LEFT(json_text, 1) <> '[' AND RIGHT(json_text, 1) <> ']' AND INSTR(json_text,'"')>0 THEN 
       SET json_array=CONCAT('[',json_text,']');
    ELSE
       SET json_array=CONCAT('["',json_text,'"]');
    END IF;
    
    -- 使用 JSON_TABLE 将 JSON 数组转换为表格，并从后往前查找第一个匹配的值
    SELECT jt.value 
       INTO result_value
    FROM JSON_TABLE(
        json_array,
        '$[*]' COLUMNS (
            idx FOR ORDINALITY, -- 添加索引
            value text PATH '$'
        )
    ) AS jt
    WHERE ORDER BY jt.idx DESC
    LIMIT 1;
    
    RETURN result_value;
END
