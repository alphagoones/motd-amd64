#!/bin/bash

# MOTD-AMD64 - Script d'installation
# https://github.com/alphagoones/motd-amd64

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'

# Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="/etc/motd-amd64"
MOTD_DIR="/etc/update-motd.d"

# Fonction d'affichage
print_banner() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════╗"
    echo "║                     MOTD-AMD64 INSTALLER                    ║"
    echo "║               Configuration MOTD moderne pour x86_64        ║"
    echo "╚══════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Vérifications préalables
check_requirements() {
    print_step "Vérification des prérequis..."
    
    # Vérifier si on est root
    if [[ $EUID -ne 0 ]]; then
        print_error "Ce script doit être exécuté avec sudo"
        exit 1
    fi
    
    # Vérifier l'architecture
    ARCH=$(uname -m)
    if [[ "$ARCH" != "x86_64" ]]; then
        print_warning "Ce script est optimisé pour x86_64, architecture détectée: $ARCH"
        read -p "Continuer ? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    # Vérifier le système d'exploitation
    if ! command -v apt &> /dev/null; then
        print_error "Ce script nécessite un système basé sur Debian/Ubuntu"
        exit 1
    fi
    
    print_success "Prérequis validés"
}

# Installation des packages
install_packages() {
    print_step "Installation des packages requis..."
    
    apt update
    apt install -y figlet lolcat neofetch curl bc dialog lm-sensors
    
    # Initialiser les capteurs de température
    print_step "Configuration des capteurs de température..."
    sensors-detect --auto &>/dev/null || true
    
    print_success "Packages installés avec succès"
}

# Configuration interactive
interactive_config() {
    print_step "Configuration interactive..."
    
    # Créer le répertoire de configuration
    mkdir -p "$CONFIG_DIR"
    
    # Configuration du hostname display
    dialog --title "Configuration MOTD" \
           --yesno "Voulez-vous afficher le hostname en grand dans le MOTD ?" 7 60
    
    if [[ $? -eq 0 ]]; then
        echo "SHOW_HOSTNAME=true" > "$CONFIG_DIR/config"
    else
        echo "SHOW_HOSTNAME=false" > "$CONFIG_DIR/config"
    fi
    
    # Configuration des informations système
    dialog --title "Informations Système" \
           --checklist "Sélectionnez les informations à afficher:" 20 70 12 \
           "system" "Nom du système" on \
           "arch" "Architecture" on \
           "kernel" "Version du noyau" on \
           "uptime" "Temps de fonctionnement" on \
           "load" "Charge système" on \
           "memory" "Utilisation mémoire" on \
           "disk" "Utilisation disque" on \
           "ip" "Adresse IP locale" on \
           "temp" "Température CPU" on \
           "gpu" "Informations GPU" on \
           "users" "Utilisateurs connectés" on \
           "lastlog" "Dernières connexions" on \
           "updates" "Mises à jour disponibles" on 2>"$CONFIG_DIR/system_info.tmp"
    
    if [[ $? -eq 0 ]]; then
        cat "$CONFIG_DIR/system_info.tmp" | tr -d '"' | tr ' ' '\n' > "$CONFIG_DIR/system_info"
        rm "$CONFIG_DIR/system_info.tmp"
    else
        echo -e "system\narch\nkernel\nuptime\nload\nmemory\ndisk\nip" > "$CONFIG_DIR/system_info"
    fi
    
    # Configuration des services
    SERVICES_LIST=""
    COMMON_SERVICES=("ssh" "apache2" "nginx" "docker" "fail2ban" "ufw" "postgresql" "mysql" "redis" "mongodb" "elasticsearch" "mariadb" "grafana" "prometheus")
    
    for service in "${COMMON_SERVICES[@]}"; do
        if systemctl list-unit-files "$service.service" &>/dev/null || systemctl status "$service" &>/dev/null; then
            SERVICES_LIST="$SERVICES_LIST $service \"Service $service\" on"
        fi
    done
    
    if [[ -n "$SERVICES_LIST" ]]; then
        eval "dialog --title \"Services à surveiller\" \
               --checklist \"Sélectionnez les services à surveiller:\" 20 70 14 \
               $SERVICES_LIST" 2>"$CONFIG_DIR/services.tmp"
        
        if [[ $? -eq 0 ]]; then
            cat "$CONFIG_DIR/services.tmp" | tr -d '"' | tr ' ' '\n' > "$CONFIG_DIR/services"
            rm "$CONFIG_DIR/services.tmp"
        else
            echo "ssh" > "$CONFIG_DIR/services"
        fi
    else
        echo "ssh" > "$CONFIG_DIR/services"
    fi
    
    # Configuration des couleurs
    dialog --title "Thème de couleurs" \
           --radiolist "Choisissez un thème de couleurs:" 12 60 5 \
           "default" "Thème par défaut (multicolore)" on \
           "blue" "Thème bleu professionnel" off \
           "green" "Thème vert Matrix" off \
           "red" "Thème rouge serveur" off \
           "purple" "Thème violet moderne" off 2>"$CONFIG_DIR/theme.tmp"
    
    if [[ $? -eq 0 ]]; then
        THEME=$(cat "$CONFIG_DIR/theme.tmp")
        echo "THEME=$THEME" >> "$CONFIG_DIR/config"
        rm "$CONFIG_DIR/theme.tmp"
    else
        echo "THEME=default" >> "$CONFIG_DIR/config"
    fi
    
    clear
    print_success "Configuration terminée"
}

