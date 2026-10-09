CREATE DEFINER=`root`@`%` FUNCTION `convert_chinese_number`(input VARCHAR(20)) RETURNS int
    DETERMINISTIC
BEGIN
  /*
  【功能：判断传入值是阿拉伯数字还是中文数字，阿拉伯数字直接返回，否则将中文数字转为阿拉伯数字返回】
  
  版本号     编辑时间       编辑人       修改描述
  
  ----------------------------------
  */
    DECLARE result int default 0; -- 最终转换结果
    DECLARE current_char varchar(1);  -- 当前字符值
    DECLARE temp int default 0;  -- 临时映射
    DECLARE unit int;  -- 单位值
    DECLARE flag boolean;     
    DECLARE i int default 1;  -- 输入字符长度
    DECLARE len int default 0;
    
    DECLARE num_map varchar(20) DEFAULT '零一二三四五六七八九';
    DECLARE unit_map varchar(20) DEFAULT '十百千万亿';
    
    -- 本身为数字直接返回
    IF regexp_like(input,'[0-9]')=TRUE THEN
       RETURN input;
     END IF;
    
    SET len=CHAR_LENGTH(input);
    WHILE i<=len DO
      SET current_char=substr(input,i,1);
      
      IF LOCATE(current_char,num_map)>0 THEN
         SET temp=LOCATE(current_char,num_map) - 1;
         
      ELSEIF LOCATE(current_char,unit_map)>0 THEN
        CASE current_char
          WHEN '十' THEN set unit =10;
          WHEN '百' THEN set unit =100;
          WHEN '千' THEN set unit =1000;
          WHEN '万' THEN set unit =10000;
          WHEN '亿' THEN set unit =100000000;
          ELSE SET unit=1;
        END CASE;
        
        SET result=result + temp * unit;
        SET temp=0;
      END IF;
      
      SET i = i + 1;
    END WHILE;
    
    SET result=temp;
    
    RETURN result;
END
