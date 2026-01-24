# Pf1 – CI/CD Pipeline met Jenkins

## Wat is dit?
Dit project bevat de **sample app** voor het bouwen van een **CI/CD pipeline** met Jenkins. Gebaseerd op **Lab 6.3.6 - Build a CI/CD Pipeline Using Jenkins** uit de NetAcad cursus.

## Wat is CI/CD?

**CI/CD** staat voor **Continuous Integration / Continuous Deployment**:
- **CI (Continuous Integration)** - Code wijzigingen worden automatisch getest en geïntegreerd
- **CD (Continuous Deployment)** - Geteste code wordt automatisch deployed

**Voordelen:**
- ✅ Automatische testing bij elke code wijziging
- ✅ Snellere bug detectie
- ✅ Snellere deployment
- ✅ Betere code kwaliteit

## Project Bestanden

```
Pf1_JenkinsPipeline/
├── sample_app.py          # Flask applicatie
├── sample-app.sh          # Docker build script
├── Jenkinsfile            # Pipeline definitie
├── templates/
│   └── index.html        # HTML template
├── static/
│   └── style.css         # CSS styling
└── README.md             # Deze file
```

## Vereisten

- Docker geïnstalleerd
- Jenkins Docker image
- GitHub account
- Git configuratie

## Stap 1: Sample App Lokaal Testen

### App runnen zonder Docker
```bash
cd Flask/Pf1_JenkinsPipeline

# Installeer Flask
pip3 install flask

# Run de app
python3 sample_app.py
```

Open browser: `http://localhost:5050`

### App runnen met Docker
```bash
# Build en run met script
bash ./sample-app.sh
```

Open browser: `http://localhost:5050`

Je ziet: **"You are calling me from 172.17.0.1"**

### Container stoppen
```bash
docker stop samplerunning
docker rm samplerunning
```

---

## Stap 2: Git Repository Setup

### Git configureren
```bash
git config --global user.name "Jouw Naam"
git config --global user.email "jouw@email.com"
```

### GitHub repository aanmaken
1. Ga naar https://github.com
2. Klik **New repository**
3. Naam: `sample-app`
4. Beschrijving: `Explore CI/CD with GitHub and Jenkins`
5. Private of Public
6. Klik **Create repository**

### Lokale directory initialiseren
```bash
cd Flask/Pf1_JenkinsPipeline

# Initialiseer Git
git init

# Voeg remote repository toe (vervang USERNAME)
git remote add origin https://github.com/USERNAME/sample-app.git

# Stage alle files
git add *

# Check status
git status

# Commit
git commit -m "Initial commit: sample app files"

# Push naar GitHub
git push origin master
```

---

## Stap 3: Jenkins Docker Container Setup

### Jenkins Docker image downloaden
```bash
docker pull jenkins/jenkins:lts
```

### Jenkins container starten
```bash
docker run --rm -u root -p 8080:8080 \
  -v jenkins-data:/var/jenkins_home \
  -v $(which docker):/usr/bin/docker \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$HOME":/home \
  --name jenkins_server jenkins/jenkins:lts
```

**Belangrijk:**
- Kopieer het **admin password** uit de output!
- Laat deze terminal open (Jenkins draait hier)

### Admin password ophalen (als je het kwijt bent)
```bash
# Open nieuwe terminal
docker exec -it jenkins_server /bin/bash
cat /var/jenkins_home/secrets/initialAdminPassword
exit
```

---

## Stap 4: Jenkins Configuratie

### Jenkins openen
1. Open browser: `http://localhost:8080`
2. Plak admin password
3. Klik **Install suggested plugins**
4. Wacht tot installatie klaar is
5. Klik **Skip and continue as admin**
6. Klik **Save and Finish**
7. Klik **Start using Jenkins**

---

## Stap 5: Build Job Maken in Jenkins

### Nieuwe Job aanmaken
1. Klik **Create a job** of **New Item**
2. Naam: `BuildAppJob`
3. Type: **Freestyle project**
4. Klik **OK**

### Job configureren
**General tab:**
- Description: "My first Jenkins job"

**Source Code Management tab:**
- Kies: **Git**
- Repository URL: `https://github.com/USERNAME/sample-app.git`
- Credentials:
  - Klik **Add** → **Jenkins**
  - Username: GitHub username
  - Password: GitHub Personal Access Token
  - Klik **Add**
- Selecteer de credentials die je zojuist hebt toegevoegd

**Build tab:**
- Add build step: **Execute shell**
- Command:
  ```bash
  bash ./sample-app.sh
  ```

