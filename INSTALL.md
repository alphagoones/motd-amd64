# Guide d'installation MOTD-AMD64

Ce guide détaille les différentes méthodes d'installation de MOTD-AMD64 pour architectures x86_64/AMD64.

## Prérequis

### Système requis
- **Architecture** : x86_64/AMD64
- **OS** : Debian, Ubuntu, Linux Mint, ou dérivés
- **Privilèges** : Accès root/sudo
- **Espace disque** : ~100MB pour l'installation complète
- **RAM** : Minimum 512MB

### Packages requis
Les packages suivants seront installés automatiquement :
- `figlet` - Génération de texte ASCII art
- `bc` - Calculatrice pour les calculs
- `dialog` - Interface de configuration interactive
- `curl` - Téléchargement de fichiers
- `lm-sensors` - Monitoring température CPU
- `lolcat` - Effets de couleurs (optionnel)
- `neofetch` - Informations système (optionnel)

## Méthodes d'installation

### 1. Installation rapide (recommandée)

#### Installation serveur
```bash
# Configuration optimisée pour serveurs
curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/scripts/quick-setup.sh | bash -s -- --server
```

#### Installation station de travail
```bash
# Configuration optimisée pour desktop/workstation
curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/scripts/quick-setup.sh | bash -s -- --workstation
```

#### Installation interactive
```bash
# Configuration personnalisée
curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/scripts/quick-setup.sh | bash
```

### 2. Installation depuis le dépôt Git

```bash
# Cloner le dépôt
git clone https://github.com/alphagoones/motd-amd64.git
cd motd-amd64

# Installation interactive complète
sudo ./scripts/install.sh

# Ou installation avec Make
make install
```

### 3. Installation depuis un package .deb

```bash
# Télécharger le package .deb depuis les releases
wget https://github.com/alphagoones/motd-amd64/releases/latest/download/motd-amd64_1.0.0_amd64.deb

# Installer le package
sudo dpkg -i motd-amd64_1.0.0_amd64.deb

# Résoudre les dépendances si nécessaire
sudo apt-get install -f

# Lancer la configuration
sudo motd-amd64-install --configure
```

### 4. Installation avancée avec options

```bash
# Installation minimale
curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/scripts/quick-setup.sh | bash -s -- --minimal

# Installation complète
curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/scripts/quick-setup.sh | bash -s -- --full

# Installation avec thème spécifique
curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/scripts/quick-setup.sh | bash -s -- --server --theme=blue
```

## Configurations prédéfinies

### Configuration Serveur
- **Thème** : Bleu professionnel
- **Hostname** : Affiché en grand
- **Informations** : Système, architecture, noyau, uptime, charge, mémoire, disque, IP, température, utilisateurs, connexions, mises à jour
- **Services** : SSH, Apache2, Nginx, Docker, PostgreSQL, MySQL, Redis, Fail2Ban, UFW

### Configuration Station de Travail
- **Thème** : Violet moderne
- **Hostname** : Affiché en grand
- **Informations** : Système, architecture, noyau, uptime, charge, mémoire, disque, IP, température, GPU, utilisateurs
- **Services** : SSH, Docker, Nginx

### Configuration Minimale
- **Thème** : Vert simple
- **Hostname** : Masqué
- **Informations** : Système, uptime, mémoire, disque, charge
- **Services** : SSH uniquement

### Configuration Complète
- **Thème** : Multicolore
- **Hostname** : Affiché en grand
- **Informations** : Toutes disponibles
- **Services** : Tous les services détectés

## Configuration durant l'installation

### 1. Affichage du hostname
L'installateur vous demande si vous souhaitez afficher le hostname en grand dans le MOTD.

