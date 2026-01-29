# Dc1 – Run Containers Experiment

## Wat doet dit?
Een complete gids voor **Docker container management**. Dit experiment demonstreert hoe je meerdere containers runt, beheert, inspecteert, debugt en opruimt. Je leert alle essentiële Docker commands voor dagelijks container beheer.

## Wat leer je?
- 🚀 **Meerdere containers tegelijk runnen** (NGINX, Redis, PostgreSQL, Python)
- 🔍 **Container inspectie** (status, resources, netwerk info)
- 📊 **Resource monitoring** (CPU, geheugen, netwerk gebruik)
- 📝 **Log management** (viewing, filtering, real-time streaming)
- 🌐 **Container networking** (IP adressen, poort mapping, inter-container communicatie)
- 💻 **Interactieve toegang** (docker exec, shell access, command uitvoering)
- 🗑️ **Container lifecycle** (starten, stoppen, verwijderen, opruimen)
- 🔧 **Database operaties** in containers (PostgreSQL queries, Redis commands)

## Prerequisites
- Docker geïnstalleerd en draaiend
- Basis kennis van Linux commands
- Terminal toegang

## Wat word er gerund?
Dit experiment start 4 verschillende containers:

1. **NGINX** (nginx:alpine) - Web server op poort 8081
2. **Redis** (redis:alpine) - Cache server op poort 6379
3. **PostgreSQL** (postgres:alpine) - Database op poort 5432
4. **Python** (python:3.9-alpine) - Simple web server op poort 8082

---

## 🚀 Quick Start

### Stap 1: Ga naar de directory
```bash
cd Docker/Dc1_RunContainersExperiment
```

### Stap 2: Start alle containers
```bash
bash 1_start_containers.sh
```

Je ziet output met:
- ✓ NGINX draait op http://localhost:8081
- ✓ Redis draait op poort 6379
- ✓ PostgreSQL draait op poort 5432 (user: devopsuser, password: devops123)
- ✓ Python web server draait op http://localhost:8082

### Stap 3: Test in browser
- Open `http://localhost:8081` - NGINX welcome pagina
- Open `http://localhost:8082` - Python served HTML pagina

---

## 📚 Scripts Uitleg

### Script 1: `1_start_containers.sh`
Start 4 verschillende containers met verschillende configuraties.

**Wat het doet:**
- Runt NGINX als web server
- Start Redis cache server
- Configureert PostgreSQL met custom gebruiker en database
- Maakt Python web server met custom HTML
- Toont overzicht van draaiende containers

**Commands die gebruikt worden:**
- `docker run -d` - Run container in detached mode
- `docker run -p` - Port mapping (host:container)
- `docker run -e` - Environment variables instellen
- `docker run -v` - Volume mounting
- `docker ps --filter` - Filter containers op naam

**Run het:**
```bash
bash 1_start_containers.sh
```

---

### Script 2: `2_inspect_containers.sh`
Inspecteer en monitor draaiende containers.

**Wat het doet:**
- Toont container status en images
- Monitort resource gebruik (CPU, geheugen, netwerk)
- Inspecteert gedetailleerde container info
- Test container connectiviteit (HTTP, Redis, PostgreSQL)
- Toont processen in containers
- Bekijkt netwerk configuratie

**Commands die gebruikt worden:**
- `docker ps --format` - Custom output formatting
- `docker stats` - Resource monitoring
- `docker inspect` - Gedetailleerde container info
- `docker exec` - Commando's uitvoeren in container
- `curl` - HTTP requests testen
- `docker network inspect` - Netwerk informatie

**Handige info:**
```bash
# Krijg IP adres
docker inspect <container> --format='{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}'

# Check container status
docker inspect <container> --format='{{.State.Status}}'

# Poort mappings
docker port <container>
```

**Run het:**
```bash
bash 2_inspect_containers.sh
```

---

### Script 3: `3_view_logs.sh`
Bekijk en analyseer container logs.

**Wat het doet:**
- Toont laatste 20 log regels van elke container
- Demonstreert logs met timestamps
- Filtert logs op tijd
- Legt uit hoe real-time log streaming werkt

**Commands die gebruikt worden:**
- `docker logs` - Basic log viewing
- `docker logs --tail N` - Laatste N regels
- `docker logs --since` - Logs sinds specifieke tijd
- `docker logs --timestamps` - Met timestamps
- `docker logs -f` - Follow mode (real-time)

**Handige voorbeelden:**
```bash
# Laatste 50 regels
docker logs --tail 50 dc1-nginx

# Laatste uur
docker logs --since 1h dc1-nginx

# Met timestamps
docker logs --timestamps dc1-nginx

# Real-time streaming
docker logs -f dc1-nginx

# Tussen timestamps
docker logs --since "2024-01-01T00:00:00" --until "2024-01-01T23:59:59" dc1-nginx
```

**Run het:**
```bash
bash 3_view_logs.sh
```

---

### Script 4: `4_stop_containers.sh`
Stop en ruim alle Dc1 containers op.

