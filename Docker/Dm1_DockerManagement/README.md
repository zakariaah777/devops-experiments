# Dm1 – Docker Management Experiment

## Wat doet dit?
Een complete gids voor **Docker resource management**. Dit experiment leert je hoe je Docker images, volumes, networks en system resources beheert, optimaliseert en opschoont. Essentiële skills voor efficiënt Docker gebruik in productie.

## Wat leer je?
- 🖼️ **Image Management** (pull, build, tag, push, inspect, remove)
- 💾 **Volume Management** (persistent data, backups, cleanup)
- 🌐 **Network Management** (custom networks, isolatie, DNS)
- 🗑️ **System Cleanup** (prune, disk space management)
- 📊 **Resource Monitoring** (disk usage, container limits)
- ⚙️ **Resource Limits** (CPU, memory constraints)
- 🔍 **System Inspection** (docker info, events, stats)

## Prerequisites
- Docker geïnstalleerd en draaiend
- Basis kennis van Docker containers (Dc1 afgerond aanbevolen)
- Terminal toegang
- ~2GB vrije schijfruimte

## Wat ga je doen?
Dit experiment demonstreert:

1. **Image beheer** - Downloaden, taggen, inspecteren en verwijderen van images
2. **Volume beheer** - Persistente data opslag en backups maken
3. **Network beheer** - Custom networks aanmaken voor container isolatie
4. **System beheer** - Docker system monitoren en opschonen
5. **Resource limits** - CPU en geheugen limieten instellen
6. **Complete cleanup** - Alles netjes opruimen na experimenten

---

## 🚀 Quick Start

### Stap 1: Ga naar de directory
```bash
cd Docker/Dm1_DockerManagement
```

### Stap 2: Run scripts in volgorde
```bash
bash 1_image_management.sh      # Image operaties
bash 2_volume_management.sh     # Volume operaties
bash 3_network_management.sh    # Network operaties
bash 4_system_management.sh     # System info & cleanup
bash 5_resource_limits.sh       # Resource constraints demo
bash 6_complete_cleanup.sh      # Alles opruimen
```

---

## 📚 Scripts Uitleg

### Script 1: `1_image_management.sh`
Leer Docker images beheren en optimaliseren.

**Wat het doet:**
- Images downloaden (pull) van Docker Hub
- Images inspecteren (size, layers, metadata)
- Images taggen voor organisatie
- Images verwijderen om ruimte te besparen
- Image history bekijken
- Dangling images opruimen

**Commands die gebruikt worden:**
- `docker pull` - Download image
- `docker images` - Lijst alle images
- `docker image inspect` - Gedetailleerde image info
- `docker tag` - Tag een image
- `docker rmi` - Verwijder image
- `docker image prune` - Verwijder unused images
- `docker history` - Bekijk image layers

**Belangrijke concepten:**
- **Image tags**: Versie-beheer (latest, v1.0, stable)
- **Image layers**: Hoe Docker images opgebouwd zijn
- **Dangling images**: Ongebruikte images zonder tag
- **Image size**: Optimaliseren voor kleinere images

**Run het:**
```bash
bash 1_image_management.sh
```

---

### Script 2: `2_volume_management.sh`
Leer persistente data opslaan met Docker volumes.

**Wat het doet:**
- Named volumes aanmaken
- Volumes mounten in containers
- Data persisteren tussen container restarts
- Volume inspectie (size, mount point)
- Volume backup maken
- Volumes opruimen

**Commands die gebruikt worden:**
- `docker volume create` - Maak volume
- `docker volume ls` - Lijst volumes
- `docker volume inspect` - Volume details
- `docker run -v` - Mount volume
- `docker volume rm` - Verwijder volume
- `docker volume prune` - Verwijder unused volumes

**Belangrijke concepten:**
- **Named volumes**: Herbruikbare data containers
- **Bind mounts**: Host directory mounten
- **Volume drivers**: Verschillende storage backends
- **Data persistence**: Data behouden na container verwijdering
- **Volume backups**: Data veiligstellen

