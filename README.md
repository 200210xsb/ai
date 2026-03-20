# ARL(灯塔）-Docker魔改版本

本项目基于 [ARL-docker](https://github.com/honmashironeko/ARL-docker) 原版进行魔改。

## 魔改内容

1. 优化了默认配置参数
2. 更新了指纹库版本
3. 增强了安全配置
4. 改进了部署脚本

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

- 访问地址：`https://IP:5003/`
- 默认账号：`admin`
- 默认密码：`arl-test`

## 配置说明

配置文件位于 `config-docker.yaml`，可根据需求修改：

- API 密钥配置
- FOFA/Hunter 等第三方API配置
- 代理设置
- 消息推送配置

## 常用命令

```bash
# 启动
docker-compose up -d

# 停止
docker-compose down

# 查看日志
docker-compose logs -f
```

## 致谢

- 感谢原项目：https://github.com/honmashironeko/ARL-docker
- 感谢ARL项目：https://github.com/TophantTechnology/ARL
- 感谢ARL备份：https://github.com/Aabyss-Team/ARL
