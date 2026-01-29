# Jenkins J1 Lab - Quick Reference Card

## 🔑 Essential Information

**Jenkins URL:** http://localhost:8080
**Initial Admin Password:** `1209674cd427456aae5b3a7a3c184aaf`
**Container Name:** `jenkins_server`

---

## 🚀 Quick Commands

### Jenkins Container Management

```bash
# Start Jenkins
docker run --rm -u root -p 8080:8080 --name jenkins_server \
  --security-opt seccomp=unconfined --ulimit nproc=8192:8192 \
  --ulimit nofile=65535:65535 --pids-limit -1 \
  --dns 8.8.8.8 --dns 1.1.1.1 \
  -v ~/jenkins_home:/var/jenkins_home \
  -v $(which docker):/usr/bin/docker \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$HOME":/home jenkins/jenkins:lts

# Stop Jenkins
docker stop jenkins_server

# Check if running
docker ps | grep jenkins_server

# View logs
docker logs jenkins_server

# Get admin password
docker exec -it jenkins_server cat /var/jenkins_home/secrets/initialAdminPassword
```

### Sample App Container Management

```bash
# Stop sample app
docker stop samplerunning
docker rm samplerunning

# Check if running
docker ps | grep samplerunning

# Test sample app
curl http://localhost:5050
```

---

## 📋 Lab Workflow Checklist

### Part 1: GitHub Setup
- [ ] Create GitHub repository: `sample-app`
- [ ] Init git in `sample-app/` directory
- [ ] Add remote: `git remote add origin https://github.com/USERNAME/sample-app.git`
- [ ] Commit and push: `git add * && git commit -m "Initial commit" && git push -u origin master`

### Part 2: Jenkins Setup
- [ ] Pull Jenkins image: `docker pull jenkins/jenkins:lts`
- [ ] Start Jenkins container (see commands above)
- [ ] Copy initial admin password: `1209674cd427456aae5b3a7a3c184aaf`

### Part 3: Jenkins Configuration
- [ ] Access http://localhost:8080
- [ ] Enter admin password
- [ ] Install suggested plugins
- [ ] Skip admin user creation
- [ ] Save and finish

### Part 4: BuildAppJob
- [ ] Create new Freestyle project: `BuildAppJob`
- [ ] Add Git repository URL
- [ ] Add GitHub credentials (username + PAT)
- [ ] Add build step: `bash ./sample-app.sh`
- [ ] Run build
- [ ] Verify at http://localhost:5050

### Part 5: TestAppJob
- [ ] Create new Freestyle project: `TestAppJob`
- [ ] Add build trigger: after `BuildAppJob`
- [ ] Add build step with curl test
- [ ] Run BuildAppJob to test cascade

### Part 6: SamplePipeline
- [ ] Create new Pipeline: `SamplePipeline`
- [ ] Add Groovy pipeline script
- [ ] Run pipeline
- [ ] Verify all stages complete

---

## 🎯 Key URLs

| Service | URL | Port |
|---------|-----|------|
| Jenkins Dashboard | http://localhost:8080 | 8080 |
| Sample Flask App | http://localhost:5050 | 5050 |

---

## 🔍 Verification Commands

```bash
# Check all Docker containers
docker ps -a

# Check Jenkins is accessible
curl -I http://localhost:8080

# Check sample app is accessible
curl http://localhost:5050

# List Docker images
docker images | grep -E "(jenkins|sample)"

# Check port usage
sudo lsof -i :8080
sudo lsof -i :5050
```

---

## 🐛 Quick Troubleshooting

**Problem:** Port 8080 already in use
```bash
sudo lsof -i :8080
docker stop <conflicting-container>
```

**Problem:** Lost admin password
```bash
docker exec -it jenkins_server cat /var/jenkins_home/secrets/initialAdminPassword
```

**Problem:** Sample app not responding
```bash
docker ps | grep samplerunning
docker logs samplerunning
```

**Problem:** GitHub authentication fails
- Use Personal Access Token (not password)
- Verify repository URL is correct
- Check credentials in Jenkins

---

## 📝 Pipeline Script (Quick Copy)

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

---

## 🧹 Cleanup Commands

```bash
# Stop all containers
docker stop jenkins_server samplerunning
docker rm samplerunning

# Remove images
docker rmi jenkins/jenkins:lts sampleapp python

# Remove volumes (⚠️ loses Jenkins data)
docker volume rm jenkins-data
```

---

**💡 Tip:** Keep this file open in a separate terminal for quick reference during the lab!