### Job opslaan en builden
1. Klik **Save**
2. Klik **Build Now**
3. Klik op build nummer (bijv. #1)
4. Klik **Console Output**
5. Controleer output - moet eindigen met **SUCCESS**

### Verifieer app draait
Open browser: `http://localhost:5050`

---

## Stap 6: Test Job Maken

### Stop de running container eerst
```bash
docker stop samplerunning
docker rm samplerunning
```

### Nieuwe Test Job
1. Klik **Jenkins** (linksboven)
2. Klik **New Item**
3. Naam: `TestAppJob`
4. Type: **Freestyle project**
5. Klik **OK**

### Test Job configureren
**General:**
- Description: "My first Jenkins test"

**Build Triggers:**
- Check: **Build after other projects are built**
- Projects to watch: `BuildAppJob`

**Build:**
- Add build step: **Execute shell**
- Command:
  ```bash
  if curl http://172.17.0.1:5050/ | grep "You are calling me from 172.17.0.1"; then
      exit 0
  else
      exit 1
  fi
  ```

### Test uitvoeren
1. Klik **Save**
2. Ga terug naar Dashboard
3. Bij **BuildAppJob**, klik build button
4. Beide jobs moeten nu succesvol zijn!

---

## Stap 7: CI/CD Pipeline Maken

### Pipeline Job aanmaken
1. Klik **Jenkins** → **New Item**
2. Naam: `SamplePipeline`
3. Type: **Pipeline**
4. Klik **OK**

### Pipeline script
In het **Pipeline** gedeelte, plak:

```groovy
node {
    stage('Preparation') {
        catchError(buildResult: 'SUCCESS') {
            sh 'docker stop samplerunning'
            sh 'docker rm samplerunning'
        }
    }
    stage('Build') {
        build 'BuildAppJob'
    }
    stage('Results') {
        build 'TestAppJob'
    }
}
```

**Uitleg:**
- **Preparation stage** - Stop/remove oude containers
- **Build stage** - Run BuildAppJob
- **Results stage** - Run TestAppJob

### Pipeline uitvoeren
1. Klik **Save**
2. Klik **Build Now**
3. Stage View toont 3 groene vakken bij succes
4. Klik op build nummer → **Console Output** om details te zien

---

## Jenkins Pipeline Flow

```
Code wijziging → Push naar Git → Jenkins Poll
                                       ↓
                              ┌────────────────┐
                              │  Preparation   │ (Stop oude containers)
                              └────────┬───────┘
                                       ↓
                              ┌────────────────┐
                              │     Build      │ (BuildAppJob)
                              └────────┬───────┘
                                       ↓
                              ┌────────────────┐
                              │    Results     │ (TestAppJob)
                              └────────┬───────┘
                                       ↓
                                   SUCCESS!
```

---

## Handige Docker Commando's

```bash
# Jenkins container status
docker ps

# Jenkins logs bekijken
docker logs jenkins_server

# Jenkins container stoppen
docker stop jenkins_server

# Sample app container stoppen
docker stop samplerunning
docker rm samplerunning

# Alle containers zien
docker ps -a

# Container verwijderen
docker rm CONTAINER_ID
```

---

## Troubleshooting

**Probleem:** Jenkins admin password kwijt
```bash
docker exec -it jenkins_server /bin/bash
cat /var/jenkins_home/secrets/initialAdminPassword
```

**Probleem:** Port 8080 al in gebruik
```bash
# Stop alle containers
docker stop $(docker ps -q)

# Of wijzig Jenkins poort in docker run commando
-p 9090:8080  # Gebruik poort 9090
```

**Probleem:** Sample app draait niet
```bash
# Check of container draait
docker ps | grep samplerunning

# Check logs
docker logs samplerunning
```

**Probleem:** Build job faalt
- Check Console Output in Jenkins
- Verifieer GitHub credentials
- Check of Docker beschikbaar is in Jenkins container

---

## Wat heb je geleerd?

✅ **CI/CD concepten** - Continuous Integration/Deployment
✅ **Jenkins** - Populaire CI/CD tool
✅ **Docker** - Containerization
✅ **Git/GitHub** - Version control
✅ **Pipelines** - Geautomatiseerde workflows
✅ **Testing** - Geautomatiseerde test jobs
✅ **Build automation** - Automatisch bouwen bij code wijzigingen

---

## Volgende Stappen

Wil je meer doen?

1. **Automatische triggers** - Laat Jenkins automatisch builden bij Git push
2. **Email notificaties** - Krijg emails bij build failures
3. **Deploy naar productie** - Voeg deployment stage toe
4. **Multi-branch pipeline** - Verschillende branches apart testen
5. **Docker Compose** - Complexere multi-container setups

---

## Resources

- **Jenkins Documentatie:** https://www.jenkins.io/doc/
- **Docker Hub Jenkins:** https://hub.docker.com/r/jenkins/jenkins
- **Jenkins Pipeline Syntax:** https://www.jenkins.io/doc/book/pipeline/syntax/

---

**Je hebt nu een werkende CI/CD pipeline!** 🎉

Elke keer dat je code wijzigt en pushed naar GitHub, kan Jenkins:
1. De code ophalen
2. De app bouwen
3. Tests uitvoeren
4. Resultaten rapporteren

**Dat is DevOps in de praktijk!** 🚀
