#!/bin/bash

echo "=========================================="
echo "Docker Resource Limits & Constraints"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}Dit script demonstreert resource limits voor containers${NC}"
echo ""

# 1. Container without limits (baseline)
echo -e "${GREEN}[1] Container ZONDER resource limits (baseline):${NC}"
echo ""

echo -e "${YELLOW}Starten van unlimited container...${NC}"
docker run -d --name dm1-unlimited alpine sleep 3600
echo "  ✓ Container gestart zonder limits"
echo ""

echo "Resource configuratie:"
docker inspect dm1-unlimited --format='Memory limit: {{.HostConfig.Memory}} (0 = unlimited)
CPU shares: {{.HostConfig.CpuShares}} (1024 = default)
CPU quota: {{.HostConfig.CpuQuota}} (-1 = unlimited)
'
echo ""

# 2. Memory limits
echo -e "${GREEN}[2] Memory limits:${NC}"
echo ""

echo -e "${YELLOW}Container met 256MB memory limit...${NC}"
docker run -d --name dm1-limited-256m --memory="256m" alpine sleep 3600
echo "  ✓ Container gestart met 256MB limit"
echo ""

echo -e "${YELLOW}Container met 512MB memory limit...${NC}"
docker run -d --name dm1-limited-512m --memory="512m" alpine sleep 3600
echo "  ✓ Container gestart met 512MB limit"
echo ""

echo -e "${YELLOW}Container met 1GB memory + 2GB swap...${NC}"
docker run -d --name dm1-limited-swap --memory="1g" --memory-swap="2g" alpine sleep 3600
echo "  ✓ Container gestart met memory + swap limits"
echo ""

echo "Memory configuraties:"
echo ""
for container in dm1-limited-256m dm1-limited-512m dm1-limited-swap; do
    echo "$container:"
    docker inspect $container --format='  Memory: {{.HostConfig.Memory}} bytes
  Memory Swap: {{.HostConfig.MemorySwap}} bytes
'
done
echo ""

# 3. CPU limits
echo -e "${GREEN}[3] CPU limits:${NC}"
echo ""

echo -e "${YELLOW}Container met 0.5 CPU...${NC}"
docker run -d --name dm1-cpu-half --cpus="0.5" alpine sleep 3600
echo "  ✓ Container gestart met 0.5 CPU limit"
echo ""

echo -e "${YELLOW}Container met 2 CPUs...${NC}"
docker run -d --name dm1-cpu-two --cpus="2" alpine sleep 3600
echo "  ✓ Container gestart met 2 CPU limit"
echo ""

echo -e "${YELLOW}Container met CPU shares (priority)...${NC}"
docker run -d --name dm1-cpu-high-priority --cpu-shares="2048" alpine sleep 3600
echo "  ✓ Container gestart met hoge CPU priority"
echo ""

echo "CPU configuraties:"
echo ""
for container in dm1-cpu-half dm1-cpu-two dm1-cpu-high-priority; do
    echo "$container:"
    docker inspect $container --format='  CPU Period: {{.HostConfig.CpuPeriod}}
  CPU Quota: {{.HostConfig.CpuQuota}}
  CPU Shares: {{.HostConfig.CpuShares}}
'
done
echo ""

# 4. Combined limits (production-like)
echo -e "${GREEN}[4] Gecombineerde limits (production best practice):${NC}"
echo ""

echo -e "${YELLOW}NGINX webserver met production limits...${NC}"
docker run -d \
  --name dm1-nginx-limited \
  --memory="512m" \
  --memory-swap="1g" \
  --cpus="1.5" \
  --restart=unless-stopped \
  nginx:alpine > /dev/null
echo "  ✓ NGINX gestart met:"
echo "    • 512MB memory limit"
echo "    • 1GB total (memory + swap)"
echo "    • 1.5 CPU cores"
echo "    • Auto-restart policy"
echo ""

# 5. Monitor resource usage
echo -e "${GREEN}[5] Resource usage monitoring:${NC}"
echo ""

echo -e "${YELLOW}Real-time resource stats (snapshot):${NC}"
echo ""
sleep 2
docker stats --no-stream --format "table {{.Name}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.MemPerc}}\t{{.NetIO}}" $(docker ps --filter "name=dm1-" -q)
echo ""

# 6. Update limits on running container
echo -e "${GREEN}[6] Runtime limit updates:${NC}"
echo ""

echo -e "${YELLOW}Huidige limits van dm1-limited-256m:${NC}"
docker inspect dm1-limited-256m --format='  Memory: {{.HostConfig.Memory}} bytes ({{div .HostConfig.Memory 1048576}} MB)'
echo ""

echo -e "${YELLOW}Update memory limit naar 512MB...${NC}"
docker update --memory="512m" dm1-limited-256m > /dev/null
echo "  ✓ Limit updated (container blijft draaien!)"
echo ""

echo -e "${YELLOW}Nieuwe limits:${NC}"
docker inspect dm1-limited-256m --format='  Memory: {{.HostConfig.Memory}} bytes ({{div .HostConfig.Memory 1048576}} MB)'
echo ""

# 7. Memory stress test (safe demonstration)
echo -e "${GREEN}[7] Memory limit demonstratie:${NC}"
echo ""

echo -e "${YELLOW}Container met 50MB limit en memory-intensive taak...${NC}"
echo ""

