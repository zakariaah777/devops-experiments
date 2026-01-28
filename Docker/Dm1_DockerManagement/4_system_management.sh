#!/bin/bash

echo "=========================================="
echo "Docker System Management & Monitoring"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Dit script demonstreert Docker system monitoring en cleanup${NC}"
echo ""

# 1. Docker system info
echo -e "${GREEN}[1] Docker system informatie:${NC}"
echo ""
docker info --format='Server Version: {{.ServerVersion}}
Storage Driver: {{.Driver}}
Total Memory: {{.MemTotal}}
CPUs: {{.NCPU}}
Operating System: {{.OperatingSystem}}
Architecture: {{.Architecture}}
Kernel Version: {{.KernelVersion}}

Containers:
  Running: {{.ContainersRunning}}
  Paused: {{.ContainersPaused}}
  Stopped: {{.ContainersStopped}}
  Total: {{.Containers}}

Images: {{.Images}}
'
echo ""

# 2. Docker version
echo -e "${GREEN}[2] Docker versie informatie:${NC}"
echo ""
docker version --format='Client:
  Version: {{.Client.Version}}
  API version: {{.Client.APIVersion}}
  Go version: {{.Client.GoVersion}}

Server:
  Version: {{.Server.Version}}
  API version: {{.Server.APIVersion}}
  Go version: {{.Server.GoVersion}}
'
echo ""

# 3. Disk usage overview
echo -e "${GREEN}[3] Docker disk usage (system df):${NC}"
echo ""
docker system df
echo ""

echo -e "${YELLOW}Gedetailleerde disk usage:${NC}"
echo ""
docker system df -v | head -20
echo ""
echo "  (Uitvoer ingekort, gebruik 'docker system df -v' voor complete lijst)"
echo ""

# 4. Container statistics
echo -e "${GREEN}[4] Container resource usage (top 10):${NC}"
echo ""
if [ $(docker ps -q | wc -l) -gt 0 ]; then
    docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}" | head -11
else
    echo "  Geen draaiende containers"
fi
echo ""

# 5. List all resources
echo -e "${GREEN}[5] Overzicht van alle Docker resources:${NC}"
echo ""

echo "Containers (all):"
docker ps -a --format "  {{.Names}} ({{.Status}})" | head -10
if [ $(docker ps -a -q | wc -l) -gt 10 ]; then
    echo "  ... en $(($(docker ps -a -q | wc -l) - 10)) meer"
fi
echo ""

echo "Images:"
docker images --format "  {{.Repository}}:{{.Tag}} ({{.Size}})" | head -10
if [ $(docker images -q | wc -l) -gt 10 ]; then
    echo "  ... en $(($(docker images -q | wc -l) - 10)) meer"
fi
echo ""

echo "Volumes:"
docker volume ls --format "  {{.Name}}" | head -10
if [ $(docker volume ls -q | wc -l) -gt 10 ]; then
    echo "  ... en $(($(docker volume ls -q | wc -l) - 10)) meer"
fi
echo ""

echo "Networks:"
docker network ls --format "  {{.Name}} ({{.Driver}})" | head -10
echo ""

# 6. Check for unused resources
echo -e "${GREEN}[6] Unused resources detectie:${NC}"
echo ""

echo -e "${YELLOW}Dangling images (images zonder tag):${NC}"
dangling_count=$(docker images -f "dangling=true" -q | wc -l)
if [ $dangling_count -gt 0 ]; then
    echo "  ⚠ Gevonden: $dangling_count dangling image(s)"
    docker images -f "dangling=true" --format "    • {{.ID}} ({{.CreatedSince}})" | head -5
else
    echo "  ✓ Geen dangling images"
fi
echo ""

echo -e "${YELLOW}Stopped containers:${NC}"
stopped_count=$(docker ps -a -f "status=exited" -q | wc -l)
if [ $stopped_count -gt 0 ]; then
    echo "  ⚠ Gevonden: $stopped_count stopped container(s)"
    docker ps -a -f "status=exited" --format "    • {{.Names}} (stopped {{.Status}})" | head -5
else
    echo "  ✓ Geen stopped containers"
fi
echo ""

echo -e "${YELLOW}Unused volumes:${NC}"
unused_volumes=$(docker volume ls -f "dangling=true" -q | wc -l)
if [ $unused_volumes -gt 0 ]; then
    echo "  ⚠ Gevonden: $unused_volumes unused volume(s)"
    docker volume ls -f "dangling=true" --format "    • {{.Name}}" | head -5
else
    echo "  ✓ Geen unused volumes"
fi
echo ""

