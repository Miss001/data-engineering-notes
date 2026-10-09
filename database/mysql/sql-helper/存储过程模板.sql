CREATE DEFINER=`root`@`%` PROCEDURE `p_template`()
BEGIN
  /*
  【模板】 
  版本号     
  编辑时间       
  编辑人       

----------------------------------
  */
	#设置异常变量
	DECLARE code CHAR(5) DEFAULT '00000';
	DECLARE msg TEXT;
	
	#设置普通变量
	DECLARE V_ID   VARCHAR(50);
	DECLARE V_err  varchar(50);
	DECLARE result_value int;
	DECLARE tjrq varchar(8);

	SET V_ID = REPLACE(UUID(),'-','');

	# 异常处理
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
	  GET DIAGNOSTICS CONDITION 1
		code =RETURNED_SQLSTATE,msg=MESSAGE_TEXT;
                ROLLBACK;
                UPDATE loggs SET end_time = NOW(), bz = msg WHERE id = V_ID;
	END;

	INSERT INTO loggs(id,task_name,task_desc,begin_time,end_time)
	VALUES (V_ID,'p_template', '模板', now(), NULL);
	commit;
	 
-- ------------------------------------需求------------------------------------------------------------
-- ------------------------------------逻辑------------------------------------------------------------
SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
START TRANSACTION;
-- --------------------------


-- ------------------------------------------------------------------------------------------------
# 正常结束
UPDATE loggs SET end_time = NOW(), bz = '完成' WHERE id = V_ID;

END
