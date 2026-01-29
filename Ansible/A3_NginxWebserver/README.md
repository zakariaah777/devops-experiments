# A3 – Nginx Webserver Deployment (Andere Server)

## Wat doet dit?
Automatische installatie en configuratie van **Nginx webserver** op een **andere server** (192.0.2.4). Nginx is een snelle, lichtgewichte alternatief voor Apache.

## Nginx vs Apache

| Feature | Nginx (192.0.2.4) | Apache (192.0.2.3) |
|---------|-------------------|---------------------|
| **Architectuur** | Event-driven | Process-driven |
| **Performance** | Zeer snel | Snel |
| **Geheugen** | Laag | Hoger |
| **Config** | nginx.conf | .htaccess + httpd.conf |
| **Use Case** | Reverse proxy, static files | Dynamic content, .htaccess |
| **Concurrency** | Excellent (async) | Goed (thread/process) |

## Vereisten
```bash
# SSH server moet draaien
sudo systemctl start ssh
```

## Uitvoeren

### Stap 1: Ga naar de directory
```bash
cd Ansible/A3_NginxWebserver
```

### Stap 2: Test verbinding
```bash
# Ping de nieuwe server
ansible nginxservers -m ping
```

### Stap 3: Deploy Nginx
```bash
ansible-playbook deploy_nginx.yaml
```

### Stap 4: Bekijk in browser
Open je browser: **http://192.0.2.4**

---

## Wat doet de playbook?

```yaml
1. Installeert Nginx webserver
2. Start en enabled Nginx service
3. Verwijdert default Nginx pagina
4. Kopieert custom website files
5. Deployed custom Nginx configuratie (template)
6. Herstart Nginx
```

---

## Bestandsstructuur

```
A3_NginxWebserver/
├── deploy_nginx.yaml        # Ansible playbook
├── hosts                     # Inventory (192.0.2.4)
├── ansible.cfg              # Ansible configuratie
├── files/
│   └── index.html          # Custom Nginx website
├── templates/
│   └── nginx.conf.j2       # Nginx config template
└── README.md               # Deze file
```

---

## Nginx Configuratie Features

De `nginx.conf.j2` template bevat:

✅ **Security Headers**
- X-Frame-Options (clickjacking protection)
- X-Content-Type-Options (MIME sniffing protection)
- X-XSS-Protection (XSS attacks protection)

✅ **Performance Optimizations**
- Gzip compressie voor text files
- Static file caching (1 jaar)
- Optimized buffer settings

✅ **Logging**
- Access logs: `/var/log/nginx/access.log`
- Error logs: `/var/log/nginx/error.log`

---

## Nginx Commando's

### Status controleren
```bash
sudo systemctl status nginx
```

### Nginx herstarten
```bash
sudo systemctl restart nginx
```

### Nginx stoppen
```bash
sudo systemctl stop nginx
```

### Configuratie testen
```bash
sudo nginx -t
```

### Nginx herladen (zonder downtime)
```bash
sudo nginx -s reload
```

### Logs bekijken
```bash
# Access logs
sudo tail -f /var/log/nginx/access.log

# Error logs
sudo tail -f /var/log/nginx/error.log
```

---

## Verschil met Apache (A1/A2)

### Apache (Server 192.0.2.3)
```bash
sudo systemctl status apache2
sudo apache2ctl -t
/var/log/apache2/
```

### Nginx (Server 192.0.2.4)
```bash
sudo systemctl status nginx
sudo nginx -t
/var/log/nginx/
```

---

## Multi-Server Setup

Nu heb je **2 webservers** draaiend:

| Server | IP | Webserver | URL |
|--------|-----|-----------|-----|
| Server 1 | 192.0.2.3 | Apache | http://192.0.2.3 |
| Server 2 | 192.0.2.4 | Nginx | http://192.0.2.4 |

**Test beide:**
```bash
# Apache
curl http://192.0.2.3

# Nginx
curl http://192.0.2.4
```

---

## Website aanpassen

### Custom content toevoegen
Bewerk `files/index.html` en run:
```bash
ansible-playbook deploy_nginx.yaml
```

### Nginx configuratie wijzigen
Bewerk `templates/nginx.conf.j2` en run:
```bash
ansible-playbook deploy_nginx.yaml
```

---

## Waarom Nginx gebruiken?

✅ **Snelheid** - Event-driven = sneller bij veel connecties
✅ **Lichtgewicht** - Minder geheugen dan Apache
✅ **Reverse Proxy** - Perfect voor load balancing
✅ **Async** - Handelt duizenden connecties tegelijk af
✅ **Modern** - Gebouwd voor moderne web applicaties

---

## Populaire Nginx Use Cases

1. **Reverse Proxy** - Voor load balancing
2. **Static Files** - Zeer snel serving van CSS/JS/images
3. **API Gateway** - Centraal entry point
4. **SSL Termination** - HTTPS handling
5. **Caching** - HTTP response caching
6. **Media Streaming** - Video/audio streaming

---

## Troubleshooting

**Probleem:** Nginx start niet
**Oplossing:**
```bash
# Test configuratie
sudo nginx -t

# Bekijk error logs
sudo tail -20 /var/log/nginx/error.log
```

**Probleem:** Website niet zichtbaar
**Oplossing:**
```bash
# Check Nginx status
sudo systemctl status nginx

# Check of Nginx luistert op poort 80
sudo netstat -tulpn | grep nginx
```

**Probleem:** Permission denied
**Oplossing:**
```bash
# Check file permissies
ls -la /var/www/html/

# Fix permissies (playbook doet dit automatisch)
sudo chown -R www-data:www-data /var/www/html/
```

---

## Advanced: Nginx als Reverse Proxy

Wil je Nginx gebruiken als reverse proxy voor Apache?

Bewerk `templates/nginx.conf.j2`:
```nginx
location / {
    proxy_pass http://192.0.2.3:80;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
}
```

Dan stuurt Nginx (192.0.2.4) alle traffic door naar Apache (192.0.2.3)!

---

## Vergelijking met A1 en A2

- **A1** - Apache installatie (poort 8081)
- **A2** - Apache met custom portfolio website
- **A3** - Nginx op andere server (deze!)

**Geleerd:**
✅ Hoe je verschillende servers beheert
✅ Verschil tussen Nginx en Apache
✅ Jinja2 templates voor configuratie
✅ Multi-server deployment met Ansible

---

## Extra Resources

- **Nginx Documentatie:** https://nginx.org/en/docs/
- **Nginx vs Apache:** Nginx is beter voor static content en reverse proxy
- **Performance Testing:** Gebruik `ab` (Apache Bench) om te testen

Test performance:
```bash
# Test Nginx
ab -n 1000 -c 10 http://192.0.2.4/

# Test Apache
ab -n 1000 -c 10 http://192.0.2.3/
```

Nginx is vaak **sneller** bij veel gelijktijdige requests! 🚀
