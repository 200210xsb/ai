#!/bin/bash

# ARL Docker 健康检查脚本

echo "========================================="
echo "  ARL Docker 健康检查"
echo "  检查时间: $(date '+%Y-%m-%d %H:%M:%S')"
echo "========================================="

ERRORS=0

check_container() {
    local name=$1
    local expected_status=$2
    
    if docker ps --filter "name=${name}" --filter "status=${expected_status}" | grep -q "${name}"; then
        echo "[OK] ${name} 容器运行正常"
        return 0
    else
        if docker ps -a | grep -q "${name}"; then
            local current_status=$(docker ps -a --filter "name=${name}" --format "{{.Status}}" | head -1)
            echo "[ERROR] ${name} 容器状态异常: ${current_status}"
        else
            echo "[ERROR] ${name} 容器不存在"
        fi
        return 1
    fi
}

check_service() {
    local name=$1
    local port=$2
    
    if docker exec ${name} sh -c "nc -z localhost ${port}" 2>/dev/null; then
        echo "[OK] ${name} 服务端口 ${port} 正常"
        return 0
    else
        echo "[ERROR] ${name} 服务端口 ${port} 无响应"
        return 1
    fi
}

echo ""
echo "--- 容器状态检查 ---"
check_container "arl_web" "running" || ((ERRORS++))
check_container "arl_worker" "running" || ((ERRORS++))
check_container "arl_scheduler" "running" || ((ERRORS++))
check_container "arl_mongodb" "running" || ((ERRORS++))
check_container "arl_rabbitmq" "running" || ((ERRORS++))

echo ""
echo "--- 服务端口检查 ---"
check_service "arl_mongodb" "27017" || ((ERRORS++))
check_service "arl_rabbitmq" "5672" || ((ERRORS++))
check_service "arl_web" "5003" || ((ERRORS++))

echo ""
echo "--- Web服务检查 ---"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" https://127.0.0.1:5004/ 2>/dev/null)
if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "302" ]; then
    echo "[OK] ARL Web 服务正常 (HTTP ${HTTP_CODE})"
else
    echo "[ERROR] ARL Web 服务异常 (HTTP ${HTTP_CODE})"
    ((ERRORS++))
fi

echo ""
echo "--- RabbitMQ 管理界面检查 ---"
HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:15672/ 2>/dev/null)
if [ "$HTTP_CODE" = "200" ]; then
    echo "[OK] RabbitMQ 管理界面正常 (HTTP ${HTTP_CODE})"
else
    echo "[WARN] RabbitMQ 管理界面无法访问 (HTTP ${HTTP_CODE})"
fi

echo ""
echo "--- 磁盘空间检查 ---"
ROOT_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$ROOT_USAGE" -lt 80 ]; then
    echo "[OK] 磁盘空间使用率: ${ROOT_USAGE}%"
else
    echo "[WARN] 磁盘空间使用率较高: ${ROOT_USAGE}%"
fi

echo ""
echo "--- Docker 磁盘使用 ---"
docker system df 2>/dev/null | grep -E "(Images|Local Volumes|Build Cache)" | while read line; do
    echo "  $line"
done

echo ""
echo "========================================="
if [ $ERRORS -eq 0 ]; then
    echo "  健康检查通过！"
    exit 0
else
    echo "  发现 ${ERRORS} 个错误"
    exit 1
fi
