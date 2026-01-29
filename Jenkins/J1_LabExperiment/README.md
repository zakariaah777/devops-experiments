# J1 - Jenkins CI/CD Pipeline Lab

**Experiment Code:** J1
**Gebaseerd op:** Lab 6.3.6 - Build a CI/CD Pipeline Using Jenkins

## Overzicht

Dit experiment demonstreert het opzetten van een volledige CI/CD pipeline met Jenkins. Je leert:
- Een sample Flask app committen naar Git
- Jenkins draaien in een Docker container
- Jenkins configureren en jobs aanmaken
- Geautomatiseerde builds en tests opzetten
- Een complete CI/CD pipeline creëren

## Architectuur

```
+----------------------------------------+
|Computer Operating System               |
| +----------------------------------+   |
| |Docker (of VM met Docker)        |   |
| | +----------------------------+  |   |
| | |Jenkins Container           |  |   |
| | | +----------------------+   |  |   |
| | | |Sample App Container |   |  |   |
| | | +----------------------+   |  |   |
| | +----------------------------+  |   |
| +----------------------------------+   |
+----------------------------------------+
```

## Vereisten

- Docker geïnstalleerd
- Git geïnstalleerd
- GitHub account met Personal Access Token
- Poort 8080 (Jenkins) en 5050 (Sample App) beschikbaar

## Bestanden

```
J1_LabExperiment/
├── README.md                 # Deze instructies
├── Jenkinsfile              # Pipeline definitie
├── test-app.sh              # Test script voor Jenkins
└── sample-app/              # Sample Flask applicatie
    ├── sample_app.py        # Flask applicatie
    ├── sample-app.sh        # Docker build script
    ├── templates/
    │   └── index.html       # HTML template
    └── static/
        └── style.css        # CSS styling
```

## Deel 1: Sample App naar GitHub

### Stap 1: Maak een nieuwe GitHub repository

1. Ga naar https://github.com en login
2. Klik op "New repository" of het "+" icoon rechtsboven
3. Vul in:
   - **Repository name:** `sample-app`
   - **Description:** `Explore CI/CD with GitHub and Jenkins`
   - **Visibility:** Private of Public
4. Klik "Create repository"

### Stap 2: Configureer Git credentials

```bash
cd Jenkins/J1_LabExperiment/sample-app
git config --global user.name "Jouw Naam"
git config --global user.email "jouw@email.com"
```

### Stap 3: Initialiseer Git repository

```bash
git init
```

### Stap 4: Koppel aan GitHub repository

Vervang `JOUW-GITHUB-USERNAME` met je echte GitHub username:

```bash
git remote add origin https://github.com/JOUW-GITHUB-USERNAME/sample-app.git
```

### Stap 5: Commit en push naar GitHub

```bash
# Stage alle bestanden
git add *

# Check status
git status

# Commit met bericht
git commit -m "Initial commit: Sample Flask app voor Jenkins CI/CD"

# Push naar GitHub (gebruik Personal Access Token als password)
git push -u origin master
```

**Let op:** Bij push wordt gevraagd om username en password. Gebruik je Personal Access Token als password!

## Deel 2: Jenkins Docker Container

### Stap 1: Download Jenkins Docker image

```bash
docker pull jenkins/jenkins:lts
```

### Stap 2: Start Jenkins container

**Belangrijke opmerking:** Deze command moet op één regel. Gebruik copy-paste:

```bash
docker run --rm -u root -p 8080:8080 \
  -v jenkins-data:/var/jenkins_home \
  -v $(which docker):/usr/bin/docker \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$HOME":/home \
  --name jenkins_server \
  jenkins/jenkins:lts
```

**Command uitleg:**
- `--rm` - Verwijder container automatisch bij stop
- `-u root` - Run als root voor Docker commands
- `-p 8080:8080` - Expose Jenkins op poort 8080
- `-v jenkins-data:/var/jenkins_home` - Persistent data storage
- `-v $(which docker):/usr/bin/docker` - Docker-in-Docker
- `-v /var/run/docker.sock:/var/run/docker.sock` - Docker socket
- `-v "$HOME":/home` - Mount home directory
- `--name jenkins_server` - Container naam

