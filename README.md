# data-engineering-notes

数据工程学习笔记知识库：把原先散落在多个仓库里的部署、架构、排障记录集中到这里。

本仓库是**公开**的。文中出现过的密码、密钥、令牌、连接串、内网 IP / 主机名等敏感值，已统一替换为 `<PASSWORD>`、`<SECRET_KEY>`、`<API_KEY>`、`<TOKEN>`、`<USER>`、`<HOST_IP>` 等占位符，使用时请自行填写。

## 目录

### 运维

| 路径 | 说明 |
| --- | --- |
| [ops/docker/](ops/docker/) | CentOS 7.9 安装 Docker（yum 源、指定版本、开机启动） |

- [ops/docker/deploy-centos7.9.md](ops/docker/deploy-centos7.9.md) — CentOS 7.9 安装 Docker

### AI 部署

| 路径 | 说明 |
| --- | --- |
| [ai/dify/](ai/dify/) | Dify 本地部署：compose 与启动步骤 |
| [ai/ollama/](ai/ollama/) | Ollama 安装、Docker 运行、本地模型加载 |

- [ai/dify/部署说明.md](ai/dify/部署说明.md) — 克隆官方仓库并 `docker compose up`
- [ai/dify/docker-compose.yaml](ai/dify/docker-compose.yaml) — 当时使用的 compose（默认密钥已打码）
- [ai/ollama/安装说明.md](ai/ollama/安装说明.md) — 离线安装脚本与 systemd 服务
- [ai/ollama/docker安装.md](ai/ollama/docker安装.md) — 容器方式运行 Ollama
- [ai/ollama/模型部署.md](ai/ollama/模型部署.md) — GGUF / Modelfile / API 测试

### 开发环境

| 路径 | 说明 |
| --- | --- |
| [dev/python/](dev/python/) | conda 环境配置与离线迁移 |

- [dev/python/环境配置.md](dev/python/环境配置.md) — conda 安装、离线装包
- [dev/python/创建新环境-迁移.md](dev/python/创建新环境-迁移.md) — conda-pack 打包与导入

### 链接

| 路径 | 说明 |
| --- | --- |
| [links.md](links.md) | 在线工具网址（流程图等） |

## 来源对照

只复制各源仓库**当前默认分支的文件**，不导入 git 历史。

| 本仓库路径 | 源仓库 |
| --- | --- |
| `ops/docker/` | [Miss001/docker](https://github.com/Miss001/docker)（公开） |
| `ai/dify/`、`ai/ollama/` | [Miss001/ai](https://github.com/Miss001/ai)（公开） |
| `dev/python/` | [Miss001/python](https://github.com/Miss001/python)（公开） |
| `links.md` | [Miss001/online-tool](https://github.com/Miss001/online-tool)（公开） |

## 尚未迁入（当前无读取权限）

下列源仓库是私有的，本环境的 GitHub 令牌只能访问本公开库，因此**没有复制其中任何文件**（也没有使用 git subtree / 历史合并）：

| 源仓库 | 计划路径 |
| --- | --- |
| `Miss001/database` | `database/mysql/`、`oracle/`、`postgresql/`、`tidb/`、`dm/` |
| `Miss001/-`（仓库名就是 `-`） | `database/opengauss/`、`oceanbase/`、`gaussdb/`，以及 `database/README.md`（原 `重点.md`） |
| `Miss001/mycat` | `database/mycat/` |
| `Miss001/bigdata` | `bigdata/`（CDH、Spark、Kylin、HDFS、Elasticsearch、问题处理） |
| `Miss001/elasticsearch` | 与 `bigdata/ElasticSearch/DSL查询.md` 重复的 DSL 笔记；官网链接拟并入 `bigdata/elasticsearch/` |
| `Miss001/kettle` | `bigdata/etl/kettle/` |
| `Miss001/linux` | `ops/linux/` |
| `Miss001/db-gpt` | 唯一链接拟写入 [links.md](links.md) |

获得这些仓库的读取权限后，再按同一规则（只复制当前文件、先打码再推送）补全。
