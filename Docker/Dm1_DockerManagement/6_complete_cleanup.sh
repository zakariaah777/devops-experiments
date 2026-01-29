#!/bin/bash

echo "=========================================="
echo "Complete Dm1 Cleanup"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Dit script ruimt ALLE Dm1 experiment resources op${NC}"
echo ""

# 1. Show what will be removed
echo -e "${GREEN}[1] Resources die verwijderd worden:${NC}"
echo ""

echo -e "${YELLOW}Dm1 Containers:${NC}"
dm1_containers=$(docker ps -a --filter "name=dm1-" --format "{{.Names}}")
if [ -n "$dm1_containers" ]; then
    echo "$dm1_containers" | sed 's/^/  • /'
    container_count=$(echo "$dm1_containers" | wc -l)
else
    echo "  (Geen dm1 containers gevonden)"
    container_count=0
fi
echo ""

echo -e "${YELLOW}Dm1 Networks:${NC}"
dm1_networks=$(docker network ls --filter "name=dm1-" --format "{{.Name}}")
if [ -n "$dm1_networks" ]; then
    echo "$dm1_networks" | sed 's/^/  • /'
    network_count=$(echo "$dm1_networks" | wc -l)
else
    echo "  (Geen dm1 networks gevonden)"
    network_count=0
fi
echo ""

echo -e "${YELLOW}Dm1 Volumes:${NC}"
dm1_volumes=$(docker volume ls --filter "name=dm1-" --format "{{.Name}}")
if [ -n "$dm1_volumes" ]; then
    echo "$dm1_volumes" | sed 's/^/  • /'
    volume_count=$(echo "$dm1_volumes" | wc -l)
else
    echo "  (Geen dm1 volumes gevonden)"
    volume_count=0
fi
echo ""

echo -e "${YELLOW}Test Images (alpine, nginx, postgres):${NC}"
test_images=$(docker images --filter "reference=alpine" --filter "reference=nginx:alpine" --filter "reference=postgres:alpine" --format "{{.Repository}}:{{.Tag}}")
if [ -n "$test_images" ]; then
    echo "$test_images" | sed 's/^/  • /'
fi
echo ""

echo -e "${YELLOW}Tagged Images (my-alpine):${NC}"
tagged_images=$(docker images --filter "reference=my-alpine" --format "{{.Repository}}:{{.Tag}}")
if [ -n "$tagged_images" ]; then
    echo "$tagged_images" | sed 's/^/  • /'
fi
echo ""

# 2. Confirmation
echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${RED}WAARSCHUWING: Dit verwijdert:${NC}"
echo -e "${RED}  • $container_count containers${NC}"
echo -e "${RED}  • $network_count networks${NC}"
echo -e "${RED}  • $volume_count volumes (inclusief data!)${NC}"
echo -e "${RED}  • Diverse test images${NC}"
echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

read -p "Wil je doorgaan met cleanup? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${YELLOW}Cleanup geannuleerd.${NC}"
    echo ""
    exit 0
fi

echo ""
echo -e "${GREEN}Starting cleanup...${NC}"
echo ""

# 3. Stop and remove containers
echo -e "${GREEN}[2] Stoppen en verwijderen van containers...${NC}"
echo ""

if [ -n "$dm1_containers" ]; then
    echo -e "${YELLOW}Stoppen van containers...${NC}"
    echo "$dm1_containers" | while read container; do
        docker stop "$container" > /dev/null 2>&1
        echo "  ✓ Stopped: $container"
    done
    echo ""

    echo -e "${YELLOW}Verwijderen van containers...${NC}"
    echo "$dm1_containers" | while read container; do
        docker rm "$container" > /dev/null 2>&1
        echo "  ✓ Removed: $container"
    done
    echo ""
else
    echo "  (Geen containers om te verwijderen)"
    echo ""
fi

# 4. Remove networks
echo -e "${GREEN}[3] Verwijderen van networks...${NC}"
echo ""

if [ -n "$dm1_networks" ]; then
    echo "$dm1_networks" | while read network; do
        docker network rm "$network" > /dev/null 2>&1
        echo "  ✓ Removed: $network"
    done
    echo ""
else
    echo "  (Geen networks om te verwijderen)"
    echo ""
fi

# 5. Remove volumes
echo -e "${GREEN}[4] Verwijderen van volumes...${NC}"
echo ""

if [ -n "$dm1_volumes" ]; then
    echo "$dm1_volumes" | while read volume; do
        docker volume rm "$volume" > /dev/null 2>&1
        echo "  ✓ Removed: $volume"
    done
    echo ""
else
    echo "  (Geen volumes om te verwijderen)"
    echo ""
fi

