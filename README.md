# data-engineering-notes

数据工程学习笔记知识库：把原先散落在多个仓库里的部署、架构、排障记录集中到这里。

本仓库是**公开**的。文中出现过的密码、密钥、令牌、连接串、内网 IP / 主机名等敏感值，已统一替换为 `<PASSWORD>`、`<SECRET_KEY>`、`<API_KEY>`、`<TOKEN>`、`<USER>`、`<HOST_IP>`、`<ORG>` 等占位符，使用时请自行填写。指向私有仓库的图片链接已改为「（图片待补）」。

## 目录

### 数据库

| 路径 | 说明 |
| --- | --- |
| [database/](database/) | 关系库、国产库与中间件总入口 |
| [database/domestic/重点.md](database/domestic/重点.md) | 集中式 / 国产 / 分布式学习大纲（原 `-` 仓库） |
| [database/mysql/](database/mysql/) | MySQL 部署、复制、备份、锁、SQL 片段 |
| [database/oracle/](database/oracle/) | Oracle Docker 部署与 SQL 片段 |
| [database/postgresql/](database/postgresql/) | PostgreSQL 架构、复制、迁移 |
| [database/tidb/](database/tidb/) | TiDB DBA 查询 |
| [database/dm/](database/dm/) | 达梦单机部署与表空间 |
| [database/domestic/](database/domestic/) | openGauss / OceanBase / GaussDB |
| [database/mycat/](database/mycat/) | MyCat 分库分表与读写分离 |

**MySQL**

- [部署/docker-deploy.md](database/mysql/部署/docker-deploy.md) — Docker 部署
- [部署/file-deploy.md](database/mysql/部署/file-deploy.md) — 安装包部署
- [部署/my.cnf](database/mysql/部署/my.cnf) — 配置示例
- [复制/配置异步复制.md](database/mysql/复制/配置异步复制.md) — 异步复制
- [复制/升级半同步复制.md](database/mysql/复制/升级半同步复制.md) — 半同步
- [复制/新增从节点.md](database/mysql/复制/新增从节点.md) — 加从库
- [复制/主从切换.md](database/mysql/复制/主从切换.md) — 切换
- [复制/主从断开处理.md](database/mysql/复制/主从断开处理.md) — 断连处理
- [复制/在线开启GTD.md](database/mysql/复制/在线开启GTD.md) — 在线开 GTID
- [复制/相关命令.md](database/mysql/复制/相关命令.md) — 常用命令
- [备份/mysqldump.md](database/mysql/备份/mysqldump.md) — mysqldump
- [备份/xtrabackup8.md](database/mysql/备份/xtrabackup8.md) — XtraBackup 8
- [备份/定时脚本/main-database.sh](database/mysql/备份/定时脚本/main-database.sh) — 定时备份脚本
- [架构/binlog查询.md](database/mysql/架构/binlog查询.md) — binlog
- [架构/事物与锁.md](database/mysql/架构/事物与锁.md) — 事务与锁
- [架构/锁查询.md](database/mysql/架构/锁查询.md) — 锁查询
- [常见问题/字符集问题.md](database/mysql/常见问题/字符集问题.md) — 字符集
- [常见问题/驱动版本问题.md](database/mysql/常见问题/驱动版本问题.md) — JDBC 驱动
- [其他/引号的区别.md](database/mysql/其他/引号的区别.md) — 引号
- [sql-helper/](database/mysql/sql-helper/) — 行转列、JSON、存储过程等片段

**Oracle**

- [部署/single-deploy-docker.md](database/oracle/部署/single-deploy-docker.md) — Docker 单机
- [sql-helper/](database/oracle/sql-helper/) — 分表、日期维、批量写入等
- [sql-helper/表占用容量查询.md](database/oracle/sql-helper/表占用容量查询.md) — 表空间占用

**PostgreSQL**

- [部署/single-deploy.md](database/postgresql/部署/single-deploy.md) — 源码/通用单机
- [部署/single-deploy-rpm.md](database/postgresql/部署/single-deploy-rpm.md) — RPM 单机
- [部署/extension-deploy.md](database/postgresql/部署/extension-deploy.md) — 扩展
- [部署/ora2pg-deploy.md](database/postgresql/部署/ora2pg-deploy.md) — ora2pg
- [复制/原理.md](database/postgresql/复制/原理.md) / [主从配置.md](database/postgresql/复制/主从配置.md) / [问题处理.md](database/postgresql/复制/问题处理.md)
- [架构/原理.md](database/postgresql/架构/原理.md) — 体系结构
- [架构/基本语法.md](database/postgresql/架构/基本语法.md) / [基本语法2.md](database/postgresql/架构/基本语法2.md)
- [架构/导入导出.md](database/postgresql/架构/导入导出.md) / [锁查询处理.md](database/postgresql/架构/锁查询处理.md) / [统计信息查询.md](database/postgresql/架构/统计信息查询.md) / [自带客户端工具.md](database/postgresql/架构/自带客户端工具.md)
- [迁移转换/oracle至postgresql.md](database/postgresql/迁移转换/oracle至postgresql.md) / [mysql至postgresql.md](database/postgresql/迁移转换/mysql至postgresql.md)
- [常见问题/navicate连接.md](database/postgresql/常见问题/navicate连接.md)

