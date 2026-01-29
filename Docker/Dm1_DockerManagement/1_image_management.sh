#!/bin/bash

echo "=========================================="
echo "Docker Image Management"
echo "=========================================="
echo ""

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}Dit script demonstreert Docker image management${NC}"
echo ""

# 1. Show current images
echo -e "${GREEN}[1] Huidige images op dit systeem:${NC}"
echo ""
docker images
echo ""

# 2. Pull different versions of an image
echo -e "${GREEN}[2] Images downloaden (pull) van Docker Hub:${NC}"
echo ""

echo -e "${YELLOW}Downloading Alpine Linux (verschillende versies)...${NC}"
docker pull alpine:latest
docker pull alpine:3.18
echo ""

echo -e "${YELLOW}Downloading NGINX...${NC}"
docker pull nginx:alpine
echo ""

# 3. List images again to see new ones
echo -e "${GREEN}[3] Updated image lijst:${NC}"
echo ""
docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}\t{{.ID}}"
echo ""

# 4. Inspect an image
echo -e "${GREEN}[4] Image inspectie (alpine:latest):${NC}"
echo ""
echo "Image ID:"
docker inspect alpine:latest --format='  {{.Id}}'
echo ""
echo "Created:"
docker inspect alpine:latest --format='  {{.Created}}'
echo ""
echo "Architecture:"
docker inspect alpine:latest --format='  {{.Architecture}}'
echo ""
echo "OS:"
docker inspect alpine:latest --format='  {{.Os}}'
echo ""
echo "Size:"
docker inspect alpine:latest --format='  {{.Size}} bytes ({{.VirtualSize}} virtual)'
echo ""

# 5. Image history (layers)
echo -e "${GREEN}[5] Image layers (history) van alpine:${NC}"
echo ""
docker history alpine:latest
echo ""

# 6. Tagging images
echo -e "${GREEN}[6] Images taggen voor organisatie:${NC}"
echo ""

echo -e "${YELLOW}Tag alpine:latest als 'my-alpine:v1'${NC}"
docker tag alpine:latest my-alpine:v1
echo "  ✓ Tagged"
echo ""

echo -e "${YELLOW}Tag alpine:latest als 'my-alpine:production'${NC}"
docker tag alpine:latest my-alpine:production
echo "  ✓ Tagged"
echo ""

echo "Images met 'my-alpine' tag:"
docker images my-alpine
echo ""

# 7. Search Docker Hub
echo -e "${GREEN}[7] Zoeken op Docker Hub (redis images):${NC}"
echo ""
docker search redis --limit 5 --format "table {{.Name}}\t{{.Description}}\t{{.Stars}}"
echo ""

# 8. Image size comparison
echo -e "${GREEN}[8] Image size vergelijking:${NC}"
echo ""
echo "Verschillende base images en hun sizes:"
docker images --format "table {{.Repository}}:{{.Tag}}\t{{.Size}}" | grep -E "alpine|nginx" | head -10
echo ""

# 9. Dangling images check
echo -e "${GREEN}[9] Check voor dangling images (images zonder tag):${NC}"
echo ""
dangling_count=$(docker images -f "dangling=true" -q | wc -l)
if [ $dangling_count -gt 0 ]; then
    echo "  Gevonden $dangling_count dangling image(s):"
    docker images -f "dangling=true"
else
    echo "  ✓ Geen dangling images gevonden"
fi
echo ""

# 10. Cleanup demo (just show, don't execute)
echo -e "${GREEN}[10] Image cleanup commands (niet uitgevoerd):${NC}"
echo ""
echo "Verwijder specifiek image:"
echo "  $ docker rmi nginx:alpine"
echo ""
echo "Verwijder dangling images:"
echo "  $ docker image prune"
echo ""
echo "Verwijder ALLE unused images:"
echo "  $ docker image prune -a"
echo ""
echo "Verwijder images ouder dan 720 uur (30 dagen):"
echo "  $ docker image prune -a --filter \"until=720h\""
echo ""

# 11. Summary
echo -e "${GREEN}[11] Image management samenvatting:${NC}"
echo ""
echo "Gedownloade test images:"
docker images --filter "reference=alpine" --filter "reference=nginx:alpine" --format "  • {{.Repository}}:{{.Tag}} ({{.Size}})"
echo ""
docker images --filter "reference=my-alpine" --format "  • {{.Repository}}:{{.Tag}} ({{.Size}})"
echo ""

echo -e "${BLUE}=========================================="
echo "Handige Image Commands"
echo "==========================================${NC}"
echo ""
echo "Download & Inspect:"
echo "  docker pull <image>:<tag>        - Download image"
echo "  docker images                     - Lijst alle images"
echo "  docker inspect <image>            - Image details"
echo "  docker history <image>            - Bekijk layers"
echo ""
echo "Organisatie:"
echo "  docker tag <image> <new-name>     - Tag een image"
echo "  docker search <term>              - Zoek op Docker Hub"
echo ""
echo "Cleanup:"
echo "  docker rmi <image>                - Verwijder image"
echo "  docker image prune                - Verwijder dangling images"
echo "  docker image prune -a             - Verwijder alle unused images"
echo ""

echo -e "${GREEN}✓ Image management demo compleet!${NC}"
echo ""
echo "Note: Test images blijven staan voor volgende scripts."
echo "Gebruik script 6_complete_cleanup.sh om alles op te ruimen."
echo ""
