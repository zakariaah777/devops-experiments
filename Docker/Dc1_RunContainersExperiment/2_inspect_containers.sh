#!/bin/bash

echo "=========================================="
echo "Container Inspectie & Status Check"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Check if containers are running
echo -e "${BLUE}[1] Controleren of containers draaien...${NC}"
echo ""
docker ps --filter "name=dc1-" --format "table {{.Names}}\t{{.Status}}\t{{.Image}}\t{{.Ports}}"
echo ""

# Container statistics
echo -e "${BLUE}[2] Container resource gebruik (CPU, Geheugen, Netwerk)...${NC}"
echo ""
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" $(docker ps --filter "name=dc1-" -q)
echo ""

# Detailed inspection of NGINX
echo -e "${BLUE}[3] Gedetailleerde inspectie van NGINX container...${NC}"
echo ""
echo "IP Adres:"
docker inspect dc1-nginx --format='  {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
echo ""
echo "Status:"
docker inspect dc1-nginx --format='  State: {{.State.Status}}'
docker inspect dc1-nginx --format='  Running: {{.State.Running}}'
docker inspect dc1-nginx --format='  Started at: {{.State.StartedAt}}'
echo ""
echo "Poort mappings:"
docker inspect dc1-nginx --format='  {{range $p, $conf := .NetworkSettings.Ports}}{{$p}} -> {{(index $conf 0).HostPort}}{{end}}'
echo ""

# Test containers
echo -e "${BLUE}[4] Testen van container connectiviteit...${NC}"
echo ""

echo -e "${YELLOW}Test NGINX (HTTP request naar localhost:8081):${NC}"
curl -s -o /dev/null -w "  HTTP Status: %{http_code}\n" http://localhost:8081 2>/dev/null || echo "  ✗ NGINX niet bereikbaar"
echo ""

echo -e "${YELLOW}Test Python web server (HTTP request naar localhost:8082):${NC}"
curl -s -o /dev/null -w "  HTTP Status: %{http_code}\n" http://localhost:8082 2>/dev/null || echo "  ✗ Python server niet bereikbaar"
echo ""

echo -e "${YELLOW}Test Redis (PING command):${NC}"
docker exec dc1-redis redis-cli ping 2>/dev/null | sed 's/^/  /' || echo "  ✗ Redis niet bereikbaar"
echo ""

echo -e "${YELLOW}Test PostgreSQL (database connectie):${NC}"
docker exec dc1-postgres pg_isready -U devopsuser 2>/dev/null | sed 's/^/  /' || echo "  ✗ PostgreSQL niet bereikbaar"
echo ""

# Container processes
echo -e "${BLUE}[5] Processen in containers...${NC}"
echo ""
echo "NGINX processes:"
docker exec dc1-nginx ps aux | head -5 | sed 's/^/  /'
echo ""

# Network information
echo -e "${BLUE}[6] Container netwerk informatie...${NC}"
echo ""
docker network inspect bridge --format='{{range .Containers}}Name: {{.Name}} | IP: {{.IPv4Address}}
{{end}}' | grep dc1 | sed 's/^/  /'
echo ""

echo -e "${GREEN}✓ Inspectie compleet!${NC}"
echo ""
echo "Handige commands:"
echo "  docker logs <container>    - Bekijk container logs"
echo "  docker exec -it <container> /bin/sh  - Ga in container"
echo "  docker stats              - Live resource monitoring"
echo "  docker inspect <container> - Volledige container info"
