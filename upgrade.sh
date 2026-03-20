#!/bin/bash

# ARL Docker 一键升级脚本

echo "========================================="
echo "  ARL Docker 升级脚本"
echo "========================================="

CURRENT_VERSION=$(docker images 200210xsb/arl-docker-all --format "{{.Tag}}" | head -1)
echo "当前镜像版本: ${CURRENT_VERSION:-未知}"

echo ""
echo "正在获取最新镜像版本..."

docker pull 200210xsb/arl-docker-all:latest

LATEST_VERSION=$(docker images 200210xsb/arl-docker-all --format "{{.Tag}}" | head -1)
echo "最新镜像版本: ${LATEST_VERSION}"

if [ "${CURRENT_VERSION}" = "${LATEST_VERSION}" ]; then
    echo ""
    echo "当前已是最新版本，无需升级！"
    exit 0
fi

echo ""
read -p "检测到新版本，是否升级？[y/N]: " confirm
confirm=${confirm:-N}

if [[ ! "$confirm" =~ ^[yY]$ ]]; then
    echo "已取消升级"
    exit 0
fi

echo ""
echo "[1/4] 备份当前配置..."
if [ ! -d "./backup" ]; then
    mkdir -p ./backup
fi
tar czf ./backup/config_$(date +%Y%m%d_%H%M%S).tar.gz config-docker.yaml docker-compose.yml nginx.conf 2>/dev/null
echo "配置已备份到 ./backup/ 目录"

echo ""
echo "[2/4] 停止 ARL 服务..."
docker-compose stop worker scheduler web

echo ""
echo "[3/4] 更新镜像..."
docker-compose pull

echo ""
echo "[4/4] 重启 ARL 服务..."
docker-compose up -d

echo ""
echo "========================================="
echo "  升级完成！"
echo "========================================="
echo "请运行以下命令查看服务状态:"
echo "  docker-compose ps"
echo "  bash health_check.sh"