**Praktisch voorbeeld:**
```bash
# Volume aanmaken
docker volume create my-data

# Container met volume
docker run -d --name db -v my-data:/var/lib/mysql mysql

# Data blijft bestaan na container verwijdering!
docker rm -f db
docker run -d --name db-new -v my-data:/var/lib/mysql mysql
# Oude data is nog beschikbaar
```

**Run het:**
```bash
bash 2_volume_management.sh
```

---

### Script 3: `3_network_management.sh`
Leer Docker networks beheren voor container communicatie.

**Wat het doet:**
- Custom networks aanmaken
- Containers verbinden aan networks
- DNS resolutie tussen containers testen
- Network isolatie demonstreren
- Network drivers uitleggen
- Networks opruimen

**Commands die gebruikt worden:**
- `docker network create` - Maak network
- `docker network ls` - Lijst networks
- `docker network inspect` - Network details
- `docker network connect` - Verbind container
- `docker network disconnect` - Verwijder container
- `docker network rm` - Verwijder network
- `docker network prune` - Verwijder unused networks

**Belangrijke concepten:**
- **Bridge network**: Default Docker network
- **Custom bridge**: Eigen networks met DNS
- **Network isolation**: Containers scheiden
- **DNS resolution**: Containers bereiken via naam
- **Port exposure**: Poorten blootstellen

**Praktisch voorbeeld:**
```bash
# Maak custom network
docker network create my-app-net

# Run containers in netwerk
docker run -d --name web --network my-app-net nginx
docker run -d --name api --network my-app-net python:3.9

# Containers kunnen elkaar bereiken via naam!
docker exec web ping api  # Werkt!
```

**Run het:**
```bash
bash 3_network_management.sh
```

---

### Script 4: `4_system_management.sh`
Leer Docker system resources monitoren en beheren.

**Wat het doet:**
- Docker system informatie bekijken
- Disk usage analyseren
- Unused resources opruimen (prune)
- Docker events monitoren
- Builder cache beheren
- System-wide cleanup

**Commands die gebruikt worden:**
- `docker system info` - System informatie
- `docker system df` - Disk usage
- `docker system prune` - Cleanup unused resources
- `docker system events` - Real-time events
- `docker builder prune` - Builder cache cleanup

**Belangrijke concepten:**
- **Disk management**: Schijfruimte monitoren
- **Pruning**: Veilig opruimen zonder data verlies
- **Builder cache**: Build layers cachen
- **System events**: Docker activiteiten monitoren
- **Resource tracking**: Wat gebruikt ruimte?

**Cleanup levels:**
```bash
# Mild: alleen stopped containers en dangling images
docker system prune

# Medium: ook unused images
docker system prune -a

# Aggressive: inclusief volumes (PAS OP!)
docker system prune -a --volumes
```

**Run het:**
```bash
bash 4_system_management.sh
```

---

### Script 5: `5_resource_limits.sh`
Leer container resources limiteren (CPU, memory).

**Wat het doet:**
- Memory limits instellen
- CPU limits configureren
- Containers met resource constraints runnen
- Resource usage monitoren
- OOM (Out of Memory) demonstreren
- Best practices voor production

**Commands die gebruikt worden:**
- `docker run -m` / `--memory` - Memory limit
- `docker run --cpus` - CPU limit
- `docker stats` - Resource monitoring
- `docker update` - Runtime limits aanpassen
- `docker inspect` - Configured limits bekijken

**Belangrijke concepten:**
- **Memory limits**: Voorkom memory leaks
- **CPU shares**: CPU tijd verdeling
- **OOM Killer**: Wat gebeurt bij te veel geheugen
- **Resource monitoring**: Stats in real-time
- **Production limits**: Altijd limiteren in productie!