# Génération du script MOTD principal
generate_motd_script() {
    print_step "Génération du script MOTD principal..."
    
    cat > "$MOTD_DIR/00-motd-amd64" << 'EOF'
#!/bin/bash

# MOTD-AMD64 - Script généré automatiquement
# Configuration: /etc/motd-amd64/

CONFIG_DIR="/etc/motd-amd64"
source "$CONFIG_DIR/config" 2>/dev/null || true

# Définition des thèmes de couleurs
case "${THEME:-default}" in
    "blue")
        PRIMARY='\033[0;34m'
        SECONDARY='\033[1;36m'
        SUCCESS='\033[0;32m'
        WARNING='\033[1;33m'
        ERROR='\033[0;31m'
        ;;
    "green")
        PRIMARY='\033[0;32m'
        SECONDARY='\033[1;32m'
        SUCCESS='\033[0;32m'
        WARNING='\033[1;33m'
        ERROR='\033[0;31m'
        ;;
    "red")
        PRIMARY='\033[0;31m'
        SECONDARY='\033[1;31m'
        SUCCESS='\033[0;32m'
        WARNING='\033[1;33m'
        ERROR='\033[0;31m'
        ;;
    "purple")
        PRIMARY='\033[0;35m'
        SECONDARY='\033[1;35m'
        SUCCESS='\033[0;32m'
        WARNING='\033[1;33m'
        ERROR='\033[0;31m'
        ;;
    *)
        PRIMARY='\033[0;36m'
        SECONDARY='\033[1;33m'
        SUCCESS='\033[0;32m'
        WARNING='\033[1;33m'
        ERROR='\033[0;31m'
        ;;
esac

WHITE='\033[1;37m'
NC='\033[0m'

# Largeur totale du cadre
FRAME_WIDTH=90