**TiDB / 达梦**

- [tidb/其他/dba查询.md](database/tidb/其他/dba查询.md) — DBA 查询
- [dm/部署/single-deploy.md](database/dm/部署/single-deploy.md) — 达梦单机
- [dm/其他/表空间管理.md](database/dm/其他/表空间管理.md) — 表空间

**openGauss**

- [部署/deploy-single.md](database/domestic/opengauss/部署/deploy-single.md) — 单机
- [部署/deploy-extension.md](database/domestic/opengauss/部署/deploy-extension.md) — 扩展
- [部署/deploy-ora2og.md](database/domestic/opengauss/部署/deploy-ora2og.md) — ora2og
- [部署/deploy-gs_rep_portal.md](database/domestic/opengauss/部署/deploy-gs_rep_portal.md) — 复制门户
- [主备复制/1.原理.md](database/domestic/opengauss/主备复制/1.原理.md) / [2.单主扩容备库.md](database/domestic/opengauss/主备复制/2.单主扩容备库.md) / [问题处理.md](database/domestic/opengauss/主备复制/问题处理.md)
- [知识结构/](database/domestic/opengauss/知识结构/) — 架构、语法、示例、参数
- [迁移转换/](database/domestic/opengauss/迁移转换/) — MySQL / Oracle 迁移与问题记录
- [问题处理/](database/domestic/opengauss/问题处理/) — 锁、系统表、杂项
- [日志查询.md](database/domestic/opengauss/日志查询.md) / [自带客户端工具.md](database/domestic/opengauss/自带客户端工具.md)

**OceanBase**

- [部署/deploy-single.md](database/domestic/oceanbase/部署/deploy-single.md) — 企业版单机
- [部署/deploy-single-ce.md](database/domestic/oceanbase/部署/deploy-single-ce.md) — 社区版
- [部署/deploy-single-oms-ce.md](database/domestic/oceanbase/部署/deploy-single-oms-ce.md) — OMS 社区版
- [部署/问题处理-企业版.md](database/domestic/oceanbase/部署/问题处理-企业版.md)
- [知识结构/](database/domestic/oceanbase/知识结构/) — 架构与 MySQL/Oracle 模式语法
- [管理/租户管理.md](database/domestic/oceanbase/管理/租户管理.md) / [系统信息查询.md](database/domestic/oceanbase/管理/系统信息查询.md)
- [迁移转换/mysql迁移至oceanbase.md](database/domestic/oceanbase/迁移转换/mysql迁移至oceanbase.md)
- [工具.md](database/domestic/oceanbase/工具.md)

**GaussDB**

- [知识结构/](database/domestic/gaussdb/知识结构/) — 集中式 / 分布式 / 数仓架构
- [基本语法/DWS数仓.md](database/domestic/gaussdb/基本语法/DWS数仓.md) / [权限管理.md](database/domestic/gaussdb/基本语法/权限管理.md)
- [问题处理/](database/domestic/gaussdb/问题处理/) — 表信息、锁

**MyCat**

- [架构/分库分表.md](database/mycat/架构/分库分表.md)
- [架构/读写分离.md](database/mycat/架构/读写分离.md)
- [部署/安装文档.md](database/mycat/部署/安装文档.md)

### 大数据

| 路径 | 说明 |
| --- | --- |
| [bigdata/CDH6.3.0部署/](bigdata/CDH6.3.0部署/) | CDH 6.3.0 安装与组件调优 |
| [bigdata/spark升级/](bigdata/spark升级/) | CDH 上部署 Spark 3 |
| [bigdata/kylin升级/](bigdata/kylin升级/) | Kylin 4 安装与元数据清理 |
| [bigdata/HDFS 磁盘均衡/](bigdata/HDFS%20磁盘均衡/) | HDFS diskbalancer 脚本 |
| [bigdata/HDFS小文件合并/](bigdata/HDFS小文件合并/) | Spark 合并小文件 |
| [bigdata/HDFS大文件拆分/](bigdata/HDFS大文件拆分/) | 拆分大文件 |
| [bigdata/elasticsearch/](bigdata/elasticsearch/) | DSL、Logstash、部署 |
| [bigdata/问题处理.md](bigdata/问题处理.md) | 排障备忘 |

