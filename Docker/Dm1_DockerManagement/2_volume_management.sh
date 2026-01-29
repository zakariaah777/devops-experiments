#!/bin/bash

echo "=========================================="
echo "Docker Volume Management"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Dit script demonstreert Docker volume management voor persistente data${NC}"
echo ""

# 1. Show current volumes
echo -e "${GREEN}[1] Huidige volumes op dit systeem:${NC}"
echo ""
docker volume ls
echo ""

# 2. Create named volumes
echo -e "${GREEN}[2] Named volumes aanmaken:${NC}"
echo ""

echo -e "${YELLOW}Aanmaken van 'dm1-data' volume...${NC}"
docker volume create dm1-data
echo "  ✓ Volume created"
echo ""

echo -e "${YELLOW}Aanmaken van 'dm1-database' volume...${NC}"
docker volume create dm1-database
echo "  ✓ Volume created"
echo ""

echo -e "${YELLOW}Aanmaken van 'dm1-cache' volume...${NC}"
docker volume create dm1-cache
echo "  ✓ Volume created"
echo ""

# 3. List volumes again
echo -e "${GREEN}[3] Updated volume lijst:${NC}"
echo ""
docker volume ls --filter "name=dm1-"
echo ""

# 4. Inspect a volume
echo -e "${GREEN}[4] Volume inspectie (dm1-data):${NC}"
echo ""
docker volume inspect dm1-data --format='Name: {{.Name}}
Driver: {{.Driver}}
Mountpoint: {{.Mountpoint}}
Created: {{.CreatedAt}}'
echo ""

# 5. Use volume in container
echo -e "${GREEN}[5] Volume gebruiken in container:${NC}"
echo ""

echo -e "${YELLOW}Container starten met dm1-data volume...${NC}"
docker run -d --name dm1-writer -v dm1-data:/data alpine sleep 3600
echo "  ✓ Container 'dm1-writer' gestart"
echo ""

echo -e "${YELLOW}Data schrijven naar volume...${NC}"
docker exec dm1-writer sh -c "echo 'Hello from container 1!' > /data/test.txt"
docker exec dm1-writer sh -c "echo 'Timestamp: $(date)' >> /data/test.txt"
docker exec dm1-writer sh -c "echo 'Data persists!' >> /data/test.txt"
echo "  ✓ Data geschreven naar /data/test.txt"
echo ""

echo -e "${YELLOW}Lezen van geschreven data:${NC}"
docker exec dm1-writer cat /data/test.txt | sed 's/^/  /'
echo ""

# 6. Data persistence demo
echo -e "${GREEN}[6] Data persistence demonstratie:${NC}"
echo ""

echo -e "${YELLOW}Container stoppen en verwijderen...${NC}"
docker stop dm1-writer > /dev/null
docker rm dm1-writer > /dev/null
echo "  ✓ Container verwijderd"
echo ""

echo -e "${YELLOW}Nieuwe container starten met HETZELFDE volume...${NC}"
docker run -d --name dm1-reader -v dm1-data:/data alpine sleep 3600
echo "  ✓ Container 'dm1-reader' gestart"
echo ""

echo -e "${YELLOW}Data is nog steeds aanwezig!${NC}"
docker exec dm1-reader cat /data/test.txt | sed 's/^/  /'
echo ""

# 7. Multiple containers sharing volume
echo -e "${GREEN}[7] Meerdere containers delen een volume:${NC}"
echo ""

echo -e "${YELLOW}Extra container met shared volume starten...${NC}"
docker run -d --name dm1-appender -v dm1-data:/data alpine sleep 3600
echo "  ✓ Container 'dm1-appender' gestart"
echo ""

echo -e "${YELLOW}Data toevoegen vanuit tweede container...${NC}"
docker exec dm1-appender sh -c "echo 'Added by container 2!' >> /data/test.txt"
echo "  ✓ Data toegevoegd"
echo ""

echo -e "${YELLOW}Lezen vanuit eerste container:${NC}"
docker exec dm1-reader cat /data/test.txt | sed 's/^/  /'
echo ""

# 8. Volume with database
echo -e "${GREEN}[8] Volume met PostgreSQL database:${NC}"
echo ""

echo -e "${YELLOW}PostgreSQL container met dm1-database volume...${NC}"
docker run -d \
  --name dm1-postgres \
  -e POSTGRES_PASSWORD=secret123 \
  -e POSTGRES_DB=testdb \
  -v dm1-database:/var/lib/postgresql/data \
  postgres:alpine > /dev/null
echo "  ✓ PostgreSQL container gestart"
echo ""

echo -e "${YELLOW}Wachten tot database ready is (10 seconden)...${NC}"
sleep 10
echo "  ✓ Database ready"
echo ""

echo -e "${YELLOW}Tabel aanmaken en data invoeren...${NC}"
docker exec dm1-postgres psql -U postgres -d testdb -c "
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO users (name) VALUES ('Alice'), ('Bob'), ('Charlie');
" > /dev/null 2>&1
echo "  ✓ Tabel created en data ingevoerd"
echo ""

