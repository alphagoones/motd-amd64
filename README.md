# MOTD-AMD64

Un système MOTD (Message of the Day) moderne et configurable spécialement conçu pour les architectures x86_64/AMD64.

## Fonctionnalités

- 🎨 **Interface moderne** avec bordures et couleurs personnalisables
- 🔧 **Configuration interactive** via menu graphique
- 📊 **Informations système** complètes (CPU, mémoire, disque, température)
- 🛠️ **Surveillance des services** configurable
- 🌈 **5 thèmes de couleurs** multiples
- 🖥️ **Optimisé pour AMD64** (serveurs Intel/AMD, stations de travail)
- 🎮 **Support GPU** (NVIDIA, AMD, Intel)
- 🌡️ **Monitoring température** avancé via lm-sensors

## Installation

### Installation standard (recommandée)

```bash
# Installation interactive complète
curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/install.sh | sudo bash
```

### Installation rapide avec configurations prédéfinies

```bash
# Configuration serveur (Apache, MySQL, Docker...)
curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/scripts/quick-setup.sh | sudo bash -s -- --server

# Configuration station de travail (GPU, développement...)
curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/scripts/quick-setup.sh | sudo bash -s -- --workstation

# Configuration minimale (serveurs légers)
curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/scripts/quick-setup.sh | sudo bash -s -- --minimal

# Configuration complète (toutes les options)
curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/scripts/quick-setup.sh | sudo bash -s -- --full
```

### Installation depuis le dépôt Git

```bash
# Cloner le dépôt
git clone https://github.com/alphagoones/motd-amd64.git
cd motd-amd64

# Installation interactive
sudo ./install.sh

# Ou avec Make
make install
```

## Utilisation

### Commandes de base
```bash
# Installation complète
sudo ./install.sh

# Reconfiguration
sudo ./install.sh --configure

# Désinstallation
sudo ./install.sh --uninstall

# Test manuel
sudo run-parts /etc/update-motd.d/
```

### Commandes Make avancées
```bash
# Installations spécialisées
make install-server        # Configuration serveur
make install-workstation   # Configuration station de travail
make install-minimal       # Configuration minimale

# Tests et diagnostics
make test                   # Test du MOTD
make test-sensors          # Test capteurs température
make test-gpu              # Test détection GPU
make benchmark             # Benchmark performance

# Gestion
make configure             # Reconfiguration
make status               # Statut installation
make info                 # Informations système
make backup               # Sauvegarde configuration
```

## Configuration

Le script d'installation propose une configuration interactive qui permet de :

### Informations système
- ✅ Nom du système et distribution
- ✅ Architecture et version du noyau
- ✅ Temps de fonctionnement et charge
- ✅ Utilisation mémoire et disque
- ✅ Adresse IP locale
- ✅ Température CPU (via lm-sensors)
- ✅ Informations GPU (NVIDIA/AMD/Intel)
- ✅ Utilisateurs connectés
- ✅ Dernières connexions
- ✅ Mises à jour disponibles

### Surveillance des services
Le script détecte automatiquement les services installés et vous permet de sélectionner ceux à surveiller :
- SSH
- Apache2/Nginx
- Docker
- Fail2Ban
- UFW
- PostgreSQL/MySQL/MariaDB
- Redis/MongoDB
- Elasticsearch
- Grafana/Prometheus
- Et bien d'autres...

### Thèmes de couleurs
- **Défaut** : Multicolore (cyan/jaune/vert/rouge)
- **Bleu** : Professionnel (variations de bleu)
- **Vert** : Style Matrix (variations de vert)
- **Rouge** : Serveur critique (variations de rouge)
- **Violet** : Moderne (variations de violet)

### Configurations prédéfinies

#### Configuration Serveur (`--server`)
- **Thème** : Bleu professionnel
- **Informations** : Système, uptime, charge, mémoire, disque, IP, température, utilisateurs, mises à jour
- **Services** : SSH, Apache2, Nginx, Docker, PostgreSQL, MySQL, Redis, Fail2Ban, UFW

#### Configuration Station de Travail (`--workstation`)
- **Thème** : Violet moderne
- **Informations** : Système, architecture, noyau, uptime, charge, mémoire, disque, IP, température, GPU, utilisateurs
- **Services** : SSH, Docker, Nginx

#### Configuration Minimale (`--minimal`)
- **Thème** : Vert simple
- **Informations** : Système, uptime, mémoire, disque, charge
- **Services** : SSH uniquement