# 6. Remove test images
echo -e "${GREEN}[5] Verwijderen van test images...${NC}"
echo ""

# Remove tagged images first (my-alpine)
if [ -n "$tagged_images" ]; then
    echo -e "${YELLOW}Verwijderen van tagged images...${NC}"
    echo "$tagged_images" | while read image; do
        docker rmi "$image" > /dev/null 2>&1
        echo "  ✓ Removed: $image"
    done
    echo ""
fi

# Remove test images
echo -e "${YELLOW}Verwijderen van alpine images...${NC}"
docker rmi alpine:latest alpine:3.18 > /dev/null 2>&1 && echo "  ✓ Removed: alpine images"
echo ""

echo -e "${YELLOW}Verwijderen van nginx:alpine...${NC}"
docker rmi nginx:alpine > /dev/null 2>&1 && echo "  ✓ Removed: nginx:alpine"
echo ""

echo -e "${YELLOW}Verwijderen van postgres:alpine...${NC}"
docker rmi postgres:alpine > /dev/null 2>&1 && echo "  ✓ Removed: postgres:alpine"
echo ""

# 7. Clean up temporary files
echo -e "${GREEN}[6] Opruimen van tijdelijke bestanden...${NC}"
echo ""

if [ -d "/tmp/dm1-bind-mount" ]; then
    rm -rf /tmp/dm1-bind-mount
    echo "  ✓ Removed: /tmp/dm1-bind-mount"
fi

if [ -d "/tmp/dm1-backups" ]; then
    rm -rf /tmp/dm1-backups
    echo "  ✓ Removed: /tmp/dm1-backups"
fi
echo ""

# 8. Verify cleanup
echo -e "${GREEN}[7] Verificatie van cleanup...${NC}"
echo ""

echo -e "${YELLOW}Resterende dm1 resources:${NC}"
echo ""

remaining_containers=$(docker ps -a --filter "name=dm1-" -q | wc -l)
remaining_networks=$(docker network ls --filter "name=dm1-" -q | wc -l)
remaining_volumes=$(docker volume ls --filter "name=dm1-" -q | wc -l)

echo "Containers: $remaining_containers"
echo "Networks: $remaining_networks"
echo "Volumes: $remaining_volumes"
echo ""

if [ $remaining_containers -eq 0 ] && [ $remaining_networks -eq 0 ] && [ $remaining_volumes -eq 0 ]; then
    echo -e "${GREEN}✓ Alle dm1 resources succesvol verwijderd!${NC}"
else
    echo -e "${YELLOW}⚠ Sommige resources konden niet verwijderd worden.${NC}"
    echo "  Probeer handmatig op te ruimen met:"
    echo "    docker rm -f \$(docker ps -a --filter 'name=dm1-' -q)"
    echo "    docker network rm \$(docker network ls --filter 'name=dm1-' -q)"
    echo "    docker volume rm \$(docker volume ls --filter 'name=dm1-' -q)"
fi
echo ""

# 9. Final system state
echo -e "${GREEN}[8] Huidige system state:${NC}"
echo ""

echo "Docker disk usage na cleanup:"
docker system df
echo ""

# 10. Optional system prune
echo -e "${GREEN}[9] Extra cleanup optie:${NC}"
echo ""
echo "Wil je ook een system-wide cleanup doen?"
echo "Dit verwijdert:"
echo "  • Alle stopped containers (niet alleen dm1)"
echo "  • Alle dangling images"
echo "  • Alle unused networks"
echo ""

read -p "Run 'docker system prune'? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo ""
    echo -e "${YELLOW}Running docker system prune...${NC}"
    docker system prune -f
    echo ""
fi

# Summary
echo -e "${BLUE}=========================================="
echo "Cleanup Compleet!"
echo "==========================================${NC}"
echo ""
echo -e "${GREEN}✓ Dm1 experiment cleanup voltooid${NC}"
echo ""
echo "Verwijderd:"
echo "  • Dm1 containers"
echo "  • Dm1 networks"
echo "  • Dm1 volumes"
echo "  • Test images"
echo "  • Tijdelijke bestanden"
echo ""
echo "Je systeem is klaar voor nieuwe experiments!"
echo ""
echo -e "${BLUE}Handige cleanup commands voor de toekomst:${NC}"
echo ""
echo "Mild cleanup:"
echo "  docker container prune      # Stopped containers"
echo "  docker image prune          # Dangling images"
echo ""
echo "Aggressive cleanup:"
echo "  docker system prune         # Containers + images + networks"
echo "  docker system prune -a      # + alle unused images"
echo ""
echo "ZEER aggressive (met volumes):"
echo "  docker system prune -a --volumes"
echo ""

echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}Bedankt voor het doorlopen van Dm1!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
