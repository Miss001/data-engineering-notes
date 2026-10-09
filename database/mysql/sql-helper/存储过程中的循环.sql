CREATE DEFINER=`root`@`%` PROCEDURE `p_template`()
BEGIN
  /*  
  版本号     编辑时间       编辑人       修改描述       修改描述

  ----------------------------------
  */
    -- 设置普通变量
    DECLARE v_task_id INT;
    DECLARE v_task_status VARCHAR(50) DEFAULT '成功';
    -- 设置异常变量
    DECLARE code CHAR(5) DEFAULT '00000';
    DECLARE msg TEXT;
    -- 设置游标变量
    DECLARE current_bh varchar(100);
    DECLARE current_lb varchar(100);
    DECLARE done INT DEFAULT FALSE;
    -- 游标定义---
    DECLARE cur CURSOR FOR select bh,lb from tablename;    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    -- 异常处理
    -- code = RETURNED_SQLSTATE, 
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION, SQLWARNING
    BEGIN
        GET DIAGNOSTICS CONDITION 1 msg = MESSAGE_TEXT;
        SET v_task_status='失败';
        SET code='400';
    END;
    
    set session group_concat_max_len=10240;
-- ------------------------------------------------------------处理业务逻辑------------------------------------------------------------------------
    -- 打开游标(编号)
    OPEN cur;
    outer_loop: LOOP
      FETCH cur INTO current_bh,current_lb;
      IF done THEN
          LEAVE outer_loop;
      END IF;
    -- ------------------------------------------------------编号循环--------------------------------------------------------------------------
      BEGIN
        DECLARE current_sql longtext;
        DECLARE done_sql INT DEFAULT FALSE;
        -- 需求分析sql配置表
        DECLARE cur_sql CURSOR FOR select sqlconfig from sql_config a where regexp_like(lb,current_lb) and xt_zxbz='0';
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET done_sql = TRUE;

        -- 打开游标(sql)
        OPEN cur_sql;
        inner_loop: LOOP
          FETCH cur_sql INTO current_sql;
          IF done_sql THEN
              LEAVE inner_loop;
          END IF;
          -- ------------------------------------------------------sql循环--------------------------------------------------------------------------
          SET v_task_status='成功';
          SET code='200';
          SET msg='';
          
          BEGIN 
             INSERT INTO logs(p_name, bh, lb, lrsj, xgsj) 
             VALUES('p_template', current_bh, current_lb, now(),now());
             -- 使用 SELECT INTO 将查询结果存入变量
             SELECT MAX(task_id) INTO v_task_id FROM logs WHERE p_name='p_template'AND bh=current_bh;
             -- -------------------------------------------------------------------------------------------------------------------------------
             SET @v_sql=REPLACE(REPLACE(current_sql,
                                        'current_bh',
                                        concat('''',current_bh ,'''')
                                        ),
                                'current_lb',
                                concat('''',current_lb ,'''')
                                );
             -- 调试打印
             UPDATE logs SET message=CONCAT('SQL:',IFNULL(@v_sql,'')) WHERE task_id=v_task_id;
             -- 执行SQL
             PREPARE stmt FROM @v_sql;
             EXECUTE stmt;
             DEALLOCATE PREPARE stmt;
             -- --------------------------------------------------------------------------------------------------------------------------------------  
             UPDATE logs SET xgsj=NOW(),`code`=code,`status`=v_task_status,message=concat(msg,message) WHERE task_id=v_task_id;
            -- UPDATE logs SET xt_zhxgsj=NOW(),`code`=code,`status`=v_task_status,message=msg WHERE task_id=v_task_id;
          END;
    -- --------------------------------------------------------------------------------------------------------------------------------------  
        -- 结束循环
        END LOOP;
        -- 关闭游标(sql)
        CLOSE cur_sql;
     END;
    -- --------------------------------------------------------------------------------------------------------------------------------------  
    -- 结束循环
    END LOOP;
    -- 关闭游标(编号)
    CLOSE cur;

END
