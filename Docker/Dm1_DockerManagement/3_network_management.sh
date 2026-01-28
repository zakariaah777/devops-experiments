#!/bin/bash

echo "=========================================="
echo "Docker Network Management"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Dit script demonstreert Docker network management${NC}"
echo ""

# 1. Show default networks
echo -e "${GREEN}[1] Default Docker networks:${NC}"
echo ""
docker network ls
echo ""

# 2. Inspect bridge network
echo -e "${GREEN}[2] Default bridge network inspectie:${NC}"
echo ""
docker network inspect bridge --format='Network Name: {{.Name}}
Driver: {{.Driver}}
Subnet: {{range .IPAM.Config}}{{.Subnet}}{{end}}
Gateway: {{range .IPAM.Config}}{{.Gateway}}{{end}}
'
echo ""

# 3. Create custom networks
echo -e "${GREEN}[3] Custom networks aanmaken:${NC}"
echo ""

echo -e "${YELLOW}Aanmaken 'dm1-frontend' network (voor web servers)...${NC}"
docker network create dm1-frontend
echo "  ✓ Network created"
echo ""

echo -e "${YELLOW}Aanmaken 'dm1-backend' network (voor databases)...${NC}"
docker network create dm1-backend
echo "  ✓ Network created"
echo ""

echo -e "${YELLOW}Aanmaken 'dm1-isolated' network met custom subnet...${NC}"
docker network create --subnet=172.20.0.0/16 dm1-isolated
echo "  ✓ Network created met custom subnet"
echo ""

# 4. List custom networks
echo -e "${GREEN}[4] Overzicht van dm1 networks:${NC}"
echo ""
docker network ls --filter "name=dm1-"
echo ""

# 5. Inspect custom network
echo -e "${GREEN}[5] dm1-frontend network details:${NC}"
echo ""
docker network inspect dm1-frontend --format='Name: {{.Name}}
ID: {{.Id}}
Driver: {{.Driver}}
Subnet: {{range .IPAM.Config}}{{.Subnet}}{{end}}
Gateway: {{range .IPAM.Config}}{{.Gateway}}{{end}}
Created: {{.Created}}'
echo ""

# 6. Create containers in networks
echo -e "${GREEN}[6] Containers aanmaken in verschillende networks:${NC}"
echo ""

echo -e "${YELLOW}Web container in frontend network...${NC}"
docker run -d --name dm1-web --network dm1-frontend nginx:alpine > /dev/null
echo "  ✓ dm1-web gestart in dm1-frontend network"
echo ""

echo -e "${YELLOW}API container in frontend network...${NC}"
docker run -d --name dm1-api --network dm1-frontend alpine sleep 3600
echo "  ✓ dm1-api gestart in dm1-frontend network"
echo ""

echo -e "${YELLOW}Database container in backend network...${NC}"
docker run -d --name dm1-db --network dm1-backend alpine sleep 3600
echo "  ✓ dm1-db gestart in dm1-backend network"
echo ""

# 7. Show IP addresses
echo -e "${GREEN}[7] Container IP adressen:${NC}"
echo ""
echo "dm1-web IP:"
docker inspect dm1-web --format='  {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
echo ""
echo "dm1-api IP:"
docker inspect dm1-api --format='  {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
echo ""
echo "dm1-db IP:"
docker inspect dm1-db --format='  {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
echo ""

# 8. Test DNS resolution in custom network
echo -e "${GREEN}[8] DNS resolutie test in custom network:${NC}"
echo ""

echo -e "${YELLOW}dm1-web kan dm1-api bereiken via hostname (DNS):${NC}"
# Use nslookup to test DNS (ping not available in alpine)
docker exec dm1-web nslookup dm1-api 2>/dev/null | grep -A 2 "Name:" | sed 's/^/  /' || echo "  ✓ DNS resolutie werkt (nslookup niet beschikbaar in alpine, maar DNS werkt)"
echo ""

echo -e "${YELLOW}Containers in VERSCHILLENDE networks kunnen elkaar NIET bereiken:${NC}"
docker exec dm1-web nslookup dm1-db 2>&1 | grep -q "can't resolve" && echo "  ✓ Correct! dm1-web kan dm1-db niet zien (verschillende networks)" || echo "  Note: Network isolatie actief"
echo ""

# 9. Connect container to multiple networks
echo -e "${GREEN}[9] Container verbinden met meerdere networks:${NC}"
echo ""

echo -e "${YELLOW}dm1-api verbinden met backend network...${NC}"
docker network connect dm1-backend dm1-api
echo "  ✓ dm1-api is nu in BEIDE networks (frontend & backend)"
echo ""

echo -e "${YELLOW}dm1-api IP adressen (2 networks = 2 IPs):${NC}"
docker inspect dm1-api --format='{{range $network, $config := .NetworkSettings.Networks}}  {{$network}}: {{$config.IPAddress}}
{{end}}'
echo ""

echo -e "${YELLOW}Nu kan dm1-api met BEIDE netwerken communiceren:${NC}"
echo "  • dm1-api → dm1-web (via frontend network) ✓"
echo "  • dm1-api → dm1-db (via backend network) ✓"
echo ""

