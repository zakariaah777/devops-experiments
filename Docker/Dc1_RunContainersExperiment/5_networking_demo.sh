#!/bin/bash

echo "=========================================="
echo "Container Networking Demo"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Dit script demonstreert Docker container networking${NC}"
echo ""

# 1. Show default networks
echo -e "${GREEN}[1] Beschikbare Docker netwerken:${NC}"
echo ""
docker network ls
echo ""

# 2. Inspect bridge network
echo -e "${GREEN}[2] Inspectie van default bridge netwerk:${NC}"
echo ""
docker network inspect bridge --format='Network: {{.Name}}
Driver: {{.Driver}}
Subnet: {{range .IPAM.Config}}{{.Subnet}}{{end}}

Containers in dit netwerk:{{range .Containers}}
  - {{.Name}}: {{.IPv4Address}}{{end}}'
echo ""
echo ""

# 3. Container IP addresses
echo -e "${GREEN}[3] IP adressen van Dc1 containers:${NC}"
echo ""
containers=("dc1-nginx" "dc1-redis" "dc1-postgres" "dc1-python")

for container in "${containers[@]}"; do
    if docker ps -q -f name=$container > /dev/null 2>&1; then
        ip=$(docker inspect $container --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')
        echo "  $container: $ip"
    fi
done
echo ""

# 4. Test container-to-container communication
echo -e "${GREEN}[4] Test container-to-container communicatie:${NC}"
echo ""

# Get Redis IP
redis_ip=$(docker inspect dc1-redis --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}')

if [ -n "$redis_ip" ]; then
    echo -e "${YELLOW}Test: NGINX container pingen naar Redis ($redis_ip)${NC}"
    docker exec dc1-nginx sh -c "ping -c 3 $redis_ip" 2>/dev/null || echo "  ✗ Ping niet beschikbaar in alpine (normaal)"
    echo ""

    echo -e "${YELLOW}Test: NGINX container kan Redis bereiken via hostname${NC}"
    # Try to connect from nginx to redis using IP
    docker exec dc1-nginx sh -c "wget -q -O- http://$redis_ip:6379" 2>/dev/null && echo "  ✓ Connectie succesvol" || echo "  ℹ Redis is geen HTTP server (verwacht)"
    echo ""
fi

# 5. Port mappings
echo -e "${GREEN}[5] Poort mappings (host → container):${NC}"
echo ""
for container in "${containers[@]}"; do
    if docker ps -q -f name=$container > /dev/null 2>&1; then
        ports=$(docker inspect $container --format='{{range $p, $conf := .NetworkSettings.Ports}}{{if $conf}}{{$p}} -> {{(index $conf 0).HostPort}} {{end}}{{end}}')
        if [ -n "$ports" ]; then
            echo "  $container: $ports"
        else
            echo "  $container: geen poort mappings"
        fi
    fi
done
echo ""

# 6. Create custom network demo
echo -e "${GREEN}[6] Custom netwerk aanmaken (demo):${NC}"
echo ""
echo "Commands om een custom netwerk te maken:"
echo "  $ docker network create dc1-custom-network"
echo "  $ docker run -d --name app1 --network dc1-custom-network nginx"
echo "  $ docker run -d --name app2 --network dc1-custom-network redis"
echo ""
echo "Voordelen van custom networks:"
echo "  ✓ Automatische DNS resolutie tussen containers"
echo "  ✓ Container isolatie"
echo "  ✓ Betere security"
echo "  ✓ Containers kunnen elkaar benaderen via naam i.p.v. IP"
echo ""

# 7. Network commands reference
echo -e "${GREEN}[7] Handige netwerk commands:${NC}"
echo ""
echo "Netwerk beheer:"
echo "  docker network ls                    - Lijst alle netwerken"
echo "  docker network create <name>         - Maak nieuw netwerk"
echo "  docker network inspect <name>        - Inspecteer netwerk"
echo "  docker network connect <net> <cont>  - Verbind container aan netwerk"
echo "  docker network disconnect <net> <cont> - Verwijder container van netwerk"
echo "  docker network rm <name>             - Verwijder netwerk"
echo ""
echo "Container netwerk info:"
echo "  docker inspect <container> | grep IPAddress - Toon IP adres"
echo "  docker port <container>              - Toon poort mappings"
echo "  docker exec <container> ifconfig     - Netwerk interfaces in container"
echo ""

echo -e "${GREEN}✓ Networking demo compleet!${NC}"