**Praktische voorbeelden:**
```bash
# 512MB memory limit
docker run -m 512m nginx

# 1.5 CPU cores
docker run --cpus 1.5 nginx

# Beide gecombineerd
docker run -m 1g --cpus 2 nginx

# Update running container
docker update --memory 2g my-container
```

**Run het:**
```bash
bash 5_resource_limits.sh
```

---

### Script 6: `6_complete_cleanup.sh`
Complete cleanup van alle Dm1 resources.

**Wat het doet:**
- Stop alle Dm1 test containers
- Verwijder alle test images
- Verwijder alle test volumes
- Verwijder alle test networks
- Verifieert cleanup
- Toont finale system status

**Commands die gebruikt worden:**
- `docker stop` - Stop containers
- `docker rm` - Verwijder containers
- `docker rmi` - Verwijder images
- `docker volume rm` - Verwijder volumes
- `docker network rm` - Verwijder networks

**Run het:**
```bash
bash 6_complete_cleanup.sh
```

---

## 🎯 Complete Workflow

Volg deze volgorde voor beste leerervaring:

```bash
# 1. Image management leren
bash 1_image_management.sh

# 2. Volumes voor persistente data
bash 2_volume_management.sh

# 3. Networking tussen containers
bash 3_network_management.sh

# 4. System monitoring en cleanup
bash 4_system_management.sh

# 5. Resource limits en constraints
bash 5_resource_limits.sh

# 6. Alles opruimen
bash 6_complete_cleanup.sh
```

---

## 📋 Handige Docker Management Commands

### Image Management
```bash
# Download image
docker pull nginx:latest

# Lijst images
docker images
docker image ls

# Image details
docker inspect nginx:latest

# Tag image
docker tag nginx:latest myregistry/nginx:v1

# Verwijder image
docker rmi nginx:latest

# Cleanup unused images
docker image prune -a

# Image history
docker history nginx:latest

# Search Docker Hub
docker search nginx
```

### Volume Management
```bash
# Maak volume
docker volume create my-data

# Lijst volumes
docker volume ls

# Volume details
docker volume inspect my-data

# Mount volume
docker run -v my-data:/data nginx

# Bind mount (host directory)
docker run -v /host/path:/container/path nginx

# Verwijder volume
docker volume rm my-data

# Cleanup unused volumes
docker volume prune

# Backup volume
docker run --rm -v my-data:/source -v $(pwd):/backup \
  alpine tar czf /backup/backup.tar.gz -C /source .

# Restore volume
docker run --rm -v my-data:/target -v $(pwd):/backup \
  alpine tar xzf /backup/backup.tar.gz -C /target
```

### Network Management
```bash
# Lijst networks
docker network ls

# Maak network
docker network create my-network
docker network create --driver bridge my-bridge

# Inspect network
docker network inspect my-network

# Connect container
docker network connect my-network my-container

# Disconnect container
docker network disconnect my-network my-container

# Verwijder network
docker network rm my-network

# Cleanup unused networks
docker network prune
```

### System Management
```bash
# System info
docker info
docker version

# Disk usage
docker system df
docker system df -v  # Verbose

# System-wide cleanup
docker system prune              # Mild
docker system prune -a           # Aggressive
docker system prune -a --volumes # ZEER aggressive

# Real-time events
docker system events
docker system events --since 1h

# Builder cache cleanup
docker builder prune
```

### Resource Management
```bash
# Run met limits
docker run -m 512m --cpus 1 nginx

# Memory limits
docker run --memory 1g --memory-swap 2g nginx

# CPU limits
docker run --cpus 2.5 nginx
docker run --cpu-shares 512 nginx

# Update running container
docker update --memory 2g --cpus 3 my-container

# Monitor resources
docker stats
docker stats --no-stream

# Inspect limits
docker inspect --format='{{.HostConfig.Memory}}' my-container
```

---

## 🔧 Troubleshooting

### Image pull fails
```bash
# Check Docker daemon
docker info

# Check network
ping registry-1.docker.io

# Gebruik mirror
docker pull --platform linux/amd64 nginx

# Login als private registry
docker login
```

