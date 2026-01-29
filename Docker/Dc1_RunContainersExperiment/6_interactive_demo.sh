#!/bin/bash

echo "=========================================="
echo "Container Interactie & Exec Demo"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Dit script demonstreert hoe je interactief met containers werkt${NC}"
echo ""

# 1. Execute commands in running containers
echo -e "${GREEN}[1] Commando's uitvoeren in draaiende containers:${NC}"
echo ""

echo -e "${YELLOW}NGINX container - bestand systeem verkennen:${NC}"
docker exec dc1-nginx ls -la /etc/nginx/ | head -10 | sed 's/^/  /'
echo ""

echo -e "${YELLOW}Redis container - versie check:${NC}"
docker exec dc1-redis redis-server --version | sed 's/^/  /'
echo ""

echo -e "${YELLOW}PostgreSQL container - database lijst:${NC}"
docker exec dc1-postgres psql -U devopsuser -c "\l" | sed 's/^/  /'
echo ""

# 2. Working with files
echo -e "${GREEN}[2] Werken met bestanden in containers:${NC}"
echo ""

echo -e "${YELLOW}Bestand aanmaken in NGINX container:${NC}"
docker exec dc1-nginx sh -c "echo 'Hello from container!' > /tmp/test.txt"
echo "  ✓ Bestand aangemaakt: /tmp/test.txt"
echo ""

echo -e "${YELLOW}Bestand lezen uit container:${NC}"
docker exec dc1-nginx cat /tmp/test.txt | sed 's/^/  /'
echo ""

# 3. Copy files between host and container
echo -e "${GREEN}[3] Bestanden kopiëren tussen host en container:${NC}"
echo ""

echo "Create test file on host:"
echo "  $ echo 'Test from host' > host-test.txt"
echo "  $ docker cp host-test.txt dc1-nginx:/tmp/"
echo ""

echo "Copy file from container to host:"
echo "  $ docker cp dc1-nginx:/etc/nginx/nginx.conf ./nginx-backup.conf"
echo ""

# 4. Database operations
echo -e "${GREEN}[4] Database operaties in PostgreSQL:${NC}"
echo ""

echo -e "${YELLOW}Maak test tabel en voeg data toe:${NC}"
docker exec dc1-postgres psql -U devopsuser -d testdb -c "
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);
INSERT INTO users (name, email) VALUES
    ('Alice', 'alice@example.com'),
    ('Bob', 'bob@example.com');
" 2>/dev/null | sed 's/^/  /'
echo ""

echo -e "${YELLOW}Query de data:${NC}"
docker exec dc1-postgres psql -U devopsuser -d testdb -c "SELECT * FROM users;" | sed 's/^/  /'
echo ""

# 5. Redis operations
echo -e "${GREEN}[5] Redis cache operaties:${NC}"
echo ""

echo -e "${YELLOW}Set en Get operaties:${NC}"
docker exec dc1-redis redis-cli SET mykey "Hello Redis" | sed 's/^/  /'
docker exec dc1-redis redis-cli GET mykey | sed 's/^/  /'
echo ""

echo -e "${YELLOW}List operaties:${NC}"
docker exec dc1-redis redis-cli LPUSH mylist "item1" "item2" "item3" > /dev/null
docker exec dc1-redis redis-cli LRANGE mylist 0 -1 | sed 's/^/  /'
echo ""

# 6. Environment variables
echo -e "${GREEN}[6] Environment variables in containers:${NC}"
echo ""

echo -e "${YELLOW}PostgreSQL environment variables:${NC}"
docker exec dc1-postgres env | grep POSTGRES | sed 's/^/  /'
echo ""

# 7. Process information
echo -e "${GREEN}[7] Processen bekijken in containers:${NC}"
echo ""

echo -e "${YELLOW}NGINX processen:${NC}"
docker exec dc1-nginx ps aux | head -5 | sed 's/^/  /'
echo ""

echo -e "${YELLOW}Redis processen:${NC}"
docker exec dc1-redis ps aux | head -5 | sed 's/^/  /'
echo ""

# 8. Interactive shell info
echo -e "${GREEN}[8] Interactieve shell toegang:${NC}"
echo ""

echo "Om een interactieve shell in een container te openen:"
echo ""
echo "Alpine-based containers (nginx, redis, python):"
echo "  $ docker exec -it dc1-nginx /bin/sh"
echo ""
echo "Debian-based containers (postgres):"
echo "  $ docker exec -it dc1-postgres /bin/bash"
echo ""
echo "In de shell kun je:"
echo "  • Bestanden verkennen (ls, cd, cat)"
echo "  • Packages installeren (apk add / apt-get install)"
echo "  • Logs bekijken (tail -f /var/log/...)"
echo "  • Configuratie aanpassen"
echo "  • Debugging tools gebruiken"
echo ""
echo "Tip: Type 'exit' om de container shell te verlaten"
echo ""

# 9. Useful exec commands
echo -e "${GREEN}[9] Handige docker exec voorbeelden:${NC}"
echo ""
echo "Basis commands:"
echo "  docker exec <container> <command>              - Voer command uit"
echo "  docker exec -it <container> /bin/sh            - Interactieve shell"
echo "  docker exec -u root <container> <command>      - Als root gebruiker"
echo "  docker exec -w /app <container> <command>      - Stel working directory in"
echo ""
echo "Debugging:"
echo "  docker exec <container> ps aux                 - Draaiende processen"
echo "  docker exec <container> df -h                  - Disk ruimte"
echo "  docker exec <container> env                    - Environment variables"
echo "  docker exec <container> netstat -tlnp          - Open poorten"
echo ""
echo "Database queries:"
echo "  docker exec <postgres> psql -U user -d db -c 'SELECT ...' "
echo "  docker exec <mysql> mysql -u user -p password -e 'SELECT ...' "
echo "  docker exec <redis> redis-cli GET key"
echo ""

echo -e "${GREEN}✓ Interactive demo compleet!${NC}"
echo ""
echo "Probeer het zelf:"
echo "  docker exec -it dc1-nginx /bin/sh"
echo "  docker exec -it dc1-postgres /bin/bash"
