#!/bin/bash

# MOTD-AMD64 Quick Setup Script
# URL: https://github.com/alphagoones/motd-amd64
# Usage: curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/scripts/quick-setup.sh | bash

set -e

# Configuration
GITHUB_REPO="alphagoones/motd-amd64"
GITHUB_API="https://api.github.com/repos/$GITHUB_REPO"
GITHUB_RAW="https://raw.githubusercontent.com/$GITHUB_REPO/main"
TEMP_DIR="/tmp/motd-amd64-setup"

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Fonction d'affichage
print_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
    ╔══════════════════════════════════════════════════════════════╗
    ║                     MOTD-AMD64 Quick Setup                  ║
    ║              Installation rapide et automatisée             ║
    ║                   Optimisé pour x86_64/AMD64                ║
    ╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

print_step() {
    echo -e "${BLUE}[ÉTAPE]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCÈS]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERREUR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[ATTENTION]${NC} $1"
}

print_info() {
    echo -e "${PURPLE}[INFO]${NC} $1"
}

# Fonction de nettoyage
cleanup() {
    if [[ -d "$TEMP_DIR" ]]; then
        rm -rf "$TEMP_DIR"
    fi
}

# Piège pour nettoyage en cas d'erreur
trap cleanup EXIT

# Vérifications préalables
check_requirements() {
    print_step "Vérification des prérequis..."
    
    # Vérifier si on est sur une distribution supportée
    if ! command -v apt &> /dev/null; then
        print_error "Ce script nécessite une distribution basée sur Debian/Ubuntu"
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
    
    # Vérifier la connectivité internet
    if ! curl -s --head https://github.com &> /dev/null; then
        print_error "Connexion internet requise"
        exit 1
    fi
    
    # Vérifier les privilèges
    if [[ $EUID -eq 0 ]]; then
        print_warning "Script exécuté en tant que root"
        print_info "Recommandation: exécutez avec sudo si nécessaire"
    fi
    
    print_success "Prérequis validés"
}

# Détection de la méthode d'installation préférée
detect_install_method() {
    print_step "Détection de la méthode d'installation..."
    
    INSTALL_METHOD=""
    
    # Vérifier si git est disponible
    if command -v git &> /dev/null; then
        INSTALL_METHOD="git"
        print_info "Git détecté - Installation depuis le dépôt"
    # Vérifier si curl/wget sont disponibles
    elif command -v curl &> /dev/null || command -v wget &> /dev/null; then
        INSTALL_METHOD="direct"
        print_info "Installation directe via téléchargement"
    else
        print_error "Ni git ni curl/wget ne sont disponibles"
        print_info "Installation des outils requis..."
        
        if [[ $EUID -ne 0 ]]; then
            sudo apt update
            sudo apt install -y curl git
        else
            apt update
            apt install -y curl git
        fi
        
        INSTALL_METHOD="git"
    fi
}

# Installation via Git
install_via_git() {
    print_step "Installation via Git..."
    
    # Créer le répertoire temporaire
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"
    
    # Cloner le dépôt
    print_info "Clonage du dépôt depuis GitHub..."
    git clone "https://github.com/$GITHUB_REPO.git" .
    
    # Vérifier que le script d'installation existe
    if [[ ! -f "install.sh" ]]; then
        print_error "Script d'installation non trouvé dans le dépôt"
        exit 1
    fi
    
    # Rendre le script exécutable
    chmod +x install.sh
    
    print_success "Dépôt cloné avec succès"
}

# Installation directe
install_via_direct() {
    print_step "Installation directe..."
    
    # Créer le répertoire temporaire
    mkdir -p "$TEMP_DIR"
    cd "$TEMP_DIR"
    mkdir -p scripts
    
    # Télécharger le script d'installation
    print_info "Téléchargement du script d'installation..."
    
    if command -v curl &> /dev/null; then
        curl -fsSL "$GITHUB_RAW/install.sh" -o install.sh
    elif command -v wget &> /dev/null; then
        wget -qO install.sh "$GITHUB_RAW/install.sh"
    else
        print_error "Impossible de télécharger le script d'installation"
        exit 1
    fi
    
    # Vérifier le téléchargement
    if [[ ! -f "install.sh" ]] || [[ ! -s "install.sh" ]]; then
        print_error "Échec du téléchargement du script d'installation"
        exit 1
    fi
    
    # Rendre le script exécutable
    chmod +x install.sh
    
    print_success "Script d'installation téléchargé"
}