## Structure du projet

```
motd-amd64/
├── install.sh                     # Script d'installation principal
├── scripts/
│   └── quick-setup.sh             # Installation rapide avec configs prédéfinies
├── README.md                      # Documentation
├── LICENSE                        # Licence MIT
├── INSTALL.md                     # Guide d'installation détaillé
├── CONTRIBUTING.md                # Guide de contribution
├── SECURITY.md                    # Politique de sécurité
├── CHANGELOG.md                   # Journal des modifications
├── Makefile                       # Commandes de développement
├── examples/                      # Exemples de configuration
│   ├── server-lamp-config.md
│   ├── workstation-dev-config.md
│   └── docker-server-config.md
├── docs/                          # Documentation technique
│   ├── temperature-sensors.md
│   ├── gpu-detection.md
│   └── images/
└── tools/                         # Outils d'administration
    ├── benchmark-motd.sh
    └── export-prometheus.sh
```

## Fichiers générés

Après installation, les fichiers suivants sont créés :

```
/etc/motd-amd64/
├── config                         # Configuration générale
├── system_info                    # Informations système activées
└── services                       # Services à surveiller

/etc/update-motd.d/
├── 00-motd-amd64                  # Script principal MOTD
└── 10-motd-services               # Script surveillance services
```

## Personnalisation avancée

### Modification manuelle de la configuration

```bash
# Éditer la configuration générale
sudo nano /etc/motd-amd64/config

# Éditer les informations système
sudo nano /etc/motd-amd64/system_info

# Éditer les services surveillés
sudo nano /etc/motd-amd64/services
```

### Ajout de services personnalisés

```bash
# Ajouter un service à surveiller
echo "mon-service-custom" | sudo tee -a /etc/motd-amd64/services
```

### Configuration des capteurs de température

```bash
# Détecter automatiquement les capteurs
sudo sensors-detect --auto

# Voir les températures disponibles
sensors

# Configuration avancée dans /etc/sensors3.conf
sudo nano /etc/sensors3.conf
```

## Compatibilité

- **Architecture** : x86_64/AMD64
- **Système** : Debian, Ubuntu, Linux Mint et dérivés
- **Matériel** : Serveurs Intel/AMD, stations de travail, PC de bureau
- **Prérequis** : SystemD, APT package manager

## Exemples d'affichage

### Affichage principal
```
     ██████╗ ███████╗██████╗ ██╗   ██╗███████╗██████╗ 
    ██╔════╝ ██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗
    ██║  ███╗█████╗  ██████╔╝██║   ██║█████╗  ██████╔╝
    ██║   ██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██╔══╝  ██╔══██╗
    ╚██████╔╝███████╗██║  ██║ ╚████╔╝ ███████╗██║  ██║
     ╚═════╝ ╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝

╔══════════════════════════════════════════════════════════════════════════════════════╗
║                                  Informations Système                                ║
╠══════════════════════════════════════════════════════════════════════════════════════╣
║ Système : Ubuntu 22.04.3 LTS                                                        ║
║ Architecture : x86_64                                                               ║
║ Noyau : 5.15.0-91-generic                                                          ║
║ Uptime : up 5 days, 12 hours, 45 minutes                                           ║
║ Charge :  0.25, 0.18, 0.12                                                         ║
║ Mémoire : 8.2G/15.6G                                                               ║
║ Disque : 45G/100G (47%)                                                            ║
║ IP Locale : 192.168.1.150                                                          ║
║ Température CPU : +42.0°C                                                          ║
║ GPU : NVIDIA GeForce RTX 3070                                                      ║
╚══════════════════════════════════════════════════════════════════════════════════════╝

Utilisateurs connectés : 2
  → admin depuis 192.168.1.100 (09:30)
  → user depuis 192.168.1.200 (10:15)

Dernières connexions :
  → admin depuis 192.168.1.100 le Mar 14
  → user depuis 192.168.1.200 le Mar 14
  → backup depuis 192.168.1.50 le Mar 13
```

### Surveillance des services
```
╔══════════════════════════════════════════════════════════════════════════════════════╗
║                                  État des Services                                   ║
╠══════════════════════════════════════════════════════════════════════════════════════╣
║ ssh : ● Actif                                                                       ║
║ docker : ● Actif                                                                    ║
║ nginx : ● Actif                                                                     ║
║ postgresql : ● Actif                                                                ║
║ redis : ● Actif                                                                     ║
║ grafana : ● Inactif                                                                 ║
╚══════════════════════════════════════════════════════════════════════════════════════╝
```