**Wat het doet:**
- Toont draaiende containers
- Vraagt bevestiging voor stoppen
- Stopt alle containers gracefully
- Verwijdert containers
- Ruimt tijdelijke bestanden op
- Verifieert dat alles verwijderd is

**Commands die gebruikt worden:**
- `docker stop` - Stop container gracefully
- `docker rm` - Verwijder container
- `docker ps -a` - Alle containers (ook gestopte)
- `docker system prune` - Systeembrede cleanup

**Cleanup voorbeelden:**
```bash
# Stop alle draaiende containers
docker stop $(docker ps -q)

# Verwijder alle gestopte containers
docker rm $(docker ps -a -q)

# Verwijder ongebruikte resources
docker system prune

# Verwijder ALLES (images, containers, volumes, networks)
docker system prune -a --volumes
```

**Run het:**
```bash
bash 4_stop_containers.sh
```

---

### Script 5: `5_networking_demo.sh`
Demonstreer Docker container networking.

**Wat het doet:**
- Toont beschikbare Docker netwerken
- Inspecteert default bridge netwerk
- Toont IP adressen van containers
- Test container-to-container communicatie
- Legt custom networks uit
- Demonstreert poort mappings

**Commands die gebruikt worden:**
- `docker network ls` - Lijst netwerken
- `docker network inspect` - Netwerk details
- `docker network create` - Nieuw netwerk aanmaken
- `docker network connect` - Container verbinden aan netwerk
- `docker port` - Poort mappings tonen

**Netwerk concepten:**

**1. Default Bridge Network:**
- Alle containers zitten standaard in bridge netwerk
- Containers kunnen elkaar bereiken via IP adres
- Geen automatische DNS resolutie

**2. Custom Networks:**
```bash
# Maak custom netwerk
docker network create my-network

# Run containers in custom netwerk
docker run -d --name app1 --network my-network nginx
docker run -d --name app2 --network my-network redis

# Nu kunnen containers elkaar bereiken via naam:
docker exec app1 ping app2  # Werkt!
```

**3. Poort Mapping:**
```bash
# Map host poort 8080 naar container poort 80
docker run -p 8080:80 nginx

# Alle interfaces
docker run -p 80:80 nginx

# Specifiek IP
docker run -p 127.0.0.1:8080:80 nginx

# Random host poort
docker run -p 80 nginx
```

**Run het:**
```bash
bash 5_networking_demo.sh
```

---

### Script 6: `6_interactive_demo.sh`
Demonstreer interactieve container toegang en operaties.

**Wat het doet:**
- Voert commando's uit in draaiende containers
- Werkt met bestanden in containers
- Demonstreert database operaties (PostgreSQL)
- Toont Redis cache operaties
- Bekijkt environment variables
- Legt interactieve shell toegang uit

**Commands die gebruikt worden:**
- `docker exec` - Commando uitvoeren in container
- `docker exec -it` - Interactieve terminal
- `docker cp` - Files kopiëren tussen host en container
- Database en cache operaties

**Belangrijke voorbeelden:**

**1. Simpele commands:**
```bash
# Bestand lezen
docker exec dc1-nginx cat /etc/nginx/nginx.conf

# Directory listing
docker exec dc1-nginx ls -la /var/www/html

# Process lijst
docker exec dc1-nginx ps aux
```

**2. Interactieve shell:**
```bash
# Alpine containers (nginx, redis, python)
docker exec -it dc1-nginx /bin/sh

# Debian/Ubuntu containers (postgres)
docker exec -it dc1-postgres /bin/bash

# Als root
docker exec -it -u root dc1-nginx /bin/sh
```

**3. Bestanden kopiëren:**
```bash
# Van host naar container
docker cp myfile.txt dc1-nginx:/tmp/

# Van container naar host
docker cp dc1-nginx:/etc/nginx/nginx.conf ./backup/

# Directory kopiëren
docker cp mydir dc1-nginx:/app/
```

**4. Database operaties:**
```bash
# PostgreSQL query
docker exec dc1-postgres psql -U devopsuser -d testdb -c "SELECT * FROM users;"

# Redis operations
docker exec dc1-redis redis-cli SET mykey "value"
docker exec dc1-redis redis-cli GET mykey
```

**Run het:**
```bash
bash 6_interactive_demo.sh
```

---

## 🎯 Complete Workflow

Hier is een complete workflow om alle scripts te gebruiken:

```bash
# 1. Start containers
bash 1_start_containers.sh

# 2. Inspecteer status en resources
bash 2_inspect_containers.sh

# 3. Bekijk logs
bash 3_view_logs.sh

# 4. Test networking
bash 5_networking_demo.sh

# 5. Interactieve operaties
bash 6_interactive_demo.sh

# 6. Stop en ruim op
bash 4_stop_containers.sh
```

---

## 📋 Handige Docker Commands Referentie

