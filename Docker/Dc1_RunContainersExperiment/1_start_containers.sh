#!/bin/bash

echo "=========================================="
echo "Dc1 - Docker Container Management Demo"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}Dit script demonstreert het starten van meerdere containers${NC}"
echo ""

# 1. Start NGINX web server
echo -e "${GREEN}[1/4] Starten van NGINX container...${NC}"
docker run -d --name dc1-nginx -p 8081:80 nginx:alpine
echo "✓ NGINX draait op http://localhost:8081"
echo ""

# 2. Start Redis cache server
echo -e "${GREEN}[2/4] Starten van Redis container...${NC}"
docker run -d --name dc1-redis -p 6379:6379 redis:alpine
echo "✓ Redis draait op poort 6379"
echo ""

# 3. Start PostgreSQL database
echo -e "${GREEN}[3/4] Starten van PostgreSQL container...${NC}"
docker run -d --name dc1-postgres \
  -e POSTGRES_PASSWORD=devops123 \
  -e POSTGRES_USER=devopsuser \
  -e POSTGRES_DB=testdb \
  -p 5432:5432 \
  postgres:alpine
echo "✓ PostgreSQL draait op poort 5432"
echo "  - Database: testdb"
echo "  - User: devopsuser"
echo "  - Password: devops123"
echo ""

# 4. Start a simple Python web server with custom HTML
echo -e "${GREEN}[4/4] Starten van Python web server container...${NC}"
docker run -d --name dc1-python \
  -p 8082:8000 \
  -v "$(pwd)":/app \
  -w /app \
  python:3.9-alpine \
  sh -c "echo '<h1>Dc1 Container Experiment</h1><p>Deze pagina wordt geserveerd vanuit een Python container!</p>' > index.html && python3 -m http.server 8000"
echo "✓ Python web server draait op http://localhost:8082"
echo ""

# Wait for containers to fully start
echo -e "${YELLOW}Wachten 3 seconden voor containers volledig te starten...${NC}"
sleep 3
echo ""

# Show running containers
echo -e "${BLUE}=========================================="
echo "Draaiende Containers:"
echo "==========================================${NC}"
docker ps --filter "name=dc1-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

echo -e "${GREEN}✓ Alle containers zijn succesvol gestart!${NC}"
echo ""
echo "Volgende stappen:"
echo "  1. Test de containers met: bash 2_inspect_containers.sh"
echo "  2. Bekijk logs met: bash 3_view_logs.sh"
echo "  3. Stop containers met: bash 4_stop_containers.sh"