- [CDH6.3.0部署/安装文档.md](bigdata/CDH6.3.0部署/安装文档.md) — 集群安装
- [CDH6.3.0部署/hdfs配置调整.md](bigdata/CDH6.3.0部署/hdfs配置调整.md) / [yarn配置调整.md](bigdata/CDH6.3.0部署/yarn配置调整.md) / [hive配置调整.md](bigdata/CDH6.3.0部署/hive配置调整.md) / [zookeeper调整配置.md](bigdata/CDH6.3.0部署/zookeeper调整配置.md)
- [spark升级/CDH6.3.0部署spark3.md](bigdata/spark升级/CDH6.3.0部署spark3.md)
- [kylin升级/kylin4安装文档.md](bigdata/kylin升级/kylin4安装文档.md) / [元数据清理.md](bigdata/kylin升级/元数据清理.md) / [问题记录.md](bigdata/kylin升级/问题记录.md)
- [elasticsearch/DSL查询.md](bigdata/elasticsearch/DSL查询.md)
- [elasticsearch/logstash/](bigdata/elasticsearch/logstash/) — MySQL/Oracle ↔ ES
- [elasticsearch/部署/](bigdata/elasticsearch/部署/) — 安装包 / 集群 / Docker

### ETL

| 路径 | 说明 |
| --- | --- |
| [etl/](etl/) | ETL 工具笔记 |
| [etl/kettle/](etl/kettle/) | Kettle 转换与笔记 |

- [kettle/base64转图片抽取.ktr](etl/kettle/base64转图片抽取.ktr) / [保存转换时无法保存.md](etl/kettle/保存转换时无法保存.md)

### 运维

| 路径 | 说明 |
| --- | --- |
| [ops/linux/](ops/linux/) | 磁盘挂载、VMware、多版本 Java、sudo |
| [ops/docker/](ops/docker/) | CentOS 7.9 安装 Docker |

- [ops/linux/磁盘挂载/mount_disk.sh](ops/linux/磁盘挂载/mount_disk.sh) — 单盘挂载（CDH 安装会用到）
- [ops/linux/磁盘挂载/mount_disk_series.sh](ops/linux/磁盘挂载/mount_disk_series.sh) — 批量挂载
- [ops/linux/vmware磁盘扩容.md](ops/linux/vmware磁盘扩容.md)
- [ops/linux/vmware修改网卡类型.md](ops/linux/vmware修改网卡类型.md)
- [ops/linux/多版本java控制/配置.md](ops/linux/多版本java控制/配置.md)
- [ops/linux/添加sudo用户.md](ops/linux/添加sudo用户.md)
- [ops/linux/centos启用图形化界面.md](ops/linux/centos启用图形化界面.md)
- [ops/docker/deploy-centos7.9.md](ops/docker/deploy-centos7.9.md)

### AI 部署

| 路径 | 说明 |
| --- | --- |
| [ai/dify/](ai/dify/) | Dify 本地部署：compose 与启动步骤 |
| [ai/ollama/](ai/ollama/) | Ollama 安装、Docker 运行、本地模型加载 |

- [ai/dify/部署说明.md](ai/dify/部署说明.md)
- [ai/dify/docker-compose.yaml](ai/dify/docker-compose.yaml) — 默认密钥已打码
- [ai/ollama/安装说明.md](ai/ollama/安装说明.md)
- [ai/ollama/docker安装.md](ai/ollama/docker安装.md)
- [ai/ollama/模型部署.md](ai/ollama/模型部署.md)

### 开发环境

| 路径 | 说明 |
| --- | --- |
| [dev/python/](dev/python/) | conda 环境配置与离线迁移 |

- [dev/python/环境配置.md](dev/python/环境配置.md)
- [dev/python/创建新环境-迁移.md](dev/python/创建新环境-迁移.md)

### UI 设计

| 路径 | 说明 |
| --- | --- |
| [design/](design/) | UI 设计笔记 |

### 链接

| 路径 | 说明 |
| --- | --- |
| [links.md](links.md) | 在线工具、DB-GPT 语雀文档 |

## 来源对照

只复制各源仓库**当前默认分支的文件**，不导入 git 历史。

| 本仓库路径 | 源仓库 |
| --- | --- |
| `database/mysql/` 等 | Miss001/database（私有，附件导入） |
| `database/domestic/` | Miss001/-（私有，附件中名为 domestic-db） |
| `database/mycat/` | Miss001/mycat（私有） |
| `bigdata/`（除 elasticsearch 官网链接） | Miss001/bigdata（私有） |
| `bigdata/elasticsearch/` 官网链接 | Miss001/elasticsearch（私有；DSL 与 bigdata 重复，已去重） |
| `etl/kettle/` | Miss001/kettle（私有） |
| `ops/linux/` | Miss001/linux（私有） |
| `ops/docker/` | [Miss001/docker](https://github.com/Miss001/docker)（公开） |
| `ai/dify/`、`ai/ollama/` | [Miss001/ai](https://github.com/Miss001/ai)（公开） |
| `dev/python/` | [Miss001/python](https://github.com/Miss001/python)（公开） |
| `links.md` 在线工具 | [Miss001/online-tool](https://github.com/Miss001/online-tool)（公开） |
| `links.md` DB-GPT | Miss001/db-gpt（私有，仅一条语雀链接） |
