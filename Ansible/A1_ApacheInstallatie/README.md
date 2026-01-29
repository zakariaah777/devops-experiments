# A1 – Ansible Apache Webserver Installatie

## Wat doet dit?
Ansible playbooks om **Apache webserver** automatisch te installeren en configureren. Gebaseerd op **Lab 7.4.8** uit de NetAcad DevOps cursus.

## Vereisten
```bash
# Start SSH server (als deze nog niet draait)
sudo systemctl start ssh

# Installeer sshpass (als nog niet geïnstalleerd)
sudo apt-get install sshpass
```

## Uitvoeren

### Stap 1: Ga naar de directory
```bash
cd Ansible/A1_ApacheInstallatie
```

### Stap 2: Test communicatie met webserver
```bash
# Ping test
ansible webservers -m ping

# Echo test
ansible webservers -m command -a "/bin/echo hello world"
```

### Stap 3: Test playbook uitvoeren
```bash
ansible-playbook -v test_apache_playbook.yaml
```

### Stap 4: Apache installeren (basis)
```bash
ansible-playbook -v install_apache_playbook.yaml
```

**Controleer in browser:** `http://192.0.2.3`

### Stap 5: Apache installeren met custom port
```bash
ansible-playbook install_apache_options_playbook.yaml
```

**Controleer in browser:** `http://192.0.2.3:8081`

---

## Playbooks Uitleg

### 1. test_apache_playbook.yaml
- Test of Ansible kan communiceren met de webserver
- Voert simpel echo commando uit

### 2. install_apache_playbook.yaml
- Installeert Apache2
- Activeert mod_rewrite module
- Herstart Apache automatisch

### 3. install_apache_options_playbook.yaml
- Installeert Apache2
- Configureert Apache om te luisteren op **poort 8081** (ipv 80)
- Past `/etc/apache2/ports.conf` en `000-default.conf` aan
- Herstart Apache automatisch

---

## Status Controleren

```bash
# Apache status bekijken
sudo systemctl status apache2

# Welke poorten luisteren
cat /etc/apache2/ports.conf | grep Listen

# VirtualHost configuratie
cat /etc/apache2/sites-available/000-default.conf | grep VirtualHost
```

---

## Bestanden Overzicht

- **hosts** - Ansible inventory (webserver: 192.0.2.3)
- **ansible.cfg** - Ansible configuratie
- **test_apache_playbook.yaml** - Test playbook
- **install_apache_playbook.yaml** - Installeer Apache (poort 80)
- **install_apache_options_playbook.yaml** - Installeer Apache (poort 8081)

---

## Troubleshooting

**Probleem:** SSH verbinding mislukt
**Oplossing:** `sudo systemctl start ssh`

**Probleem:** Permission denied
**Oplossing:** Playbook gebruikt `become: yes` voor sudo rechten

**Probleem:** Apache niet bereikbaar
**Oplossing:** Controleer firewall of Apache status met `sudo systemctl status apache2`

---

## Extra Info

**Wat is een Handler?**
Handlers worden alleen uitgevoerd wanneer een task verandert (notify). In deze playbooks herstart de handler Apache alleen als er configuratie wijzigingen zijn.

**Wat doet lineinfile?**
De `lineinfile` module zoekt een regel in een bestand en vervangt deze. Handig voor configuratie aanpassen zonder hele bestanden te overschrijven.
