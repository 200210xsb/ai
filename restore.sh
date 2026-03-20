#!/bin/bash

# ARL Docker 数据恢复脚本

if [ -z "$1" ]; then
    echo "用法: $0 <备份文件路径>"
    echo ""
    echo "示例:"
    echo "  $0 ./backup/arl_db_20260320_120000.gz"
    echo ""
    exit 1
fi

BACKUP_FILE=$1

if [ ! -f "$BACKUP_FILE" ]; then
    echo "错误: 备份文件不存在: $BACKUP_FILE"
    exit 1
fi

echo "========================================="
echo "  ARL Docker 数据恢复脚本"
echo "========================================="
echo "备份文件: $BACKUP_FILE"
echo ""

read -p "警告: 此操作将覆盖当前数据，是否继续？[y/N]: " confirm
confirm=${confirm:-N}

if [[ ! "$confirm" =~ ^[yY]$ ]]; then
    echo "已取消恢复"
    exit 0
fi

echo ""
echo "[1/5] 停止 ARL 服务..."
docker-compose stop worker scheduler web

echo "[2/5] 备份当前数据库..."
docker run --rm -v arl_db:/data/db -v $(dirname $BACKUP_FILE):/backup mongo:4.0.27 \
    tar czf /backup/arl_db_pre_restore_$(date +%Y%m%d_%H%M%S).gz -C /data db

echo "[3/5] 清空当前数据库..."
docker volume rm arl_db 2>/dev/null || true
docker volume create --name=arl_db

echo "[4/5] 恢复数据库..."
docker run --rm -v arl_db:/data/db -v $(dirname $BACKUP_FILE):/backup mongo:4.0.27 \
    tar xzf $BACKUP_FILE -C /data

echo "[5/5] 重启 ARL 服务..."
docker-compose up -d

echo ""
echo "========================================="
echo "  恢复完成！"
echo "========================================="
echo "请运行以下命令查看服务状态:"
echo "  docker-compose ps"
echo "  bash health_check.sh"
