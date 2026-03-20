#!/bin/bash

# ARL Docker 备份脚本
# 用于备份MongoDB数据库和配置文件

BACKUP_DIR="./backup"
DATE=$(date +%Y%m%d_%H%M%S)
DB_BACKUP_FILE="arl_db_${DATE}.gz"
CONFIG_BACKUP_FILE="arl_config_${DATE}.tar.gz"

mkdir -p ${BACKUP_DIR}

echo "========================================="
echo "  ARL Docker 备份脚本"
echo "  备份时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

echo "[1/4] 停止 ARL 服务..."
docker-compose stop worker scheduler

echo "[2/4] 备份 MongoDB 数据库..."
docker run --rm -v arl_db:/data/db -v ${BACKUP_DIR}:/backup mongo:4.0.27 tar czf /backup/${DB_BACKUP_FILE} -C /data db

echo "[3/4] 备份配置文件..."
tar czf ${BACKUP_DIR}/${CONFIG_BACKUP_FILE} config-docker.yaml docker-compose.yml nginx.conf

echo "[4/4] 重启 ARL 服务..."
docker-compose start worker scheduler

echo ""
echo "========================================="
echo "  备份完成！"
echo "========================================="
echo "数据库备份: ${BACKUP_DIR}/${DB_BACKUP_FILE}"
echo "配置备份:   ${BACKUP_DIR}/${CONFIG_BACKUP_FILE}"
echo ""

echo "清理超过30天的备份文件..."
find ${BACKUP_DIR} -name "arl_*.gz" -mtime +30 -delete
echo "清理完成"

echo ""
echo "当前备份文件列表:"
ls -lh ${BACKUP_DIR}/
