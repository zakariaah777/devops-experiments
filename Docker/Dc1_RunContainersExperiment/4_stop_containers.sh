#!/bin/bash

echo "=========================================="
echo "Stoppen en Opruimen van Containers"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Show currently running containers
echo -e "${BLUE}Huidige Dc1 containers:${NC}"
docker ps --filter "name=dc1-" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
echo ""

# Ask for confirmation
echo -e "${YELLOW}Wil je alle Dc1 containers stoppen en verwijderen? (y/n)${NC}"
read -r response

if [[ "$response" != "y" && "$response" != "Y" ]]; then
    echo -e "${RED}Geannuleerd.${NC}"
    exit 0
fi

echo ""
echo -e "${BLUE}[1/3] Stoppen van containers...${NC}"
echo ""

# Stop containers gracefully
containers=("dc1-nginx" "dc1-redis" "dc1-postgres" "dc1-python")

for container in "${containers[@]}"; do
    if docker ps -q -f name=$container > /dev/null 2>&1; then
        echo -n "  Stoppen van $container... "
        docker stop $container > /dev/null 2>&1
        echo -e "${GREEN}✓${NC}"
    else
        echo "  $container draait niet"
    fi
done

echo ""
echo -e "${BLUE}[2/3] Verwijderen van containers...${NC}"
echo ""

for container in "${containers[@]}"; do
    if docker ps -a -q -f name=$container > /dev/null 2>&1; then
        echo -n "  Verwijderen van $container... "
        docker rm $container > /dev/null 2>&1
        echo -e "${GREEN}✓${NC}"
    fi
done

echo ""
echo -e "${BLUE}[3/3] Opruimen van tijdelijke bestanden...${NC}"
echo ""

# Clean up index.html if it exists
if [ -f "index.html" ]; then
    rm index.html
    echo "  ✓ index.html verwijderd"
fi

echo ""
echo -e "${GREEN}✓ Alle Dc1 containers zijn gestopt en verwijderd!${NC}"
echo ""

# Show final status
echo -e "${BLUE}Controleren of er nog Dc1 containers zijn...${NC}"
remaining=$(docker ps -a --filter "name=dc1-" -q | wc -l)

if [ "$remaining" -eq 0 ]; then
    echo -e "${GREEN}✓ Geen Dc1 containers meer aanwezig${NC}"
else
    echo -e "${YELLOW}⚠ Er zijn nog $remaining Dc1 containers:${NC}"
    docker ps -a --filter "name=dc1-" --format "table {{.Names}}\t{{.Status}}"
fi

echo ""
echo "Handige opruim commands:"
echo "  docker stop \$(docker ps -q)         - Stop alle draaiende containers"
echo "  docker rm \$(docker ps -a -q)        - Verwijder alle containers"
echo "  docker system prune                 - Ruim ongebruikte data op"
echo "  docker system prune -a              - Ruim ALLE ongebruikte data op"
echo "  docker volume prune                 - Verwijder ongebruikte volumes"