### Volume permission issues
```bash
# Check volume ownership
docker run --rm -v my-data:/data alpine ls -la /data

# Fix permissions
docker run --rm -v my-data:/data alpine chown -R 1000:1000 /data
```

### Network connectivity issues
```bash
# Check DNS
docker exec my-container nslookup google.com

# Check connectivity
docker exec my-container ping 8.8.8.8

# Inspect network
docker network inspect bridge
```

### Out of disk space
```bash
# Check usage
docker system df

# Aggressive cleanup
docker system prune -a --volumes

# Find large images
docker images --format "{{.Size}}\t{{.Repository}}:{{.Tag}}" | sort -h

# Remove old images
docker image prune -a --filter "until=720h"
```

---

## 💡 Best Practices

### Image Management
- ✅ Gebruik specifieke tags (nginx:1.21) i.p.v. latest
- ✅ Scan images op security vulnerabilities
- ✅ Gebruik multi-stage builds voor kleine images
- ✅ Cleanup oude images regelmatig
- ✅ Tag images consistent (semantic versioning)

### Volume Management
- ✅ Gebruik named volumes voor databases
- ✅ Maak regelmatig backups van volumes
- ✅ Document welke volumes kritieke data bevatten
- ✅ Gebruik volume drivers voor cloud storage
- ✅ Test volume backups regelmatig

### Network Management
- ✅ Gebruik custom networks (niet default bridge)
- ✅ Groepeer gerelateerde containers in netwerken
- ✅ Gebruik DNS namen i.p.v. IP adressen
- ✅ Isoleer verschillende apps in eigen networks
- ✅ Document network architectuur

### System Management
- ✅ Monitor disk usage regelmatig
- ✅ Automatiseer cleanup met cron jobs
- ✅ Gebruik `docker system prune` voorzichtig
- ✅ Log system events voor troubleshooting
- ✅ Zet disk space alerts op

### Resource Management
- ✅ **ALTIJD** memory limits in productie
- ✅ Set CPU limits voor eerlijke resource verdeling
- ✅ Monitor resource usage met docker stats
- ✅ Test OOM behavior voordat je deployt
- ✅ Reserve resources voor Docker daemon zelf

---

## 🎓 Wat heb je geleerd?

Na het doorlopen van dit experiment heb je kennis van:

✅ **Image Management**
- Images downloaden, taggen en organiseren
- Image layers en history begrijpen
- Images optimaliseren voor size
- Cleanup strategieën

✅ **Volume Management**
- Persistente data opslaan
- Volume backups maken en restoren
- Bind mounts vs named volumes
- Data migratie tussen containers

✅ **Network Management**
- Custom networks aanmaken
- Container isolatie implementeren
- DNS resolutie gebruiken
- Multi-container communicatie

✅ **System Management**
- Disk usage monitoren
- System resources opschonen
- Docker events volgen
- Performance optimalisatie

✅ **Resource Limits**
- CPU en memory constraints
- Resource monitoring
- OOM handling
- Production best practices

---

## 🚀 Volgende Stappen

Na Dm1 kun je verder met:

1. **Docker Compose** - Multi-container apps definieren in YAML
2. **Dockerfile Best Practices** - Optimale images bouwen
3. **Docker Registry** - Eigen private registry opzetten
4. **Docker Swarm** - Container orchestratie basics
5. **Kubernetes** - Production-grade orchestratie
6. **CI/CD Integration** - Docker in pipelines

---

## 📖 Aanvullende Resources

- [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/cli/)
- [Docker Storage Guide](https://docs.docker.com/storage/)
- [Docker Networking Guide](https://docs.docker.com/network/)
- [Docker Security Best Practices](https://docs.docker.com/engine/security/)
- [Resource Management](https://docs.docker.com/config/containers/resource_constraints/)

---

**Happy Docker Management! 🐳**