**Recommandation** : 
- **Serveurs** : Oui (identification rapide)
- **Stations de travail** : Oui (personnalisation)
- **Serveurs légers** : Non (économie d'espace)

### 2. Sélection des informations système

Vous pouvez choisir quelles informations afficher :

- ✅ **Système** - Distribution et version
- ✅ **Architecture** - Type de processeur (x86_64)
- ✅ **Noyau** - Version du kernel Linux
- ✅ **Uptime** - Temps de fonctionnement
- ✅ **Charge** - Load average du système
- ✅ **Mémoire** - Utilisation RAM
- ✅ **Disque** - Utilisation stockage
- ✅ **IP** - Adresse IP locale
- ✅ **Température** - Température CPU via lm-sensors
- ✅ **GPU** - Informations carte graphique
- ✅ **Utilisateurs** - Utilisateurs connectés
- ✅ **Lastlog** - Dernières connexions
- ✅ **Mises à jour** - Updates disponibles

### 3. Sélection des services à surveiller

L'installateur détecte automatiquement les services installés :

**Services serveur courants :**
- `ssh` - Serveur SSH
- `apache2` - Serveur web Apache
- `nginx` - Serveur web Nginx
- `docker` - Conteneurisation Docker
- `postgresql` - Base de données PostgreSQL
- `mysql` - Base de données MySQL
- `mariadb` - Base de données MariaDB
- `redis` - Cache Redis
- `mongodb` - Base de données MongoDB
- `elasticsearch` - Moteur de recherche
- `grafana` - Visualisation de données
- `prometheus` - Monitoring
- `fail2ban` - Protection contre les intrusions
- `ufw` - Pare-feu Ubuntu

### 4. Choix du thème de couleurs

Cinq thèmes sont disponibles :

- **Défaut** (multicolore) - Cyan/Jaune/Vert/Rouge
- **Bleu** - Professionnel, idéal serveurs
- **Vert** - Style Matrix, moderne
- **Rouge** - Serveurs critiques, alertes
- **Violet** - Moderne, stations de travail

## Configuration post-installation

### Structure des fichiers créés

```
/etc/motd-amd64/
├── config              # Configuration générale (thème, hostname)
├── system_info         # Liste des infos système activées
└── services           # Liste des services surveillés

/etc/update-motd.d/
├── 00-motd-amd64      # Script principal MOTD
└── 10-motd-services   # Script surveillance services

/usr/local/bin/
├── motd-amd64-install      # Script d'installation (si package .deb)
└── motd-amd64-quick-setup  # Script d'installation rapide
```

### Configuration des capteurs de température

```bash
# Détecter automatiquement les capteurs
sudo sensors-detect

# Répondre "YES" à toutes les questions pour une détection complète

# Tester les capteurs
sensors

# Configuration avancée (optionnel)
sudo nano /etc/sensors3.conf
```

### Optimisation GPU

#### Pour cartes NVIDIA
```bash
# Installer les utilitaires NVIDIA
sudo apt install nvidia-utils-*

# Tester
nvidia-smi
```

#### Pour cartes AMD
```bash
# Installer les utilitaires Mesa
sudo apt install mesa-utils

# Tester
lspci | grep -i vga
```

### Personnalisation avancée

#### Modifier les informations affichées
```bash
# Éditer les informations système
sudo nano /etc/motd-amd64/system_info

# Ajouter/retirer des éléments (un par ligne)
system
arch
kernel
uptime
load
memory
disk
ip
temp
gpu
users
lastlog
updates
```

#### Modifier les services surveillés
```bash
# Éditer la liste des services
sudo nano /etc/motd-amd64/services

# Ajouter un service personnalisé
echo "mon-service" | sudo tee -a /etc/motd-amd64/services

# Services typiques pour serveurs web
echo -e "apache2\nnginx\nmysql\npostgresql\nredis" | sudo tee /etc/motd-amd64/services

# Services typiques pour serveurs de développement
echo -e "ssh\ndocker\ngitlab-runner\njenkins\nnginx" | sudo tee /etc/motd-amd64/services
```

#### Changer le thème
```bash
# Éditer la configuration
sudo nano /etc/motd-amd64/config

# Modifier la ligne THEME
THEME=blue    # ou green, red, purple, default
```

## Commandes utiles

### Gestion de base
```bash
# Tester le MOTD
sudo run-parts /etc/update-motd.d/

# Reconfigurer
sudo /path/to/install.sh --configure
# ou si package installé
sudo motd-amd64-install --configure

# Désinstaller
sudo /path/to/install.sh --uninstall
# ou si package installé
sudo motd-amd64-install --uninstall
```

### Avec Make (si installé depuis Git)
```bash
# Installation
make install
make install-server       # Configuration serveur
make install-workstation  # Configuration station de travail
make install-minimal      # Configuration minimale

# Tests
make test                 # Test MOTD
make test-sensors         # Test capteurs température
make test-gpu            # Test détection GPU
make benchmark           # Benchmark temps d'affichage

# Gestion
make configure           # Reconfigurer
make status             # Statut installation
make info               # Informations système
make backup             # Sauvegarder config
make restore BACKUP=file # Restaurer config

# Développement
make lint               # Vérifier syntaxe
make clean              # Nettoyer
make package            # Créer package
make deb                # Créer package .deb
```

## Dépannage d'installation

### Erreur : "Architecture non supportée"
```bash
# Vérifier l'architecture
uname -m
# Doit afficher : x86_64

# Si architecture différente
echo "Cette version est optimisée pour x86_64"
echo "Utilisez MOTD-AARCH64 pour ARM64"
```

### Erreur : "Packages non trouvés"
```bash
# Mettre à jour les sources
sudo apt update

# Installer manuellement les dépendances
sudo apt install figlet bc dialog curl lm-sensors
```

### Erreur : "lm-sensors non configuré"
```bash
# Installer et configurer lm-sensors
sudo apt install lm-sensors
sudo sensors-detect

# Redémarrer pour charger les modules
sudo reboot

# Tester
sensors
```

### MOTD ne s'affiche pas
```bash
# Vérifier les scripts MOTD
ls -la /etc/update-motd.d/

# Réparer les permissions
sudo chmod +x /etc/update-motd.d/00-motd-amd64
sudo chmod +x /etc/update-motd.d/10-motd-services

# Tester manuellement
sudo run-parts /etc/update-motd.d/
```

### Services non détectés
```bash
# Lister tous les services
systemctl list-unit-files --type=service

# Vérifier un service spécifique
systemctl status nom-du-service

# Ajouter manuellement un service
echo "mon-service" | sudo tee -a /etc/motd-amd64/services
```

### Température non affichée

#### Problème de détection
```bash
# Réinstaller et reconfigurer lm-sensors
sudo apt purge lm-sensors
sudo apt install lm-sensors
sudo sensors-detect --auto

# Charger les modules manuellement
sudo modprobe coretemp
sudo modprobe k10temp  # Pour AMD

# Tester
sensors
```

#### Serveurs Dell/HP/IBM
```bash
# Installer les outils IPMI
sudo apt install ipmitool

# Tester IPMI
sudo ipmitool sensor list | grep -i temp
```

### GPU non détecté

#### Carte NVIDIA
```bash
# Vérifier les drivers
nvidia-smi

# Si pas installé
sudo apt install nvidia-driver-* nvidia-utils-*
```

#### Carte AMD
```bash
# Vérifier la détection
lspci | grep -i amd
lspci | grep -i radeon

# Installer les drivers si nécessaire
sudo apt install mesa-utils
```

### Performance lente
```bash
# Benchmark du MOTD
make benchmark

# Si > 1000ms, désactiver certaines infos
sudo nano /etc/motd-amd64/system_info
# Retirer : gpu, temp, lastlog
```

## Désinstallation

### Désinstallation complète
```bash
# Avec le script d'installation
sudo ./scripts/install.sh --uninstall

# Ou avec Make
make uninstall

# Ou si package .deb installé
sudo apt remove motd-amd64
```

### Désinstallation manuelle
```bash
# Supprimer les scripts MOTD
sudo rm -f /etc/update-motd.d/00-motd-amd64
sudo rm -f /etc/update-motd.d/10-motd-services

# Supprimer la configuration
sudo rm -rf /etc/motd-amd64

# Supprimer les binaires (si package)
sudo rm -f /usr/local/bin/motd-amd64-*

# Réactiver l'ancien MOTD (optionnel)
sudo chmod +x /etc/update-motd.d/*
```

## Configurations d'exemple

### Serveur web LAMP
```bash
# Configuration optimisée LAMP
sudo tee /etc/motd-amd64/services << EOF
ssh
apache2
mysql
ufw
fail2ban
EOF

### Serveur web LAMP
```bash
# Configuration optimisée LAMP
sudo tee /etc/motd-amd64/services << EOF
ssh
apache2
mysql
ufw
fail2ban
EOF

sudo tee /etc/motd-amd64/system_info << EOF
system
uptime
load
memory
disk
ip
temp
users
updates
EOF
```

### Serveur Docker/Kubernetes
```bash
# Configuration pour conteneurisation
sudo tee /etc/motd-amd64/services << EOF
ssh
docker
nginx
postgresql
redis
grafana
prometheus
EOF

sudo tee /etc/motd-amd64/system_info << EOF
system
arch
kernel
uptime
load
memory
disk
ip
temp
users
EOF
```

### Station de travail développeur
```bash
# Configuration développeur
sudo tee /etc/motd-amd64/services << EOF
ssh
docker
nginx
postgresql
redis
EOF

sudo tee /etc/motd-amd64/system_info << EOF
system
arch
kernel
uptime
memory
disk
ip
temp
gpu
users
EOF

# Thème violet
sudo sed -i 's/THEME=.*/THEME=purple/' /etc/motd-amd64/config
```

### Serveur de base de données
```bash
# Configuration serveur BDD
sudo tee /etc/motd-amd64/services << EOF
ssh
postgresql
mysql
redis
mongodb
ufw
fail2ban
EOF

sudo tee /etc/motd-amd64/system_info << EOF
system
uptime
load
memory
disk
temp
users
lastlog
updates
EOF
```

## Optimisations spécifiques

### Serveurs haute performance
```bash
# Désactiver les éléments coûteux
sudo tee /etc/motd-amd64/system_info << EOF
system
uptime
memory
disk
EOF

# Pas de GPU ni température pour économiser du temps
```

### Serveurs avec RAID
```bash
# Affichage disque personnalisé
# Modifier le script pour afficher tous les disques
sudo nano /etc/update-motd.d/00-motd-amd64

# Ajouter après la ligne DISK=...
DISK_RAID=$(df -h | grep -E "/(md|raid)" | awk '{print $1 ": " $3"/"$2" ("$5")"}' | tr '\n' ', ' | sed 's/, $//')
if [[ -n "$DISK_RAID" ]]; then
    create_line "RAID" "$DISK_RAID"
fi
```

### Monitoring avancé
```bash
# Ajouter des métriques personnalisées
sudo tee -a /etc/update-motd.d/00-motd-amd64 << 'EOF'

# Métriques personnalisées
if is_enabled "network"; then
    NETWORK_USAGE=$(cat /proc/net/dev | grep eth0 | awk '{print "RX: " $2/1024/1024 "MB TX: " $10/1024/1024 "MB"}')
    [[ -n "$NETWORK_USAGE" ]] && create_line "Réseau" "$NETWORK_USAGE"
fi

if is_enabled "processes"; then
    PROCESS_COUNT=$(ps aux | wc -l)
    create_line "Processus" "$PROCESS_COUNT"
fi
EOF

# Ajouter ces options à system_info
echo -e "network\nprocesses" | sudo tee -a /etc/motd-amd64/system_info
```

## Intégration avec monitoring

### Prometheus/Grafana
```bash
# Script pour exporter métriques vers Prometheus
sudo tee /usr/local/bin/motd-metrics << 'EOF'
#!/bin/bash
# Export des métriques MOTD vers Prometheus

METRICS_FILE="/var/lib/prometheus/node-exporter/motd-metrics.prom"
mkdir -p $(dirname "$METRICS_FILE")

# Récupérer les métriques
UPTIME_SECONDS=$(awk '{print $1}' /proc/uptime)
LOAD_1MIN=$(uptime | awk -F'load average:' '{print $2}' | awk -F',' '{print $1}' | tr -d ' ')
MEMORY_USED=$(free | awk '/^Mem:/ {print $3}')
MEMORY_TOTAL=$(free | awk '/^Mem:/ {print $2}')

# Générer le fichier métriques
cat > "$METRICS_FILE" << EOL
# HELP motd_uptime_seconds System uptime in seconds
# TYPE motd_uptime_seconds gauge
motd_uptime_seconds $UPTIME_SECONDS

# HELP motd_load_1min System load average 1 minute
# TYPE motd_load_1min gauge
motd_load_1min $LOAD_1MIN

# HELP motd_memory_used_bytes Memory used in bytes
# TYPE motd_memory_used_bytes gauge
motd_memory_used_bytes $((MEMORY_USED * 1024))

# HELP motd_memory_total_bytes Memory total in bytes
# TYPE motd_memory_total_bytes gauge
motd_memory_total_bytes $((MEMORY_TOTAL * 1024))
EOL
EOF

chmod +x /usr/local/bin/motd-metrics

# Crontab pour mise à jour régulière
echo "*/5 * * * * /usr/local/bin/motd-metrics" | sudo crontab -
```

### Alerting automatique
```bash
# Script d'alerte si température > 80°C
sudo tee /usr/local/bin/motd-temp-alert << 'EOF'
#!/bin/bash

TEMP_THRESHOLD=80
EMAIL="admin@example.com"

if command -v sensors &> /dev/null; then
    TEMP=$(sensors | grep -E "Core 0|Package id 0|Tctl" | head -1 | grep -oE '\+[0-9]+' | head -1 | tr -d '+')
    
    if [[ -n "$TEMP" ]] && [[ $TEMP -gt $TEMP_THRESHOLD ]]; then
        echo "ALERTE: Température CPU élevée: ${TEMP}°C" | mail -s "Alerte température $(hostname)" "$EMAIL"
    fi
fi
EOF

chmod +x /usr/local/bin/motd-temp-alert

# Crontab pour vérification température
echo "*/10 * * * * /usr/local/bin/motd-temp-alert" | sudo crontab -
```

## Support et maintenance

### Logs de débogage
```bash
# Activer le mode debug
export MOTD_DEBUG=1
sudo run-parts /etc/update-motd.d/

# Logs détaillés
sudo journalctl -f | grep motd
```

### Mise à jour
```bash
# Vérifier les mises à jour
curl -s https://api.github.com/repos/alphagoones/motd-amd64/releases/latest | grep tag_name

# Mise à jour automatique
git pull origin main
sudo ./scripts/install.sh --configure
```

### Sauvegarde automatique
```bash
# Script de sauvegarde quotidienne
sudo tee /etc/cron.daily/motd-backup << 'EOF'
#!/bin/bash
BACKUP_DIR="/var/backups/motd-amd64"
mkdir -p "$BACKUP_DIR"

tar -czf "$BACKUP_DIR/motd-config-$(date +%Y%m%d).tar.gz" \
    /etc/motd-amd64/ \
    /etc/update-motd.d/00-motd-amd64 \
    /etc/update-motd.d/10-motd-services

# Garder seulement les 7 dernières sauvegardes
find "$BACKUP_DIR" -name "motd-config-*.tar.gz" -mtime +7 -delete
EOF

chmod +x /etc/cron.daily/motd-backup
```

## FAQ

### Q: Puis-je utiliser MOTD-AMD64 avec MOTD-AARCH64 ?
A: Non, ils sont conçus pour des architectures différentes. Utilisez MOTD-AMD64 pour x86_64 et MOTD-AARCH64 pour ARM64.

### Q: Impact sur les performances ?
A: Minimal (< 100ms), mais peut être optimisé en désactivant GPU et température pour les serveurs critiques.

### Q: Compatible avec cloud (AWS, Azure, GCP) ?
A: Oui, totalement compatible. Configurations serveur recommandées pour instances cloud.

### Q: Fonctionne avec containers Docker ?
A: Oui, mais le MOTD ne s'affiche que lors de connexion SSH sur l'hôte, pas dans les containers.

### Q: Support CentOS/RHEL ?
A: Non, optimisé pour Debian/Ubuntu uniquement. Port vers RPM prévu pour version future.

---

**Support** : https://github.com/alphagoones/motd-amd64/issues