# Vérifier la dernière version
check_latest_version() {
    print_step "Vérification de la dernière version..."
    
    if command -v curl &> /dev/null; then
        LATEST_VERSION=$(curl -s "$GITHUB_API/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/' 2>/dev/null || echo "unknown")
    else
        LATEST_VERSION="unknown"
    fi
    
    if [[ "$LATEST_VERSION" != "unknown" ]]; then
        print_info "Dernière version disponible: $LATEST_VERSION"
    else
        print_warning "Impossible de vérifier la version"
    fi
}

# Configuration interactive simplifiée
quick_configure() {
    print_step "Configuration rapide..."
    
    echo -e "${CYAN}Choix de configuration rapide pour AMD64:${NC}"
    echo "1) Configuration serveur (recommandée pour serveurs)"
    echo "2) Configuration station de travail (recommandée pour desktop)"
    echo "3) Configuration minimale (serveur léger)"
    echo "4) Configuration complète (toutes les options)"
    echo "5) Configuration personnalisée"
    echo
    
    read -p "Votre choix (1-5) [1]: " -r choice
    choice=${choice:-1}
    
    case $choice in
        1)
            print_info "Configuration serveur sélectionnée"
            QUICK_CONFIG="server"
            ;;
        2)
            print_info "Configuration station de travail sélectionnée"
            QUICK_CONFIG="workstation"
            ;;
        3)
            print_info "Configuration minimale sélectionnée"
            QUICK_CONFIG="minimal"
            ;;
        4)
            print_info "Configuration complète sélectionnée"
            QUICK_CONFIG="full"
            ;;
        5)
            print_info "Configuration personnalisée - utilisation du mode interactif"
            QUICK_CONFIG="interactive"
            ;;
        *)
            print_warning "Choix invalide, utilisation de la configuration serveur"
            QUICK_CONFIG="server"
            ;;
    esac
}

# Exécution de l'installation
run_installation() {
    print_step "Lancement de l'installation..."
    
    case $QUICK_CONFIG in
        "server")
            print_info "Installation avec configuration serveur..."
            export MOTD_AUTO_CONFIG="server"
            export MOTD_THEME="blue"
            export MOTD_SHOW_HOSTNAME="true"
            export MOTD_SYSTEM_INFO="system,arch,kernel,uptime,load,memory,disk,ip,temp,users,lastlog,updates"
            export MOTD_SERVICES="ssh,apache2,nginx,docker,postgresql,mysql,redis,fail2ban,ufw"
            ;;
        "workstation")
            print_info "Installation avec configuration station de travail..."
            export MOTD_AUTO_CONFIG="workstation"
            export MOTD_THEME="purple"
            export MOTD_SHOW_HOSTNAME="true"
            export MOTD_SYSTEM_INFO="system,arch,kernel,uptime,load,memory,disk,ip,temp,gpu,users"
            export MOTD_SERVICES="ssh,docker,nginx"
            ;;
        "minimal")
            print_info "Installation avec configuration minimale..."
            export MOTD_AUTO_CONFIG="minimal"
            export MOTD_THEME="green"
            export MOTD_SHOW_HOSTNAME="false"
            export MOTD_SYSTEM_INFO="system,uptime,memory,disk,load"
            export MOTD_SERVICES="ssh"
            ;;
        "full")
            print_info "Installation avec configuration complète..."
            export MOTD_AUTO_CONFIG="full"
            export MOTD_THEME="default"
            export MOTD_SHOW_HOSTNAME="true"
            export MOTD_SYSTEM_INFO="system,arch,kernel,uptime,load,memory,disk,ip,temp,gpu,users,lastlog,updates"
            export MOTD_SERVICES="ssh,apache2,nginx,docker,postgresql,mysql,redis,mongodb,elasticsearch,grafana,prometheus,fail2ban,ufw"
            ;;
        "interactive")
            print_info "Mode interactif - configuration manuelle..."
            unset MOTD_AUTO_CONFIG
            ;;
    esac
    
    # Exécuter l'installation
    if [[ $EUID -ne 0 ]]; then
        sudo ./install.sh
    else
        ./install.sh
    fi
    
    print_success "Installation terminée !"
}