## Optimisations AMD64 spécifiques

### Détection de température avancée
- **Intel** : Support des capteurs Core Temp
- **AMD** : Support des capteurs Tctl/Tdie
- **Serveurs** : Support IPMI et capteurs carte mère
- **Fallback** : Zones thermiques du kernel

### Support GPU étendu
- **NVIDIA** : Détection via nvidia-smi
- **AMD** : Détection via lspci
- **Intel** : Support iGPU intégré
- **Multi-GPU** : Affichage du GPU principal

### Services serveur courants
Détection automatique des services typiques AMD64 :
- Serveurs web (Apache, Nginx)
- Bases de données (PostgreSQL, MySQL, MongoDB)
- Conteneurisation (Docker, Podman)
- Monitoring (Grafana, Prometheus, Elasticsearch)
- Sécurité (Fail2Ban, UFW)

## Performance et benchmark

### Test de performance
```bash
# Benchmark automatique
make benchmark

# Test manuel
time sudo run-parts /etc/update-motd.d/

# Optimisation pour serveurs haute charge
make install-minimal  # Configuration allégée
```

### Métriques typiques
- **Temps d'affichage** : < 200ms (excellent), < 500ms (bon)
- **Utilisation CPU** : < 5% pendant l'affichage
- **Impact mémoire** : < 10MB

## Dépannage

### MOTD ne s'affiche pas
```bash
# Vérifier les permissions
ls -la /etc/update-motd.d/

# Tester manuellement
sudo run-parts /etc/update-motd.d/
```

### Température CPU non affichée
```bash
# Installer et configurer lm-sensors
sudo apt install lm-sensors
sudo sensors-detect --auto

# Tester les capteurs
sensors
```

### GPU non détecté
```bash
# Pour NVIDIA
sudo apt install nvidia-utils-*
nvidia-smi

# Pour AMD
sudo apt install mesa-utils
lspci | grep -i vga
```

### Services non détectés
```bash
# Vérifier les services disponibles
systemctl list-unit-files --type=service | grep -E "(apache|nginx|docker|postgres)"
```

### Erreur de permissions
```bash
# Réparer les permissions
sudo chmod +x /etc/update-motd.d/00-motd-amd64
sudo chmod +x /etc/update-motd.d/10-motd-services
```

## Contribution

Les contributions sont les bienvenues ! Voici comment contribuer :

1. Forkez le projet
2. Créez une branche pour votre fonctionnalité (`git checkout -b feature/nouvelle-fonctionnalite`)
3. Committez vos changements (`git commit -am 'Ajout d'une nouvelle fonctionnalité'`)
4. Pushez vers la branche (`git push origin feature/nouvelle-fonctionnalite`)
5. Ouvrez une Pull Request

## Licence

Ce projet est sous licence MIT. Voir le fichier [LICENSE](LICENSE) pour plus de détails.

## Changelog

### v1.0.0 (2025-07-14)
- 🎉 Version initiale
- ✨ Configuration interactive
- 🎨 5 thèmes de couleurs
- 📊 Informations système complètes
- 🛠️ Surveillance des services
- 🖥️ Optimisation AMD64 avec support GPU
- 🌡️ Monitoring température avancé
- ⚡ Configurations prédéfinies (serveur, workstation, minimal)
- 🔧 Benchmark et outils d'optimisation

## Projets connexes

- **MOTD-AARCH64** : Version pour architecture ARM64/Raspberry Pi → [alphagoones/motd-aarch64](https://github.com/alphagoones/motd-aarch64)

## Auteur

alphagoones - [@alphagoones](https://github.com/alphagoones)

## Remerciements

- Communauté Ubuntu/Debian
- Développeurs de lm-sensors
- Projets de MOTD existants
- Contributeurs du projet

## Support

Si vous rencontrez des problèmes :

1. Consultez la section [Dépannage](#dépannage)
2. Cherchez dans les [Issues existantes](https://github.com/alphagoones/motd-amd64/issues)
3. Créez une nouvelle issue avec :
   - Version du système
   - Architecture
   - Logs d'erreur
   - Configuration matérielle (CPU, GPU)

---

**Note**: Ce projet est spécialement optimisé pour les architectures x86_64/AMD64, avec support étendu pour les serveurs et stations de travail Intel/AMD.