# Run a container that tries to allocate memory
docker run -d --name dm1-memory-test --memory="50m" alpine sh -c "
sleep 5
echo 'Container draait met 50MB limit'
sleep 3600
" > /dev/null

echo "  ✓ Container gestart met zeer lage memory limit (50MB)"
echo ""

sleep 6
echo "Container status:"
docker ps --filter "name=dm1-memory-test" --format "  {{.Names}}: {{.Status}}" || echo "  Container kan gestopt zijn door memory limit"
echo ""

echo -e "${YELLOW}Note:${NC} Als container te veel geheugen probeert te gebruiken,"
echo "wordt deze door de Linux OOM (Out Of Memory) killer gestopt."
echo ""

# 8. Best practices demonstration
echo -e "${GREEN}[8] Resource limit best practices:${NC}"
echo ""

echo "✓ ALTIJD limits instellen in productie:"
echo "  • Voorkom dat één container alle resources gebruikt"
echo "  • Bescherm andere containers en de host"
echo "  • Voorspelbare performance"
echo ""

echo "✓ Realistische limits instellen:"
echo "  • Test memory usage van je applicatie"
echo "  • Monitor CPU usage onder load"
echo "  • Reserve 20% extra voor spikes"
echo ""

echo "✓ Memory limit voorbeelden:"
echo "  • Small service:   256MB - 512MB"
echo "  • Web server:      512MB - 1GB"
echo "  • API server:      1GB - 2GB"
echo "  • Database:        2GB - 8GB+"
echo ""

echo "✓ CPU limit voorbeelden:"
echo "  • Background job:  0.25 - 0.5 CPUs"
echo "  • Web server:      0.5 - 1 CPU"
echo "  • API server:      1 - 2 CPUs"
echo "  • Compute task:    2+ CPUs"
echo ""

# 9. Inspect all limits
echo -e "${GREEN}[9] Overzicht van alle dm1 containers met limits:${NC}"
echo ""

echo -e "${YELLOW}Container resource configuraties:${NC}"
echo ""
for container in $(docker ps --filter "name=dm1-" --format "{{.Names}}"); do
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "Container: $container"
    docker inspect $container --format='Memory:     {{if .HostConfig.Memory}}{{div .HostConfig.Memory 1048576}} MB{{else}}Unlimited{{end}}
Memory+Swap: {{if .HostConfig.MemorySwap}}{{div .HostConfig.MemorySwap 1048576}} MB{{else}}Unlimited{{end}}
CPU Quota:  {{.HostConfig.CpuQuota}} ({{if eq .HostConfig.CpuQuota -1}}Unlimited{{else}}Limited{{end}})
CPU Shares: {{.HostConfig.CpuShares}}
'
done | head -40
echo ""

# 10. Performance comparison
echo -e "${GREEN}[10] Performance impact van limits:${NC}"
echo ""

echo "Effect van resource limits:"
echo ""
echo "  ✓ Memory limits:"
echo "    • Geen performance impact binnen limits"
echo "    • Container stopt bij overschrijding (OOM)"
echo "    • Swap kan performance verlagen"
echo ""
echo "  ✓ CPU limits:"
echo "    • Throttling bij overschrijding"
echo "    • Geen container crash"
echo "    • Eerlijke resource verdeling"
echo ""
echo "  ✓ Production voordelen:"
echo "    • Voorspelbare kosten"
echo "    • Betere resource planning"
echo "    • Isolatie tussen services"
echo "    • Makkelijker troubleshooten"
echo ""

# Summary
echo -e "${BLUE}=========================================="
echo "Resource Limits Samenvatting"
echo "==========================================${NC}"
echo ""
echo "Gedemonstreerd:"
echo "  ✓ Memory limits (256MB, 512MB, 1GB)"
echo "  ✓ CPU limits (0.5, 1.5, 2 CPUs)"
echo "  ✓ Combined limits (production setup)"
echo "  ✓ Runtime limit updates"
echo "  ✓ Resource monitoring"
echo "  ✓ Best practices"
echo ""

echo -e "${BLUE}Resource Limit Commands:${NC}"
echo ""
echo "Memory limits:"
echo "  docker run -m 512m <image>              - Memory limit"
echo "  docker run --memory 1g <image>          - Memory limit (alt)"
echo "  docker run -m 1g --memory-swap 2g <img> - Memory + swap"
echo "  docker run --memory-reservation 256m    - Soft limit"
echo ""
echo "CPU limits:"
echo "  docker run --cpus 1.5 <image>           - CPU cores limit"
echo "  docker run --cpu-shares 512 <image>     - CPU priority"
echo "  docker run --cpuset-cpus 0,1 <image>    - Specific CPU cores"
echo ""
echo "Combined (production):"
echo "  docker run -m 512m --cpus 1 \\"
echo "    --restart unless-stopped \\"
echo "    --name my-app nginx"
echo ""
echo "Update limits:"
echo "  docker update --memory 1g <container>   - Update memory"
echo "  docker update --cpus 2 <container>      - Update CPU"
echo ""
echo "Monitor:"
echo "  docker stats                            - Live monitoring"
echo "  docker stats --no-stream                - One-time snapshot"
echo ""

echo -e "${GREEN}✓ Resource limits demo compleet!${NC}"
echo ""
echo "BELANGRIJK: Gebruik ALTIJD resource limits in productie!"
echo ""
echo "Containers blijven draaien voor demonstratie."
echo "Gebruik script 6_complete_cleanup.sh om alles op te ruimen."
echo ""