# Affichage des informations post-installation
show_post_install_info() {
    print_step "Informations post-installation"
    
    echo
    echo -e "${GREEN}✅ MOTD-AMD64 installé avec succès !${NC}"
    echo
    echo -e "${CYAN}📋 Commandes utiles :${NC}"
    echo -e "  ${YELLOW}•${NC} Tester le MOTD      : ${WHITE}sudo run-parts /etc/update-motd.d/${NC}"
    echo -e "  ${YELLOW}•${NC} Reconfigurer       : ${WHITE}sudo motd-amd64-install --configure${NC}"
    echo -e "  ${YELLOW}•${NC} Désinstaller       : ${WHITE}sudo motd-amd64-install --uninstall${NC}"
    echo
    echo -e "${CYAN}📁 Fichiers de configuration :${NC}"
    echo -e "  ${YELLOW}•${NC} Configuration      : ${WHITE}/etc/motd-amd64/config${NC}"
    echo -e "  ${YELLOW}•${NC} Informations       : ${WHITE}/etc/motd-amd64/system_info${NC}"
    echo -e "  ${YELLOW}•${NC} Services           : ${WHITE}/etc/motd-amd64/services${NC}"
    echo
    echo -e "${CYAN}🔧 Optimisations AMD64 :${NC}"
    echo -e "  ${YELLOW}•${NC} Capteurs température : ${WHITE}lm-sensors configuré${NC}"
    echo -e "  ${YELLOW}•${NC} Support GPU        : ${WHITE}NVIDIA/AMD/Intel détectés${NC}"
    echo -e "  ${YELLOW}•${NC} Services serveur   : ${WHITE}Auto-détectés et configurés${NC}"
    echo
    echo -e "${CYAN}🔗 Liens utiles :${NC}"
    echo -e "  ${YELLOW}•${NC} Documentation      : ${WHITE}https://github.com/$GITHUB_REPO${NC}"
    echo -e "  ${YELLOW}•${NC} Issues/Support     : ${WHITE}https://github.com/$GITHUB_REPO/issues${NC}"
    echo -e "  ${YELLOW}•${NC} Releases           : ${WHITE}https://github.com/$GITHUB_REPO/releases${NC}"
    echo
    
    # Afficher un aperçu du MOTD
    if [[ -x "/etc/update-motd.d/00-motd-amd64" ]]; then
        echo -e "${PURPLE}🎨 Aperçu du MOTD :${NC}"
        echo -e "${CYAN}─────────────────────────────────────${NC}"
        sudo run-parts /etc/update-motd.d/ 2>/dev/null || true
        echo -e "${CYAN}─────────────────────────────────────${NC}"
    fi
    
    echo
    echo -e "${GREEN}🎉 Profitez de votre nouveau MOTD AMD64 !${NC}"
}