echo -e "${YELLOW}Unused networks:${NC}"
# Networks zonder containers (behalve default networks)
unused_nets=$(docker network ls --format "{{.Name}}" | while read net; do
    if [[ "$net" != "bridge" && "$net" != "host" && "$net" != "none" ]]; then
        containers=$(docker network inspect "$net" --format='{{len .Containers}}' 2>/dev/null)
        if [ "$containers" = "0" ]; then
            echo "$net"
        fi
    fi
done | wc -l)
if [ $unused_nets -gt 0 ]; then
    echo "  ⚠ Gevonden: $unused_nets unused network(s)"
else
    echo "  ✓ Geen unused networks (behalve dm1 test networks)"
fi
echo ""

# 7. Docker events (brief demo)
echo -e "${GREEN}[7] Docker events monitoring:${NC}"
echo ""
echo -e "${YELLOW}Demonstratie: Laatste 10 Docker events${NC}"
echo ""
docker events --since 5m --until 1s | tail -10 | sed 's/^/  /' || echo "  (Geen recente events)"
echo ""
echo "Live events monitoren met:"
echo "  $ docker events"
echo "  $ docker events --since 1h"
echo "  $ docker events --filter type=container"
echo ""

# 8. Cleanup demonstration (DRY RUN)
echo -e "${GREEN}[8] Cleanup opties (niet uitgevoerd):${NC}"
echo ""

echo -e "${YELLOW}Wat zou 'docker system prune' verwijderen?${NC}"
echo ""
docker system prune --dry-run 2>&1 | sed 's/^/  /'
echo ""

# 9. Build cache information
echo -e "${GREEN}[9] Builder cache informatie:${NC}"
echo ""
docker builder du 2>/dev/null || echo "  Builder cache info niet beschikbaar"
echo ""

# 10. Resource limits and warnings
echo -e "${GREEN}[10] System resource waarschuwingen:${NC}"
echo ""

# Check disk space
total_docker_size=$(docker system df --format='{{.Size}}' | head -1)
echo "Docker disk usage: $total_docker_size"
echo ""

# Count resources
container_count=$(docker ps -a -q | wc -l)
image_count=$(docker images -q | wc -l)
volume_count=$(docker volume ls -q | wc -l)

echo "Resource telling:"
echo "  • Containers: $container_count"
echo "  • Images: $image_count"
echo "  • Volumes: $volume_count"
echo ""

if [ $image_count -gt 50 ]; then
    echo -e "${RED}⚠ WARNING: Veel images ($image_count). Overweeg cleanup.${NC}"
fi
if [ $container_count -gt 30 ]; then
    echo -e "${RED}⚠ WARNING: Veel containers ($container_count). Overweeg cleanup.${NC}"
fi
echo ""

# Summary
echo -e "${BLUE}=========================================="
echo "System Management Samenvatting"
echo "==========================================${NC}"
echo ""
echo "Cleanup Levels:"
echo ""
echo "1. MILD - Alleen safe cleanup:"
echo "   $ docker container prune    # Stopped containers"
echo "   $ docker image prune        # Dangling images"
echo ""
echo "2. MEDIUM - Meer aggressive:"
echo "   $ docker system prune       # Containers + dangling images + networks"
echo "   $ docker image prune -a     # Alle unused images"
echo ""
echo "3. AGGRESSIVE - Verwijder alles unused:"
echo "   $ docker system prune -a    # Alles behalve volumes"
echo ""
echo "4. VERY AGGRESSIVE - INCLUSIEF VOLUMES:"
echo "   $ docker system prune -a --volumes"
echo -e "   ${RED}⚠ PAS OP: Verwijdert ook data volumes!${NC}"
echo ""

echo -e "${BLUE}Monitoring Commands:${NC}"
echo ""
echo "System info:"
echo "  docker info                    - Systeeminformatie"
echo "  docker version                 - Docker versie"
echo "  docker system df               - Disk usage"
echo "  docker system df -v            - Verbose disk usage"
echo ""
echo "Resources:"
echo "  docker ps -a                   - Alle containers"
echo "  docker images -a               - Alle images"
echo "  docker volume ls               - Alle volumes"
echo "  docker network ls              - Alle networks"
echo ""
echo "Monitoring:"
echo "  docker stats                   - Live resource monitoring"
echo "  docker events                  - Live event stream"
echo "  docker system events --since 1h - Events laatste uur"
echo ""
echo "Cleanup (veilig):"
echo "  docker container prune         - Verwijder stopped containers"
echo "  docker image prune             - Verwijder dangling images"
echo "  docker volume prune            - Verwijder unused volumes"
echo "  docker network prune           - Verwijder unused networks"
echo ""

echo -e "${GREEN}✓ System management demo compleet!${NC}"
echo ""
echo "TIP: Run regelmatig 'docker system df' om disk usage te monitoren"
echo "TIP: Gebruik 'docker system prune' om veilig op te ruimen"
echo ""