### Stap 3: Kopieer het admin wachtwoord

Na het starten zie je output zoals:

```
*************************************************************
Jenkins initial setup is required. An admin user has been
created and a password generated.
Please use the following password to proceed to installation:

77dc402e31324c1b917f230af7bfebf2

This may also be found at:
/var/jenkins_home/secrets/initialAdminPassword
*************************************************************
```

**Kopieer dit wachtwoord!**

### Stap 4 (Optioneel): Wachtwoord ophalen als je het kwijt bent

Open een **nieuwe** terminal (laat Jenkins draaien!) en voer uit:

```bash
docker exec -it jenkins_server cat /var/jenkins_home/secrets/initialAdminPassword
```

## Deel 3: Jenkins Configuratie

### Stap 1: Open Jenkins in browser

Ga naar: http://localhost:8080

### Stap 2: Unlock Jenkins

Plak het admin wachtwoord dat je gekopieerd hebt.

### Stap 3: Installeer plugins

Klik op **"Install suggested plugins"** en wacht tot alles geïnstalleerd is.

### Stap 4: Skip admin user creatie

Klik op **"Skip and continue as admin"** onderaan.

### Stap 5: Instance configuratie

Klik op **"Save and Finish"** (niets wijzigen).

### Stap 6: Start Jenkins

Klik op **"Start using Jenkins"**.

Je bent nu op het Jenkins dashboard! 🎉

## Deel 4: Eerste Jenkins Job - BuildAppJob

### Stap 1: Maak nieuwe job

1. Klik op **"Create a job"** of **"New Item"** links
2. **Item name:** `BuildAppJob`
3. Selecteer **"Freestyle project"**
4. Klik **"OK"**

### Stap 2: Configureer de job

**General tab:**
- **Description:** "Builds the sample Flask app from GitHub"

**Source Code Management tab:**
1. Selecteer **"Git"**
2. **Repository URL:** `https://github.com/JOUW-USERNAME/sample-app.git`
3. Klik **"Add"** bij Credentials → kies **"Jenkins"**
4. Vul in:
   - **Username:** Je GitHub username
   - **Password:** Je Personal Access Token
   - **ID:** (laat leeg)
   - Klik **"Add"**
5. Selecteer de credentials die je net maakte in de dropdown

**Build tab:**
1. Klik **"Add build step"** → **"Execute shell"**
2. **Command:**
   ```bash
   bash ./sample-app.sh
   ```
3. Klik **"Save"**

### Stap 3: Run de build