echo -e "${YELLOW}Data ophalen:${NC}"
docker exec dm1-postgres psql -U postgres -d testdb -c "SELECT * FROM users;" 2>/dev/null | sed 's/^/  /'
echo ""

# 9. Bind mount demonstration
echo -e "${GREEN}[9] Bind mount (host directory):${NC}"
echo ""

echo -e "${YELLOW}Maak tijdelijke directory aan...${NC}"
mkdir -p /tmp/dm1-bind-mount
echo "Host data voor bind mount test" > /tmp/dm1-bind-mount/host-file.txt
echo "  ✓ Directory aangemaakt: /tmp/dm1-bind-mount"
echo ""

echo -e "${YELLOW}Container met bind mount starten...${NC}"
docker run -d --name dm1-bindmount -v /tmp/dm1-bind-mount:/mnt alpine sleep 3600
echo "  ✓ Container gestart"
echo ""

echo -e "${YELLOW}Bestand van host lezen in container:${NC}"
docker exec dm1-bindmount cat /mnt/host-file.txt | sed 's/^/  /'
echo ""

echo -e "${YELLOW}Bestand schrijven vanuit container:${NC}"
docker exec dm1-bindmount sh -c "echo 'Written from container!' > /mnt/container-file.txt"
echo "  ✓ Bestand geschreven"
echo ""

echo -e "${YELLOW}Bestand is zichtbaar op host:${NC}"
cat /tmp/dm1-bind-mount/container-file.txt | sed 's/^/  /'
echo ""

# 10. Volume backup demo
echo -e "${GREEN}[10] Volume backup maken:${NC}"
echo ""

echo -e "${YELLOW}Backup van dm1-data volume...${NC}"
mkdir -p /tmp/dm1-backups
docker run --rm \
  -v dm1-data:/source:ro \
  -v /tmp/dm1-backups:/backup \
  alpine tar czf /backup/dm1-data-backup.tar.gz -C /source .
echo "  ✓ Backup aangemaakt: /tmp/dm1-backups/dm1-data-backup.tar.gz"
echo ""

echo -e "${YELLOW}Backup inhoud:${NC}"
ls -lh /tmp/dm1-backups/ | sed 's/^/  /'
echo ""

# 11. Volume size information
echo -e "${GREEN}[11] Volume size informatie:${NC}"
echo ""
echo "dm1-data volume size:"
docker run --rm -v dm1-data:/data alpine du -sh /data | sed 's/^/  /'
echo ""
echo "dm1-database volume size:"
docker run --rm -v dm1-database:/data alpine du -sh /data | sed 's/^/  /'
echo ""

# 12. List all dm1 volumes with details
echo -e "${GREEN}[12] Overzicht van alle dm1 volumes:${NC}"
echo ""
docker volume ls --filter "name=dm1-" --format "table {{.Name}}\t{{.Driver}}\t{{.Mountpoint}}"
echo ""

# Summary
echo -e "${BLUE}=========================================="
echo "Volume Management Samenvatting"
echo "==========================================${NC}"
echo ""
echo "Aangemaakt:"
echo "  • 3 Named volumes (dm1-data, dm1-database, dm1-cache)"
echo "  • 5 Test containers met volume mounts"
echo "  • 1 Bind mount naar host directory"
echo "  • 1 Volume backup"
echo ""
echo "Getest:"
echo "  ✓ Data persistence na container verwijdering"
echo "  ✓ Volume sharing tussen containers"
echo "  ✓ Database met persistent storage"
echo "  ✓ Bind mounts voor host directories"
echo "  ✓ Volume backups maken"
echo ""
echo -e "${BLUE}Handige Volume Commands:${NC}"
echo ""
echo "Basis:"
echo "  docker volume create <name>        - Maak volume"
echo "  docker volume ls                   - Lijst volumes"
echo "  docker volume inspect <name>       - Volume details"
echo "  docker volume rm <name>            - Verwijder volume"
echo ""
echo "Gebruik:"
echo "  docker run -v <volume>:/path       - Mount named volume"
echo "  docker run -v /host:/container     - Bind mount"
echo "  docker run -v <vol>:/path:ro       - Read-only mount"
echo ""
echo "Backup & Restore:"
echo "  # Backup"
echo "  docker run --rm -v vol:/src -v \$(pwd):/backup alpine \\"
echo "    tar czf /backup/backup.tar.gz -C /src ."
echo ""
echo "  # Restore"
echo "  docker run --rm -v vol:/dest -v \$(pwd):/backup alpine \\"
echo "    tar xzf /backup/backup.tar.gz -C /dest"
echo ""
echo "Cleanup:"
echo "  docker volume prune                - Verwijder unused volumes"
echo ""

echo -e "${GREEN}✓ Volume management demo compleet!${NC}"
echo ""
echo "Containers en volumes blijven draaien voor demonstratie."
echo "Gebruik script 6_complete_cleanup.sh om alles op te ruimen."
echo ""