### Container Lifecycle
```bash
# Start container
docker run -d --name myapp nginx

# Stop container
docker stop myapp

# Start gestopte container
docker start myapp

# Restart container
docker restart myapp

# Pause/unpause
docker pause myapp
docker unpause myapp

# Verwijder container
docker rm myapp

# Force remove draaiende container
docker rm -f myapp
```

### Monitoring & Inspectie
```bash
# Alle draaiende containers
docker ps

# Alle containers (ook gestopte)
docker ps -a

# Resource gebruik
docker stats

# Container details
docker inspect myapp

# Processen in container
docker top myapp

# Poort mappings
docker port myapp

# Container logs
docker logs myapp
docker logs -f myapp  # real-time
```

### Netwerk
```bash
# Lijst netwerken
docker network ls

# Inspecteer netwerk
docker network inspect bridge

# Maak netwerk
docker network create mynet

# Verbind container aan netwerk
docker network connect mynet myapp

# Verwijder netwerk
docker network rm mynet
```

### Exec & Interactie
```bash
# Commando uitvoeren
docker exec myapp ls -la

# Interactieve shell
docker exec -it myapp /bin/bash

# Als specifieke user
docker exec -u root myapp whoami

# Met working directory
docker exec -w /app myapp ls
```

### Cleanup
```bash
# Stop alle containers
docker stop $(docker ps -q)

# Verwijder alle containers
docker rm $(docker ps -a -q)

# Verwijder ongebruikte images
docker image prune

# Verwijder ongebruikte volumes
docker volume prune

# Complete cleanup
docker system prune -a --volumes
```

---

## 🔧 Troubleshooting

### Container start niet
```bash
# Check logs
docker logs <container>

# Probeer interactief
docker run -it nginx /bin/sh

# Check poort conflict
netstat -tlnp | grep <poort>
```

### Kan niet connecten naar container
```bash
# Check of container draait
docker ps

# Check poort mapping
docker port <container>

# Check logs voor errors
docker logs <container>

# Test netwerk
docker exec <container> ping 8.8.8.8
```

### Container gebruikt teveel resources
```bash
# Check resource gebruik
docker stats <container>

# Limiteer resources bij starten
docker run -m 512m --cpus 1 nginx

# Update limits van draaiende container
docker update --memory 512m <container>
```

### Geen toegang tot container shell
```bash
# Probeer verschillende shells
docker exec -it <container> /bin/bash
docker exec -it <container> /bin/sh
docker exec -it <container> sh

# Check of container draait
docker ps -f name=<container>
```

---

## 💡 Tips & Best Practices

### Container Namen
- Gebruik beschrijvende namen: `my-app-web` i.p.v. `container1`
- Gebruik prefixes voor groepering: `dc1-nginx`, `dc1-redis`
- Vermijd conflicterende namen

### Resource Management
- Limiteer altijd geheugen en CPU voor productie containers
- Monitor resource gebruik met `docker stats`
- Gebruik health checks

### Netwerken
- Gebruik custom networks voor container isolatie
- Vermijd `--link` (deprecated), gebruik networks
- Documenteer poort mappings

### Logging
- Gebruik centralized logging voor productie
- Configureer log rotation
- Filter logs op tijd voor betere performance

### Security
- Run containers als non-root waar mogelijk
- Gebruik readonly filesystems waar mogelijk
- Limiteer capabilities
- Scan images op vulnerabilities

### Cleanup
- Verwijder gestopte containers regelmatig
- Gebruik `docker system prune` voor cleanup
- Monitor disk ruimte

---

## 🎓 Wat heb je geleerd?

Na het doorlopen van dit experiment heb je kennis van:

✅ **Container Lifecycle Management**
- Containers starten, stoppen, herstarten
- Container status controleren
- Resources monitoren

✅ **Inspectie & Debugging**
- Logs bekijken en filteren
- Container details inspecteren
- Processen monitoren
- Netwerk configuratie checken

✅ **Interactieve Toegang**
- Commands uitvoeren in containers
- Interactieve shell toegang
- Bestanden kopiëren
- Database operaties

✅ **Networking**
- IP adressen en poort mappings
- Container-to-container communicatie
- Custom networks
- DNS resolutie

✅ **Cleanup & Maintenance**
- Containers proper stoppen en verwijderen
- System resources opruimen
- Troubleshooting

---

## 🚀 Volgende Stappen

Na Dc1 kun je verder met:

1. **Docker Compose** - Multi-container apps met één command
2. **Docker Volumes** - Persistente data opslag
3. **Docker Networks** - Geavanceerde netwerk configuraties
4. **Health Checks** - Container health monitoring
5. **Docker Swarm** - Container orchestratie
6. **Kubernetes** - Production-grade orchestratie

---

## 📖 Aanvullende Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker CLI Reference](https://docs.docker.com/engine/reference/commandline/cli/)
- [Docker Best Practices](https://docs.docker.com/develop/dev-best-practices/)
- [Docker Networking Guide](https://docs.docker.com/network/)

---

**Happy Container Management! 🐳**
