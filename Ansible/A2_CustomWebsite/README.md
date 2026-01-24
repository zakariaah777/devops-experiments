# A2 – Custom Website Deployment met Ansible

## Wat doet dit?
Automatische deployment van een **professionele portfolio website** met Ansible. Inclusief meerdere pagina's, responsive design en moderne styling.

## Website Features
- ✅ **Home pagina** met hero section en skills overzicht
- ✅ **Over Mij pagina** met opleiding en ervaring
- ✅ **Projecten pagina** met alle DevOps projecten
- ✅ Responsive design (werkt op mobiel)
- ✅ Moderne gradient kleuren en animaties
- ✅ Volledig automatisch gedeployed!

## Vereisten
```bash
# SSH server moet draaien
sudo systemctl start ssh
```

## Uitvoeren

### Stap 1: Ga naar de directory
```bash
cd Ansible/A2_CustomWebsite
```

### Stap 2: Deploy de website
```bash
ansible-playbook deploy_website.yaml
```

### Stap 3: Bekijk in browser
Open je browser en ga naar: **http://192.0.2.3**

---

## Wat doet de playbook?

```yaml
1. Installeert Apache2 webserver
2. Start Apache service
3. Verwijdert de default Apache pagina
4. Kopieert alle website bestanden naar /var/www/html/
   - index.html (homepage)
   - about.html (over mij)
   - projects.html (projecten)
   - style.css (styling)
5. Zet correcte permissies (www-data)
6. Herstart Apache
```

---

## Bestandsstructuur

```
A2_CustomWebsite/
├── deploy_website.yaml      # Ansible playbook
├── hosts                     # Inventory file
├── ansible.cfg              # Ansible configuratie
├── files/                   # Website bestanden
│   ├── index.html          # Homepage
│   ├── about.html          # Over mij pagina
│   ├── projects.html       # Projecten pagina
│   └── style.css           # CSS styling
└── README.md               # Deze file
```

---

## Website Pagina's

### 1. Home (index.html)
- Hero section met naam en titel
- Skills overzicht (Python, Ansible, Docker, Cloud)
- Locatie informatie
- Call-to-action buttons

### 2. Over Mij (about.html)
- Persoonlijke introductie
- Opleiding en certificaten
- Werkervaring
- Technologie stack (tags)
- Contact informatie

### 3. Projecten (projects.html)
- Ansible automation projecten
- Python & REST API projecten
- Project details en features
- Statistieken overzicht

---

## Aanpassen van de Website

### Je eigen informatie toevoegen:

**1. Naam en locatie wijzigen:**
Bewerk `files/index.html` en `files/about.html`:
```html
<!-- Zoek en vervang: -->
Zakaria Ahmaddouch → Jouw Naam
Brussel → Jouw Stad
```

**2. Skills aanpassen:**
Bewerk `files/index.html` in de skills sectie:
```html
<div class="skill-card">
    <div class="skill-icon">🚀</div>
    <h3>Jouw Skill</h3>
    <p>Beschrijving</p>
</div>
```

**3. Projecten toevoegen:**
Bewerk `files/projects.html`:
```html
<div class="project-card">
    <div class="project-header">
        <h3>Project Naam</h3>
        <span class="badge">Technologie</span>
    </div>
    <p>Project beschrijving</p>
    <ul class="project-features">
        <li>Feature 1</li>
        <li>Feature 2</li>
    </ul>
</div>
```

**4. Kleuren wijzigen:**
Bewerk `files/style.css`:
```css
/* Zoek: */
background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);

/* Vervang met jouw kleuren: */
background: linear-gradient(135deg, #jouwkleur1 0%, #jouwkleur2 100%);
```

### Na aanpassingen:
```bash
# Deploy opnieuw
ansible-playbook deploy_website.yaml
```

---

## Troubleshooting

**Probleem:** Website niet zichtbaar
**Oplossing:**
```bash
# Controleer Apache status
sudo systemctl status apache2

# Herstart Apache
sudo systemctl restart apache2
```

**Probleem:** Oude versie van de website
**Oplossing:**
```bash
# Verwijder browser cache (Ctrl+Shift+R in browser)
# OF run playbook opnieuw
ansible-playbook deploy_website.yaml
```

**Probleem:** Permissie errors
**Oplossing:**
Het playbook zet automatisch de juiste permissies (www-data). Check:
```bash
ls -la /var/www/html/
```

---

## Extra Commando's

```bash
# Test Apache configuratie
sudo apache2ctl -t

# Bekijk Apache logs
sudo tail -f /var/log/apache2/error.log

# Handmatig bestanden controleren
ls -la /var/www/html/

# Apache herstarten
sudo systemctl restart apache2
```

---

## Wat maakt dit project uniek?

1. **Volledige Automatisering** - 1 commando deployed alles
2. **Professioneel Design** - Moderne gradient UI
3. **Multi-page Website** - Niet slechts 1 pagina
4. **Responsive** - Werkt op alle schermformaten
5. **Makkelijk Aanpasbaar** - HTML/CSS zijn duidelijk gestructureerd
6. **Production Ready** - Correcte permissies en configuratie

---

## Volgende Stappen

Wil je meer doen met deze website?

- ✅ Voeg een contact formulier toe
- ✅ Integreer met een database
- ✅ Voeg JavaScript functionaliteit toe
- ✅ Deploy naar een echte server (AWS, DigitalOcean)
- ✅ Voeg HTTPS toe (SSL certificaat)
- ✅ Maak er een dynamische site van (PHP/Python backend)

**De basis staat nu met Ansible!** 🚀
