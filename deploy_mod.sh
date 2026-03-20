#!/bin/bash

# ARL 魔改版一键部署脚本（带配置中心）

echo "========================================="
echo "  ARL 魔改版一键部署"
echo "========================================="

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# 检查 Docker
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker 未安装"
        exit 1
    fi
    if ! docker ps &> /dev/null; then
        log_error "Docker 服务未启动"
        exit 1
    fi
}

# 检查 docker-compose
check_docker_compose() {
    if ! command -v docker-compose &> /dev/null; then
        log_error "docker-compose 未安装"
        exit 1
    fi
}

# 主流程
main() {
    check_docker
    check_docker_compose
    
    log_info "构建配置管理中心..."
    docker build -t arl-config-center:latest ./config-center/
    
    log_info "创建数据卷..."
    if ! docker volume inspect arl_db &> /dev/null; then
        docker volume create --name=arl_db
    fi
    
    log_info "启动所有服务..."
    docker-compose up -d
    
    log_info "等待服务启动..."
    sleep 10
    
    echo ""
    echo "========================================="
    echo -e "  ${GREEN}部署完成！${NC}"
    echo "========================================="
    echo ""
    echo -e "${GREEN}访问地址:${NC}"
    echo "  ARL Web:      https://IP:5003/"
    echo "  配置中心:     http://IP:5005/"
    echo "  RabbitMQ:     http://IP:15672/"
    echo ""
    echo -e "${GREEN}默认账号:${NC}"
    echo "  用户名: admin"
    echo "  密码:   honmashironeko"
    echo ""
}

main