# Fonction pour créer une ligne avec padding approprié
create_line() {
    local label="$1"
    local value="$2"
    local content_length=$((${#label} + 3 + ${#value}))
    local padding=$((FRAME_WIDTH - content_length - 2))
    
    printf "${PRIMARY}║${NC} ${SECONDARY}%s${NC} : ${WHITE}%s${NC}%*s ${PRIMARY}║${NC}\n" "$label" "$value" "$padding" ""
}

# Fonction pour vérifier si une info est activée
is_enabled() {
    grep -q "^$1$" "$CONFIG_DIR/system_info" 2>/dev/null
}

# Fonction pour obtenir des informations système
get_system_info() {
    is_enabled "system" && HOSTNAME=$(hostname)
    is_enabled "kernel" && KERNEL=$(uname -r)
    is_enabled "uptime" && UPTIME=$(uptime -p)
    is_enabled "load" && LOAD=$(uptime | awk -F'load average:' '{print $2}')
    is_enabled "memory" && MEMORY=$(free -h | awk '/^Mem:/ {print $3"/"$2}')
    is_enabled "disk" && DISK=$(df -h / | awk 'NR==2 {print $3"/"$2" ("$5")"}')
    is_enabled "ip" && IP=$(ip route get 8.8.8.8 | awk '{print $7}' | head -1)
    is_enabled "arch" && ARCH=$(uname -m)
    is_enabled "system" && DISTRO=$(lsb_release -d | cut -f2 2>/dev/null || echo "Unknown")
    
    # Température CPU pour AMD64
    if is_enabled "temp"; then
        CPU_TEMP=""
        if command -v sensors &> /dev/null; then
            # Tenter de récupérer la température via sensors
            TEMP_OUTPUT=$(sensors 2>/dev/null)
            if echo "$TEMP_OUTPUT" | grep -q "Core 0\|Package id 0\|Tctl"; then
                CPU_TEMP=$(echo "$TEMP_OUTPUT" | grep -E "Core 0|Package id 0|Tctl" | head -1 | grep -oE '\+[0-9]+\.[0-9]+°C' | head -1)
            elif echo "$TEMP_OUTPUT" | grep -q "temp1"; then
                CPU_TEMP=$(echo "$TEMP_OUTPUT" | grep "temp1" | head -1 | grep -oE '\+[0-9]+\.[0-9]+°C' | head -1)
            fi
        fi
        # Alternative via zone thermique
        if [[ -z "$CPU_TEMP" ]] && [[ -f /sys/class/thermal/thermal_zone0/temp ]]; then
            TEMP_RAW=$(cat /sys/class/thermal/thermal_zone0/temp)
            if [[ $TEMP_RAW -gt 1000 ]]; then
                CPU_TEMP=$(echo "scale=1; $TEMP_RAW/1000" | bc)°C
            fi
        fi
    fi
    
    # Informations GPU pour AMD64
    if is_enabled "gpu"; then
        GPU_INFO=""
        if command -v nvidia-smi &> /dev/null; then
            GPU_INFO=$(nvidia-smi --query-gpu=name --format=csv,noheader,nounits 2>/dev/null | head -1)
        elif command -v lspci &> /dev/null; then
            GPU_INFO=$(lspci | grep -i vga | head -1 | sed 's/.*: //' | cut -d'(' -f1)
        fi
        [[ ${#GPU_INFO} -gt 45 ]] && GPU_INFO="${GPU_INFO:0:42}..."
    fi
}

# Récupération des informations système
get_system_info

# Affichage du header
clear
if [[ "${SHOW_HOSTNAME:-true}" == "true" ]]; then
    printf "${ERROR}"
    HOSTNAME_FIGLET=$(figlet -f slant "${HOSTNAME:-$(hostname)}" 2>/dev/null || figlet "${HOSTNAME:-$(hostname)}" 2>/dev/null || echo "${HOSTNAME:-$(hostname)}")
    echo "$HOSTNAME_FIGLET" | sed 's/^/                    /'
    printf "${NC}\n"
fi

# Créer la bordure supérieure
printf "${PRIMARY}╔"
printf "═%.0s" $(seq 1 $FRAME_WIDTH)
printf "╗${NC}\n"

# Titre centré
title="Informations Système"
title_length=${#title}
title_padding=$(((FRAME_WIDTH - title_length) / 2))
printf "${PRIMARY}║${NC}%*s${SECONDARY}%s${NC}%*s${PRIMARY}║${NC}\n" "$title_padding" "" "$title" "$((FRAME_WIDTH - title_length - title_padding))" ""

# Séparateur
printf "${PRIMARY}╠"
printf "═%.0s" $(seq 1 $FRAME_WIDTH)
printf "╣${NC}\n"

# Affichage des informations système
is_enabled "system" && [[ -n "$DISTRO" ]] && create_line "Système" "$DISTRO"
is_enabled "arch" && [[ -n "$ARCH" ]] && create_line "Architecture" "$ARCH"
is_enabled "kernel" && [[ -n "$KERNEL" ]] && create_line "Noyau" "$KERNEL"
is_enabled "uptime" && [[ -n "$UPTIME" ]] && create_line "Uptime" "$UPTIME"
is_enabled "load" && [[ -n "$LOAD" ]] && create_line "Charge" "$LOAD"
is_enabled "memory" && [[ -n "$MEMORY" ]] && create_line "Mémoire" "$MEMORY"
is_enabled "disk" && [[ -n "$DISK" ]] && create_line "Disque" "$DISK"
is_enabled "ip" && [[ -n "$IP" ]] && create_line "IP Locale" "$IP"
is_enabled "temp" && [[ -n "$CPU_TEMP" ]] && create_line "Température CPU" "$CPU_TEMP"
is_enabled "gpu" && [[ -n "$GPU_INFO" ]] && create_line "GPU" "$GPU_INFO"

# Bordure inférieure
printf "${PRIMARY}╚"
printf "═%.0s" $(seq 1 $FRAME_WIDTH)
printf "╝${NC}\n"

# Affichage des utilisateurs connectés
if is_enabled "users"; then
    USERS=$(who | wc -l)
    if [[ $USERS -gt 0 ]]; then
        printf "\n${SUCCESS}Utilisateurs connectés : $USERS${NC}\n"
        who | awk '{print "  → " $1 " depuis " $5 " (" $4 ")"}' | head -5
    fi
fi

# Affichage des dernières connexions
if is_enabled "lastlog"; then
    printf "\n${SECONDARY}Dernières connexions :${NC}\n"
    last -n 3 | head -3 | awk '{print "  → " $1 " depuis " $3 " le " $4 " " $5}'
fi

# Vérification des mises à jour
if is_enabled "updates" && command -v apt &> /dev/null; then
    UPDATES=$(apt list --upgradable 2>/dev/null | wc -l)
    if [[ $UPDATES -gt 1 ]]; then
        printf "\n${WARNING}⚠️  $((UPDATES-1)) mises à jour disponibles${NC}\n"
    fi
fi

printf "\n"
EOF

    chmod +x "$MOTD_DIR/00-motd-amd64"
    print_success "Script MOTD principal généré"
}

# Génération du script de services
generate_services_script() {
    print_step "Génération du script de surveillance des services..."
    
    cat > "$MOTD_DIR/10-motd-services" << 'EOF'
#!/bin/bash

# MOTD-AMD64 - Services monitoring
CONFIG_DIR="/etc/motd-amd64"
source "$CONFIG_DIR/config" 2>/dev/null || true

# Définition des couleurs selon le thème
case "${THEME:-default}" in
    "blue")
        PRIMARY='\033[0;34m'
        SECONDARY='\033[1;36m'
        SUCCESS='\033[0;32m'
        ERROR='\033[0;31m'
        ;;
    "green")
        PRIMARY='\033[0;32m'
        SECONDARY='\033[1;32m'
        SUCCESS='\033[0;32m'
        ERROR='\033[0;31m'
        ;;
    "red")
        PRIMARY='\033[0;31m'
        SECONDARY='\033[1;31m'
        SUCCESS='\033[0;32m'
        ERROR='\033[0;31m'
        ;;
    "purple")
        PRIMARY='\033[0;35m'
        SECONDARY='\033[1;35m'
        SUCCESS='\033[0;32m'
        ERROR='\033[0;31m'
        ;;
    *)
        PRIMARY='\033[0;36m'
        SECONDARY='\033[1;33m'
        SUCCESS='\033[0;32m'
        ERROR='\033[0;31m'
        ;;
esac

NC='\033[0m'
FRAME_WIDTH=90

# Vérifier si le fichier de services existe
if [[ ! -f "$CONFIG_DIR/services" ]]; then
    exit 0
fi

# Fonction pour créer une ligne de service
create_service_line() {
    local service="$1"
    local status="$2"
    local status_color="$3"
    local content_length=$((${#service} + 3 + ${#status}))
    local padding=$((FRAME_WIDTH - content_length - 2))
    
    printf "${PRIMARY}║${NC} %s : ${status_color}%s${NC}%*s ${PRIMARY}║${NC}\n" "$service" "$status" "$padding" ""
}

# Créer la bordure supérieure
printf "${PRIMARY}╔"
printf "═%.0s" $(seq 1 $FRAME_WIDTH)
printf "╗${NC}\n"

# Titre centré
title="État des Services"
title_length=${#title}
title_padding=$(((FRAME_WIDTH - title_length) / 2))
printf "${PRIMARY}║${NC}%*s${SECONDARY}%s${NC}%*s${PRIMARY}║${NC}\n" "$title_padding" "" "$title" "$((FRAME_WIDTH - title_length - title_padding))" ""

# Séparateur
printf "${PRIMARY}╠"
printf "═%.0s" $(seq 1 $FRAME_WIDTH)
printf "╣${NC}\n"

service_found=false
while IFS= read -r service; do
    [[ -z "$service" ]] && continue
    
    if systemctl list-unit-files "$service.service" &>/dev/null || systemctl status "$service" &>/dev/null; then
        service_found=true
        if systemctl is-active "$service" &>/dev/null; then
            create_service_line "$service" "● Actif" "$SUCCESS"
        else
            create_service_line "$service" "● Inactif" "$ERROR"
        fi
    fi
done < "$CONFIG_DIR/services"

if [ "$service_found" = false ]; then
    no_service_msg="Aucun service configuré trouvé"
    msg_length=${#no_service_msg}
    padding=$((FRAME_WIDTH - msg_length - 4))
    printf "${PRIMARY}║${NC} %s%*s ${PRIMARY}║${NC}\n" "$no_service_msg" "$padding" ""
fi

# Bordure inférieure
printf "${PRIMARY}╚"
printf "═%.0s" $(seq 1 $FRAME_WIDTH)
printf "╝${NC}\n"

printf "\n"
EOF

    chmod +x "$MOTD_DIR/10-motd-services"
    print_success "Script de surveillance des services généré"
}

# Désactivation de l'ancien MOTD
disable_old_motd() {
    print_step "Désactivation de l'ancien MOTD..."
    
    # Désactiver tous les anciens scripts MOTD sauf les nôtres
    for script in "$MOTD_DIR"/*; do
        if [[ -f "$script" && -x "$script" ]]; then
            basename_script=$(basename "$script")
            if [[ "$basename_script" != "00-motd-amd64" && "$basename_script" != "10-motd-services" ]]; then
                chmod -x "$script"
            fi
        fi
    done
    
    print_success "Ancien MOTD désactivé"
}

# Test du nouveau MOTD
test_motd() {
    print_step "Test du nouveau MOTD..."
    echo
    run-parts "$MOTD_DIR/"
    echo
    print_success "MOTD testé avec succès"
}

# Installation complète
install_motd() {
    print_banner
    
    check_requirements
    install_packages
    interactive_config
    disable_old_motd
    generate_motd_script
    generate_services_script
    test_motd
    
    echo
    print_success "Installation de MOTD-AMD64 terminée !"
    echo
    echo -e "${CYAN}Commandes utiles :${NC}"
    echo "  • Tester le MOTD     : sudo run-parts /etc/update-motd.d/"
    echo "  • Reconfigurer      : sudo $0 --configure"
    echo "  • Configuration     : /etc/motd-amd64/"
    echo "  • Désinstaller      : sudo $0 --uninstall"
    echo
}

# Configuration uniquement
configure_only() {
    print_banner
    print_step "Reconfiguration de MOTD-AMD64..."
    
    if [[ ! -d "$CONFIG_DIR" ]]; then
        print_error "MOTD-AMD64 n'est pas installé. Utilisez : sudo $0"
        exit 1
    fi
    
    interactive_config
    generate_motd_script
    generate_services_script
    test_motd
    
    print_success "Reconfiguration terminée !"
}

# Désinstallation
uninstall_motd() {
    print_banner
    print_step "Désinstallation de MOTD-AMD64..."
    
    # Supprimer nos scripts
    rm -f "$MOTD_DIR/00-motd-amd64"
    rm -f "$MOTD_DIR/10-motd-services"
    
    # Supprimer la configuration
    rm -rf "$CONFIG_DIR"
    
    # Réactiver les anciens scripts MOTD
    for script in "$MOTD_DIR"/*; do
        if [[ -f "$script" ]]; then
            chmod +x "$script"
        fi
    done
    
    print_success "MOTD-AMD64 désinstallé"
}

# Menu principal
case "${1:-}" in
    --configure)
        configure_only
        ;;
    --uninstall)
        uninstall_motd
        ;;
    --help)
        echo "Usage: $0 [OPTIONS]"
        echo
        echo "Options:"
        echo "  (aucune)      Installation complète"
        echo "  --configure   Reconfiguration uniquement"
        echo "  --uninstall   Désinstallation"
        echo "  --help        Afficher cette aide"
        ;;
    *)
        install_motd
        ;;
esac
