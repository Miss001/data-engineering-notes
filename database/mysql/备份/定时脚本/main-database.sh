#!/bin/bash

# 指定数据库备份定时脚本

# 定义变量
BACKUP_DIR="/path/to/backup"        # 备份文件存储路径
MYSQL_HOST="your_mysql_host"        # MySQL HOST
MYSQL_PORT="your_mysql_port"        # MySQL 端口
MYSQL_USER="your_mysql_user"        # MySQL 用户名
MYSQL_PASSWORD="<PASSWORD>" # MySQL 密码
DATABASE_NAME=("database1" "database2")  # 要备份的数据库名称
DATE=$(date +"%Y%m%d")              # 当前日期
RETENTION_DAYS=60                   # 保留备份的天数

# 创建备份目录（如果不存在）
mkdir -p $BACKUP_DIR
for DB in "${DATABASE_NAME[@]}"; do
    # 备份文件名称
    BACKUP_FILE="$BACKUP_DIR/${DB}_${DATE}.sql"
    TAR_FILE="$BACKUP_DIR/${DB}_${DATE}.tar.gz"
    
    # 备份数据库并压缩
    echo "开始备份数据库：$DB"
    mysqldump -h$MYSQL_HOST -P$MYSQL_PORT -u$MYSQL_USER -p$MYSQL_PASSWORD --databases $DB --flush-logs --single-transaction --master-data=2  > $BACKUP_FILE
    if [ $? -eq 0 ]; then
        echo "数据库 $DB 备份成功：$BACKUP_FILE"
    else
        echo "数据库 $DB 备份失败"
        exit 1
    fi
    
    # 压缩备份文件
    tar -czf $TAR_FILE $BACKUP_FILE
    if [ $? -eq 0 ]; then
        echo "备份文件压缩成功：$TAR_FILE"
        # 删除未压缩的备份文件
        rm -f $BACKUP_FILE
    else
        echo "备份文件压缩失败"
        exit 1
    fi
done

# 删除过期备份
echo "清理超过 $RETENTION_DAYS 天的备份文件"
find $BACKUP_DIR -type f -mtime +$RETENTION_DAYS -name "*.tar.gz" -exec rm -f {} \;

echo "定时备份任务完成"