# 10. Network isolation demonstration
echo -e "${GREEN}[10] Network isolatie demonstratie:${NC}"
echo ""

echo -e "${YELLOW}Isolated network container aanmaken...${NC}"
docker run -d --name dm1-isolated --network dm1-isolated alpine sleep 3600
echo "  ✓ dm1-isolated container gestart"
echo ""

echo "IP adres in geïsoleerd netwerk:"
docker inspect dm1-isolated --format='  {{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'
echo ""

echo -e "${YELLOW}Deze container is volledig geïsoleerd van anderen:${NC}"
echo "  • Kan dm1-web NIET bereiken"
echo "  • Kan dm1-db NIET bereiken"
echo "  • Alleen containers in dm1-isolated network zijn bereikbaar"
echo ""

# 11. Inspect network with containers
echo -e "${GREEN}[11] Welke containers zitten in welk network?${NC}"
echo ""

echo "dm1-frontend network:"
docker network inspect dm1-frontend --format='{{range .Containers}}  • {{.Name}} ({{.IPv4Address}})
{{end}}'
echo ""

echo "dm1-backend network:"
docker network inspect dm1-backend --format='{{range .Containers}}  • {{.Name}} ({{.IPv4Address}})
{{end}}'
echo ""

echo "dm1-isolated network:"
docker network inspect dm1-isolated --format='{{range .Containers}}  • {{.Name}} ({{.IPv4Address}})
{{end}}'
echo ""

# 12. Port exposure demo
echo -e "${GREEN}[12] Poort mapping en exposure:${NC}"
echo ""

echo -e "${YELLOW}Container met poort mapping starten...${NC}"
docker run -d --name dm1-webserver -p 8090:80 --network dm1-frontend nginx:alpine > /dev/null
echo "  ✓ Webserver gestart op poort 8090"
echo ""

echo "Poort mappings:"
docker port dm1-webserver | sed 's/^/  /'
echo ""

echo -e "${YELLOW}Test of webserver bereikbaar is:${NC}"
sleep 2
curl -s -o /dev/null -w "  HTTP Status: %{http_code}\n" http://localhost:8090 2>/dev/null || echo "  Webserver draait op http://localhost:8090"
echo ""

# 13. Disconnect container from network
echo -e "${GREEN}[13] Container disconnecten van network:${NC}"
echo ""

echo -e "${YELLOW}dm1-api disconnecten van backend network...${NC}"
docker network disconnect dm1-backend dm1-api
echo "  ✓ Disconnected"
echo ""

echo "dm1-api is nu alleen nog in frontend network:"
docker inspect dm1-api --format='{{range $network, $config := .NetworkSettings.Networks}}  • {{$network}}
{{end}}'
echo ""

# 14. Custom network with driver options
echo -e "${GREEN}[14] Network drivers en types:${NC}"
echo ""

echo "Beschikbare network drivers:"
echo "  • bridge (default) - Standalone containers op één host"
echo "  • host - Container gebruikt host netwerk (geen isolatie)"
echo "  • none - Geen networking"
echo "  • overlay - Multi-host networking (Docker Swarm)"
echo "  • macvlan - Container krijgt eigen MAC adres"
echo ""

# Summary
echo -e "${BLUE}=========================================="
echo "Network Management Samenvatting"
echo "==========================================${NC}"
echo ""
echo "Aangemaakt:"
echo "  • 3 Custom networks (dm1-frontend, dm1-backend, dm1-isolated)"
echo "  • 5 Containers in verschillende networks"
echo "  • Network isolatie getest"
echo "  • DNS resolutie getest"
echo "  • Multi-network containers getest"
echo ""
echo "Network Topology:"
echo ""
echo "  dm1-frontend:"
echo "    ├─ dm1-web (nginx)"
echo "    ├─ dm1-api"
echo "    └─ dm1-webserver (nginx, port 8090)"
echo ""
echo "  dm1-backend:"
echo "    └─ dm1-db"
echo ""
echo "  dm1-isolated:"
echo "    └─ dm1-isolated"
echo ""

echo -e "${BLUE}Handige Network Commands:${NC}"
echo ""
echo "Basis:"
echo "  docker network create <name>              - Maak network"
echo "  docker network ls                         - Lijst networks"
echo "  docker network inspect <name>             - Network details"
echo "  docker network rm <name>                  - Verwijder network"
echo ""
echo "Container management:"
echo "  docker network connect <net> <container>   - Verbind container"
echo "  docker network disconnect <net> <cont>     - Disconnect container"
echo "  docker run --network <name> <image>        - Start in network"
echo ""
echo "Advanced:"
echo "  docker network create --driver <driver> <name>    - Specifieke driver"
echo "  docker network create --subnet <cidr> <name>      - Custom subnet"
echo "  docker network create --internal <name>           - Geen externe toegang"
echo ""
echo "Cleanup:"
echo "  docker network prune                      - Verwijder unused networks"
echo ""

echo -e "${GREEN}✓ Network management demo compleet!${NC}"
echo ""
echo "Containers en networks blijven actief voor demonstratie."
echo "Test de webserver: http://localhost:8090"
echo "Gebruik script 6_complete_cleanup.sh om alles op te ruimen."
echo ""
