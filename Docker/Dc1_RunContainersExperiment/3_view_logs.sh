#!/bin/bash

echo "=========================================="
echo "Container Logs Viewer"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to show logs
show_logs() {
    local container=$1
    local name=$2

    echo -e "${BLUE}----------------------------------------"
    echo "Logs voor: $name"
    echo "----------------------------------------${NC}"

    if docker ps -q -f name=$container > /dev/null 2>&1; then
        docker logs --tail 20 $container 2>&1
    else
        echo "Container $container draait niet"
    fi
    echo ""
}

# Show logs for all containers
echo -e "${YELLOW}Laatste 20 log regels van elke container:${NC}"
echo ""

show_logs "dc1-nginx" "NGINX Web Server"
show_logs "dc1-redis" "Redis Cache"
show_logs "dc1-postgres" "PostgreSQL Database"
show_logs "dc1-python" "Python Web Server"

# Demonstrate different log options
echo -e "${BLUE}=========================================="
echo "Geavanceerde Log Commands"
echo "==========================================${NC}"
echo ""

echo "1. Logs met timestamps:"
echo "   $ docker logs --timestamps dc1-nginx"
echo ""
docker logs --timestamps --tail 5 dc1-nginx 2>&1 | sed 's/^/   /'
echo ""

echo "2. Logs sinds specifieke tijd (laatste 5 minuten):"
echo "   $ docker logs --since 5m dc1-nginx"
echo ""
docker logs --since 5m --tail 5 dc1-nginx 2>&1 | sed 's/^/   /'
echo ""

echo "3. Real-time log streaming (Ctrl+C om te stoppen):"
echo "   $ docker logs -f dc1-nginx"
echo ""

echo "4. Logs met tijdsbereik:"
echo "   $ docker logs --since \"2024-01-01\" --until \"2024-12-31\" dc1-nginx"
echo ""

echo -e "${GREEN}✓ Log viewing demo compleet!${NC}"
echo ""
echo "Handige log commands:"
echo "  docker logs <container>           - Alle logs"
echo "  docker logs -f <container>        - Follow mode (real-time)"
echo "  docker logs --tail 50 <container> - Laatste 50 regels"
echo "  docker logs --since 1h <container> - Laatste uur"
echo "  docker logs --timestamps <container> - Met timestamps"
echo ""
echo "Try it yourself:"
echo "  docker logs -f dc1-nginx"
