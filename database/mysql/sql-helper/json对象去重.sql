CREATE DEFINER=`root`@`%` FUNCTION `json_object_distinct`(json_data json) RETURNS json
    DETERMINISTIC
BEGIN
  /*
  【功能：将[{},{}] json数组去重】
  
  版本号     编辑时间       编辑人       修改描述
  1.0.0      2025-02-21     <USER>       创建函数
  
  ----------------------------------
  */
    DECLARE result JSON;
    
     -- 使用 JSON_TABLE 遍历 JSON 数组 去重
    SELECT JSON_ARRAYAGG(item) INTO result
    from(
      SELECT distinct item
      FROM JSON_TABLE(json_data, '$[*]'
          COLUMNS (item JSON PATH '$')
      ) AS jt
    )t;

    -- 返回最终的 JSON 对象
    RETURN result;
    
END