# Test de l'installation
test_installation() {
    print_step "Test de l'installation..."
    
    local errors=0
    
    # Vérifier les fichiers installés
    if [[ ! -f "/etc/update-motd.d/00-motd-amd64" ]]; then
        print_error "Script MOTD principal manquant"
        ((errors++))
    fi
    
    if [[ ! -f "/etc/update-motd.d/10-motd-services" ]]; then
        print_error "Script MOTD services manquant"
        ((errors++))
    fi
    
    if [[ ! -d "/etc/motd-amd64" ]]; then
        print_error "Répertoire de configuration manquant"
        ((errors++))
    fi
    
    # Vérifier les permissions
    if [[ ! -x "/etc/update-motd.d/00-motd-amd64" ]]; then
        print_error "Script MOTD principal non exécutable"
        ((errors++))
    fi
    
    # Test d'exécution
    if ! sudo run-parts /etc/update-motd.d/ &>/dev/null; then
        print_error "Erreur lors de l'exécution du MOTD"
        ((errors++))
    fi
    
    # Vérifier les capteurs de température
    if command -v sensors &> /dev/null; then
        print_success "Capteurs de température configurés"
    else
        print_warning "lm-sensors non installé"
    fi
    
    if [[ $errors -eq 0 ]]; then
        print_success "Installation validée"
        return 0
    else
        print_error "$errors erreur(s) détectée(s)"
        return 1
    fi
}

# Gestion des options de ligne de commande
handle_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --server)
                QUICK_CONFIG="server"
                SKIP_INTERACTIVE=true
                shift
                ;;
            --workstation)
                QUICK_CONFIG="workstation"
                SKIP_INTERACTIVE=true
                shift
                ;;
            --minimal)
                QUICK_CONFIG="minimal"
                SKIP_INTERACTIVE=true
                shift
                ;;
            --full)
                QUICK_CONFIG="full"
                SKIP_INTERACTIVE=true
                shift
                ;;
            --theme=*)
                THEME="${1#*=}"
                shift
                ;;
            --no-hostname)
                SHOW_HOSTNAME="false"
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            --version)
                show_version
                exit 0
                ;;
            *)
                print_warning "Option inconnue: $1"
                shift
                ;;
        esac
    done
}

# Affichage de l'aide
show_help() {
    echo "MOTD-AMD64 Quick Setup"
    echo
    echo "Usage: $0 [OPTIONS]"
    echo
    echo "Options:"
    echo "  --server            Configuration serveur automatique"
    echo "  --workstation       Configuration station de travail automatique"
    echo "  --minimal           Configuration minimale automatique"
    echo "  --full              Configuration complète automatique"
    echo "  --theme=THEME       Thème de couleurs (default|blue|green|red|purple)"
    echo "  --no-hostname       Désactiver l'affichage du hostname"
    echo "  --help, -h          Afficher cette aide"
    echo "  --version           Afficher la version"
    echo
    echo "Exemples:"
    echo "  $0                  # Installation interactive"
    echo "  $0 --server         # Installation serveur automatique"
    echo "  $0 --workstation    # Installation station de travail"
    echo "  $0 --minimal        # Installation minimale"
    echo "  $0 --theme=blue     # Installation avec thème bleu"
}

# Affichage de la version
show_version() {
    echo "MOTD-AMD64 Quick Setup v1.0.0"
    if [[ "$LATEST_VERSION" != "unknown" ]]; then
        echo "Dernière version MOTD-AMD64: $LATEST_VERSION"
    fi
}

# Fonction principale
main() {
    # Variables par défaut
    QUICK_CONFIG=""
    SKIP_INTERACTIVE=false
    THEME=""
    SHOW_HOSTNAME=""
    
    # Traitement des arguments
    handle_arguments "$@"
    
    # Affichage de la bannière
    print_banner
    
    # Vérifications préalables
    check_requirements
    check_latest_version
    detect_install_method
    
    # Configuration si pas d'arguments automatiques
    if [[ "$SKIP_INTERACTIVE" != "true" ]]; then
        quick_configure
    fi
    
    # Installation selon la méthode détectée
    case $INSTALL_METHOD in
        "git")
            install_via_git
            ;;
        "direct")
            install_via_direct
            ;;
        *)
            print_error "Méthode d'installation non déterminée"
            exit 1
            ;;
    esac
    
    # Exécution de l'installation
    run_installation
    
    # Test de l'installation
    if test_installation; then
        show_post_install_info
    else
        print_error "L'installation semble avoir échoué"
        print_info "Consultez les logs ci-dessus pour plus de détails"
        exit 1
    fi
}

# Point d'entrée
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
