# Jenkins Setup Notes - J1 Lab Experiment

## Setup Session: 2026-01-28

### Jenkins Container Started Successfully

**Date/Time:** 2026-01-28 10:03:44 UTC

**Docker Command Used:**
```bash
docker run --rm -u root \
  -p 8080:8080 \
  --name jenkins_server \
  --security-opt seccomp=unconfined \
  --ulimit nproc=8192:8192 \
  --ulimit nofile=65535:65535 \
  --pids-limit -1 \
  --dns 8.8.8.8 --dns 1.1.1.1 \
  -v ~/jenkins_home:/var/jenkins_home \
  -v $(which docker):/usr/bin/docker \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v "$HOME":/home \
  jenkins/jenkins:lts
```

### Jenkins Information

- **Version:** Jenkins 2.541.1
- **Jetty Version:** 12.1.5
- **JVM:** 21.0.9+10-LTS
- **Docker Image:** jenkins/jenkins:lts
- **Image Digest:** sha256:d1ea795c6facd7f549a21c40e5e43ffcc5fbc5f48683d9b24750f26e8079d772

### Initial Admin Password

**Password:** `1209674cd427456aae5b3a7a3c184aaf`

**Alternative location:** `/var/jenkins_home/secrets/initialAdminPassword`

To retrieve password later (if needed):
```bash
docker exec -it jenkins_server cat /var/jenkins_home/secrets/initialAdminPassword
```

### Access Information

- **Jenkins URL:** http://localhost:8080
- **Status:** Fully up and running ✅
- **Initialization:** Completed successfully at 2026-01-28 10:03:52 UTC

### Container Configuration Details

**Security Options:**
- Running as root user (`-u root`)
- Seccomp unconfined for Docker operations
- Process limit: 8192
- File descriptor limit: 65535
- Unlimited PIDs

**DNS Configuration:**
- Primary DNS: 8.8.8.8 (Google)
- Secondary DNS: 1.1.1.1 (Cloudflare)

**Volume Mounts:**
1. `~/jenkins_home` → `/var/jenkins_home` (Jenkins data persistence)
2. Docker binary → `/usr/bin/docker` (Docker-in-Docker capability)
3. `/var/run/docker.sock` → `/var/run/docker.sock` (Docker daemon access)
4. `$HOME` → `/home` (Host home directory access)

### Startup Log Summary

```
✓ War file extraction completed
✓ Jetty server started on port 8080
✓ Session manager initialized
✓ Jenkins home directory: /var/jenkins_home
✓ All plugins prepared and started
✓ System configuration loaded
✓ Initialization completed
✓ Update server check successful
```

### Next Steps

1. ✅ Jenkins container started
2. ⏭️ Access Jenkins at http://localhost:8080
3. ⏭️ Enter initial admin password: `1209674cd427456aae5b3a7a3c184aaf`
4. ⏭️ Install suggested plugins
5. ⏭️ Configure admin user
6. ⏭️ Create BuildAppJob (see README.md Part 4)
7. ⏭️ Create TestAppJob (see README.md Part 5)
8. ⏭️ Create SamplePipeline (see README.md Part 6)

### Important Commands

**Check Jenkins status:**
```bash
docker ps | grep jenkins_server
```

**View Jenkins logs:**
```bash
docker logs jenkins_server
```

**Stop Jenkins:**
```bash
docker stop jenkins_server
```

**Restart Jenkins:**
```bash
# Run the docker run command again from above
```

**Access Jenkins container:**
```bash
docker exec -it jenkins_server /bin/bash
```

### Troubleshooting Reference

If you encounter issues, refer to the Troubleshooting section in README.md:
- Permission denied errors
- Port conflicts
- GitHub connection issues
- Test failures

---

**Status:** Ready for configuration! Proceed to http://localhost:8080 to continue setup.
