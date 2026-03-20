# ARL(灯塔）-Docker魔改版本

本项目基于 [ARL-docker](https://github.com/honmashironeko/ARL-docker) 原版进行魔改。

## 魔改内容

### 安全增强
- 修改默认端口：`5003` -> `5004`
- 增强API认证：设置默认API_KEY
- 网络隔离：使用Docker自定义网络
- 开放192.168网段黑名单

### 性能优化
- Worker并发数：`2` -> `4`
- Web服务worker：`3` -> `4`
- MongoDB缓存：2GB
- RabbitMQ高可用配置

### 功能增强
- 一键备份脚本：`backup.sh`
- 一键升级脚本：`upgrade.sh`
- 健康检查脚本：`health_check.sh`
- 数据恢复脚本：`restore.sh`
- 日志轮转配置：`logrotate.conf`

### 资源限制
- 所有容器添加CPU/内存限制
- 日志文件大小限制

## 快速部署

### Linux 一键部署

```bash
git clone https://github.com/200210xsb/ai.git
cd ai/
chmod +x setup_docker.sh
bash setup_docker.sh
```

### macOS 部署

```bash
git clone https://github.com/200210xsb/ai.git
cd ai/
chmod +x setup_mac_docker.sh
bash setup_mac_docker.sh
```

## 访问信息

- 访问地址：`https://IP:5004/`
- 默认账号：`admin`
- 默认密码：`arl-test`
- API Key：`arl-docker-mod-by-ai-2026`

## 常用命令

```bash
# 启动
docker-compose up -d

# 停止
docker-compose down

# 查看日志
docker-compose logs -f

# 健康检查
bash health_check.sh

# 备份数据
bash backup.sh

# 升级版本
bash upgrade.sh

# 恢复数据
bash restore.sh ./backup/arl_db_20260320_120000.gz
```

## 配置说明

配置文件位于 `config-docker.yaml`，可根据需求修改：

- API密钥：`API_KEY` 字段
- FOFA/Hunter 等第三方API配置
- 代理设置：`PROXY` 字段
- 消息推送配置：DINGDING/EMAIL/WEBHOOK

## 资源限制

| 服务 | CPU限制 | 内存限制 |
|------|--------|---------|
| web | 2核 | 4GB |
| worker | 3核 | 8GB |
| scheduler | 1核 | 2GB |
| mongodb | 2核 | 4GB |
| rabbitmq | 1核 | 2GB |

## 致谢

- 感谢原项目：https://github.com/honmashironeko/ARL-docker
- 感谢ARL项目：https://github.com/TophantTechnology/ARL
- 感谢ARL备份：https://github.com/Aabyss-Team/ARL
