# Jenkins Pipelines

Dit directory bevat experimenten met Jenkins voor Continuous Integration en Continuous Deployment (CI/CD).

## Experimenten

### J1 - Lab 6.3.6: Build a CI/CD Pipeline Using Jenkins
**Status:** Compleet ✅
**Locatie:** `J1_LabExperiment/`

Een volledig uitgewerkt Jenkins CI/CD pipeline lab dat demonstreert:
- Opzetten van Jenkins in een Docker container
- Sample Flask app bouwen en testen
- Geautomatiseerde build en test jobs
- Complete CI/CD pipeline met meerdere stages
- Docker-in-Docker configuratie

**Belangrijkste bestanden:**
- `sample-app/` - Flask applicatie met HTML/CSS
- `Jenkinsfile` - Pipeline definitie
- `test-app.sh` - Automated testing script
- `README.md` - Uitgebreide instructies en troubleshooting

**Wat je leert:**
1. Jenkins installeren en configureren
2. Freestyle jobs maken voor build en test
3. Git integratie met GitHub
4. Jenkins pipelines schrijven in Groovy
5. Docker containers beheren vanuit Jenkins
6. Automated testing implementeren

**Vereisten:**
- Docker
- Git & GitHub account met Personal Access Token
- Poorten 8080 (Jenkins) en 5050 (Sample App) beschikbaar

**Quick Start:**
```bash
cd J1_LabExperiment
# Volg de instructies in de README.md
```

### J2 - Eigen Pipeline Experiment
**Status:** Gepland 📋
**Beschrijving:** Eigen custom Jenkins pipeline experiment

---

## Algemene Referenties

- [Jenkins Official Documentation](https://www.jenkins.io/doc/)
- [Jenkins Pipeline Syntax Reference](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Jenkins Docker Image](https://hub.docker.com/r/jenkins/jenkins)
- [Jenkins Best Practices](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/)

## Tips

### Jenkins in Docker
```bash
# Start Jenkins
docker run --rm -u root -p 8080:8080 \
  -v jenkins-data:/var/jenkins_home \
  -v $(which docker):/usr/bin/docker \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$HOME":/home \
  --name jenkins_server \
  jenkins/jenkins:lts

# Stop Jenkins (in andere terminal)
docker stop jenkins_server

# Bekijk Jenkins logs
docker logs jenkins_server

# Access Jenkins container
docker exec -it jenkins_server /bin/bash
```

### Handige Jenkins Commando's

```bash
# Haal admin wachtwoord op
docker exec -it jenkins_server cat /var/jenkins_home/secrets/initialAdminPassword

# Bekijk Jenkins configuratie
docker exec -it jenkins_server cat /var/jenkins_home/config.xml

# Bekijk geïnstalleerde plugins
docker exec -it jenkins_server ls /var/jenkins_home/plugins/
```

### Common Issues

**Port conflicts:**
```bash
# Check welke process poort 8080 gebruikt
sudo lsof -i :8080

# Of gebruik een andere poort
docker run -p 9090:8080 ... jenkins/jenkins:lts
```

**Permission issues:**
- Zorg dat Jenkins als root draait: `-u root`
- Mount Docker socket: `-v /var/run/docker.sock:/var/run/docker.sock`

**Data persistence:**
- Gebruik named volume: `-v jenkins-data:/var/jenkins_home`
- Backup maken: `docker run --rm -v jenkins-data:/data -v $(pwd):/backup alpine tar czf /backup/jenkins-backup.tar.gz /data`

---

**Volgende stappen:** Na J1 kun je verder met J2 om je eigen custom pipeline te bouwen!
