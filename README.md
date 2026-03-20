# ARL(灯塔) - Docker魔改版

> 个人自用魔改版本，基于 [ARL-docker](https://github.com/honmashironeko/ARL-docker) 原版

## 特性

- **配置管理中心**：前端可视化修改 FOFA/Hunter/Quake 等配置
- **自动同步**：修改配置后自动更新并重启 ARL 服务
- **保持原版**：原版一键部署脚本完全保留

## 快速部署

### 魔改版（推荐）

```bash
git clone https://github.com/200210xsb/ai.git
cd ai/
chmod +x deploy_mod.sh
bash deploy_mod.sh
```

### 原版部署

```bash
git clone https://github.com/200210xsb/ai.git
cd ai/
chmod +x setup_docker.sh
bash setup_docker.sh
```

## 访问地址

| 服务 | 地址 |
|------|------|
| ARL Web | `https://IP:5003/` |
| 配置中心 | `http://IP:5005/` |
| RabbitMQ | `http://IP:15672/` |

默认账号：`admin` / `honmashironeko`

## 配置管理中心

访问 `http://IP:5005/`，支持修改以下配置：

| 配置项 | 说明 |
|--------|------|
| API_KEY | ARL后端API密钥 |
| FOFA | FOFA邮箱和Key |
| Hunter | Hunter API Key |
| Quake | 360 Quake Token |
| ZoomEye | ZoomEye API Key |
| GitHub | GitHub Token |
| 代理 | HTTP代理URL |
| 钉钉 | 钉钉机器人配置 |
| 邮件 | SMTP邮件推送 |
| 安全 | IP/域名黑名单 |

使用方式：
1. 访问 `http://IP:5005/`
2. 修改配置后点击保存
3. 系统自动更新配置并重启 ARL 服务

## 常用命令

```bash
# 启动
docker-compose up -d

# 停止
docker-compose down

# 查看状态
docker-compose ps

# 查看日志
docker-compose logs -f
```

## 原版源码安装

```bash
chmod +x setup-arl.sh
bash setup-arl.sh
```

## macOS 部署

```bash
chmod +x setup_mac_docker.sh
bash setup_mac_docker.sh
```

## 致谢

- 感谢原项目：[honmashironeko/ARL-docker](https://github.com/honmashironeko/ARL-docker)
- 感谢ARL项目：[TophantTechnology/ARL](https://github.com/TophantTechnology/ARL)
- 感谢ARL备份：[Aabyss-Team/ARL](https://github.com/Aabyss-Team/ARL)
- 感谢指纹提供：[blog.zgsec.cn](https://blog.zgsec.cn/)
- 感谢指纹脚本：[loecho-sec/ARL-Finger-ADD](https://github.com/loecho-sec/ARL-Finger-ADD)