1. Klik **"Build Now"** links
2. Wacht tot de build klaar is
3. Klik op het build nummer (bijv. #1) onder "Build History"
4. Klik **"Console Output"** om de logs te zien

### Stap 4: Verifieer de app

Open browser: http://localhost:5050

Je zou moeten zien: **"You are calling me from 172.17.0.1"** met lichtblauwe achtergrond.

## Deel 5: Test Job - TestAppJob

**Belangrijk:** Stop eerst de running container:

```bash
docker stop samplerunning
docker rm samplerunning
```

### Stap 1: Maak test job

1. Klik **"Jenkins"** linksboven (terug naar dashboard)
2. Klik **"New Item"**
3. **Item name:** `TestAppJob`
4. Selecteer **"Freestyle project"**
5. Klik **"OK"**

### Stap 2: Configureer test job

**General tab:**
- **Description:** "Tests the sample app after successful build"

**Build Triggers tab:**
- Check **"Build after other projects are built"**
- **Projects to watch:** `BuildAppJob`

**Build tab:**
1. Klik **"Add build step"** → **"Execute shell"**
2. **Command** (alles op één regel tot `; then`):
   ```bash
   if curl http://172.17.0.1:5050/ | grep "You are calling me from 172.17.0.1"; then
     exit 0
   else
     exit 1
   fi
   ```
3. Klik **"Save"**

### Stap 3: Test de automatische trigger

1. Ga terug naar dashboard
2. Klik op de build knop bij **BuildAppJob** (klok met pijl)
3. Refresh de pagina (of zet "enable auto refresh" aan rechtsboven)
4. Beide jobs zouden moeten slagen! ✅

## Deel 6: CI/CD Pipeline - SamplePipeline

### Stap 1: Maak pipeline job

1. Klik **"New Item"**
2. **Item name:** `SamplePipeline`
3. Selecteer **"Pipeline"**
4. Klik **"OK"**

### Stap 2: Configureer pipeline

**General tab:**
- **Description:** "Complete CI/CD pipeline voor sample app"

**Pipeline tab:**

Scroll naar beneden en plak dit script in het **Script** veld:

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

**Pipeline script uitleg:**
- **Preparation stage:** Stop en verwijder oude containers (ignoreert errors als er geen zijn)
- **Build stage:** Voer BuildAppJob uit
- **Results stage:** Voer TestAppJob uit

Klik **"Save"**

### Stap 3: Run de pipeline

1. Klik **"Build Now"**
2. Je ziet nu een visuele weergave met 3 groene boxen:
   - Preparation
   - Build
   - Results

### Stap 4: Bekijk pipeline output

1. Klik op het build nummer onder "Build History"
2. Klik **"Console Output"**
3. Je ziet de volledige pipeline execution

## Test Scenario's

### Scenario 1: Wijziging maken en automatisch testen

1. **Wijzig** `templates/index.html` in je lokale sample-app
2. **Commit en push:**
   ```bash
   git add templates/index.html
   git commit -m "Update HTML template"
   git push origin master
   ```
3. **Run de pipeline** in Jenkins → alles wordt automatisch gebuild en getest!

### Scenario 2: Test failure simuleren

1. **Stop** de sample app container:
   ```bash
   docker stop samplerunning
   ```
2. **Run** alleen de TestAppJob
3. De test **faalt** omdat de app niet draait ❌
4. **Run** de volledige pipeline → alles werkt weer ✅

## Cleanup

### Stop alle containers

```bash
# Stop Jenkins
docker stop jenkins_server

# Stop sample app (als die draait)
docker stop samplerunning
docker rm samplerunning
```

### Verwijder images (optioneel)

```bash
docker rmi jenkins/jenkins:lts
docker rmi sampleapp
docker rmi python
```

### Verwijder volumes (optioneel - verliest Jenkins data!)

```bash
docker volume rm jenkins-data
```

## Troubleshooting

### Probleem: "Permission denied" bij Docker commands in Jenkins

**Oplossing:** Zorg dat je Jenkins container met `-u root` draait.

### Probleem: "Port 8080 already in use"

**Oplossing:**
```bash
# Check wat er op poort 8080 draait
sudo lsof -i :8080

# Stop de conflicterende container
docker stop <container-id>
```

### Probleem: "Cannot connect to GitHub repository"

**Oplossing:**
- Controleer of de URL correct is (case-sensitive!)
- Gebruik Personal Access Token, niet je GitHub wachtwoord
- Controleer of de repository bestaat en accessible is

### Probleem: Test faalt met "Connection refused"

**Oplossing:**
```bash
# Check of sample app draait
docker ps | grep samplerunning

# Check of poort 5050 bereikbaar is
curl http://localhost:5050
```

## Belangrijke Concepten

### CI/CD
- **Continuous Integration:** Automatisch code integreren en testen
- **Continuous Deployment:** Automatisch deployments naar productie

### Jenkins Jobs
- **Freestyle Project:** Simpel, configuratie via UI
- **Pipeline:** Code-based (Groovy), version control mogelijk

### Docker-in-Docker
Deze setup draait Docker containers **binnen** een Docker container (Jenkins). Dit is krachtig maar complex!

## Volgende Stappen

Na dit lab kun je:
- [ ] Multi-branch pipelines maken
- [ ] Webhooks toevoegen voor automatische triggers
- [ ] Jenkins plugins verkennen (Blue Ocean UI, etc.)
- [ ] Distributed builds opzetten met Jenkins agents
- [ ] Integration tests toevoegen
- [ ] Deployment naar cloud (AWS, Azure, etc.)

## Referenties

- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)
- [Docker Hub - Jenkins](https://hub.docker.com/r/jenkins/jenkins)
- [GitHub - Creating a Personal Access Token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token)

---

**Experiment voltooid!** 🎉 Je hebt nu een volledige CI/CD pipeline met Jenkins!
