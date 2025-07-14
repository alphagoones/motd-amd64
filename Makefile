# MOTD-AMD64 Makefile

.PHONY: help install configure uninstall test clean package

# Variables
INSTALL_SCRIPT = ./scripts/install.sh
VERSION = $(shell grep "^# Version:" scripts/install.sh | cut -d' ' -f3 || echo "1.0.0")
PACKAGE_NAME = motd-amd64-$(VERSION)

# Couleurs pour l'affichage
RED = \033[0;31m
GREEN = \033[0;32m
YELLOW = \033[1;33m
BLUE = \033[0;34m
PURPLE = \033[0;35m
NC = \033[0m # No Color

help: ## Afficher cette aide
	@echo -e "$(BLUE)MOTD-AMD64 - Commandes disponibles:$(NC)"
	@echo ""
	@awk 'BEGIN {FS = ":.*##"} /^[a-zA-Z_-]+:.*##/ {printf "  $(GREEN)%-15s$(NC) %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""

install: ## Installer MOTD-AMD64
	@echo -e "$(YELLOW)Installation de MOTD-AMD64...$(NC)"
	@sudo $(INSTALL_SCRIPT)
	@echo -e "$(GREEN)Installation terminée !$(NC)"

install-server: ## Installation configuration serveur
	@echo -e "$(YELLOW)Installation MOTD-AMD64 en mode serveur...$(NC)"
	@curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/scripts/quick-setup.sh | bash -s -- --server
	@echo -e "$(GREEN)Installation serveur terminée !$(NC)"

install-workstation: ## Installation configuration station de travail
	@echo -e "$(YELLOW)Installation MOTD-AMD64 en mode station de travail...$(NC)"
	@curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/scripts/quick-setup.sh | bash -s -- --workstation
	@echo -e "$(GREEN)Installation station de travail terminée !$(NC)"

install-minimal: ## Installation configuration minimale
	@echo -e "$(YELLOW)Installation MOTD-AMD64 en mode minimal...$(NC)"
	@curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/scripts/quick-setup.sh | bash -s -- --minimal
	@echo -e "$(GREEN)Installation minimale terminée !$(NC)"

configure: ## Reconfigurer MOTD-AMD64
	@echo -e "$(YELLOW)Reconfiguration de MOTD-AMD64...$(NC)"
	@sudo $(INSTALL_SCRIPT) --configure
	@echo -e "$(GREEN)Reconfiguration terminée !$(NC)"

uninstall: ## Désinstaller MOTD-AMD64
	@echo -e "$(YELLOW)Désinstallation de MOTD-AMD64...$(NC)"
	@sudo $(INSTALL_SCRIPT) --uninstall
	@echo -e "$(GREEN)Désinstallation terminée !$(NC)"

test: ## Tester le MOTD
	@echo -e "$(YELLOW)Test du MOTD...$(NC)"
	@sudo run-parts /etc/update-motd.d/
	@echo -e "$(GREEN)Test terminé !$(NC)"

test-sensors: ## Tester les capteurs de température
	@echo -e "$(YELLOW)Test des capteurs de température...$(NC)"
	@if command -v sensors >/dev/null 2>&1; then \
		sensors; \
		echo -e "$(GREEN)Capteurs opérationnels !$(NC)"; \
	else \
		echo -e "$(RED)lm-sensors non installé$(NC)"; \
		echo -e "$(BLUE)Installation: sudo apt install lm-sensors$(NC)"; \
	fi

test-gpu: ## Tester la détection GPU
	@echo -e "$(YELLOW)Test de détection GPU...$(NC)"
	@if command -v nvidia-smi >/dev/null 2>&1; then \
		echo -e "$(GREEN)GPU NVIDIA détecté:$(NC)"; \
		nvidia-smi --query-gpu=name --format=csv,noheader,nounits; \
	elif lspci | grep -i vga >/dev/null 2>&1; then \
		echo -e "$(GREEN)GPU détecté via lspci:$(NC)"; \
		lspci | grep -i vga | head -1; \
	else \
		echo -e "$(YELLOW)Aucun GPU détecté$(NC)"; \
	fi

lint: ## Vérifier la syntaxe des scripts
	@echo -e "$(YELLOW)Vérification de la syntaxe...$(NC)"
	@if command -v shellcheck >/dev/null 2>&1; then \
		shellcheck scripts/install.sh scripts/quick-setup.sh; \
		echo -e "$(GREEN)Syntaxe correcte !$(NC)"; \
	else \
		echo -e "$(RED)shellcheck non installé, installation...$(NC)"; \
		sudo apt install -y shellcheck; \
		shellcheck scripts/install.sh scripts/quick-setup.sh; \
	fi

clean: ## Nettoyer les fichiers temporaires
	@echo -e "$(YELLOW)Nettoyage...$(NC)"
	@rm -f *.tmp *.log *.backup
	@rm -rf build/ dist/
	@echo -e "$(GREEN)Nettoyage terminé !$(NC)"

package: clean ## Créer un package de distribution
	@echo -e "$(YELLOW)Création du package $(PACKAGE_NAME)...$(NC)"
	@mkdir -p dist
	@tar -czf dist/$(PACKAGE_NAME).tar.gz \
		scripts/ \
		README.md \
		LICENSE \
		.gitignore \
		Makefile \
		INSTALL.md \
		CONTRIBUTING.md \
		SECURITY.md \
		--transform 's,^,$(PACKAGE_NAME)/,'
	@echo -e "$(GREEN)Package créé : dist/$(PACKAGE_NAME).tar.gz$(NC)"

deb: ## Créer un package .deb (nécessite fpm)
	@echo -e "$(YELLOW)Création du package .deb...$(NC)"
	@if ! command -v fpm >/dev/null 2>&1; then \
		echo -e "$(RED)fpm non installé. Installation...$(NC)"; \
		sudo apt install -y ruby ruby-dev rubygems build-essential; \
		sudo gem install fpm; \
	fi
	@mkdir -p build/usr/local/bin
	@cp scripts/install.sh build/usr/local/bin/motd-amd64-install
	@cp scripts/quick-setup.sh build/usr/local/bin/motd-amd64-quick-setup
	@chmod +x build/usr/local/bin/motd-amd64-install
	@chmod +x build/usr/local/bin/motd-amd64-quick-setup
	@fpm -s dir -t deb \
		-n motd-amd64 \
		-v $(VERSION) \
		-a amd64 \
		--description "MOTD moderne pour architecture x86_64/AMD64" \
		--url "https://github.com/alphagoones/motd-amd64" \
		--maintainer "alphagoones <alphagoones@github.com>" \
		--license "MIT" \
		--depends "figlet" \
		--depends "bc" \
		--depends "dialog" \
		--depends "lm-sensors" \
		--depends "curl" \
		-C build \
		.
	@mv *.deb dist/
	@echo -e "$(GREEN)Package .deb créé dans dist/$(NC)"

check-deps: ## Vérifier les dépendances
	@echo -e "$(YELLOW)Vérification des dépendances...$(NC)"
	@echo -n "figlet: "
	@if command -v figlet >/dev/null 2>&1; then echo -e "$(GREEN)✓$(NC)"; else echo -e "$(RED)✗$(NC)"; fi
	@echo -n "bc: "
	@if command -v bc >/dev/null 2>&1; then echo -e "$(GREEN)✓$(NC)"; else echo -e "$(RED)✗$(NC)"; fi
	@echo -n "dialog: "
	@if command -v dialog >/dev/null 2>&1; then echo -e "$(GREEN)✓$(NC)"; else echo -e "$(RED)✗$(NC)"; fi
	@echo -n "lm-sensors: "
	@if command -v sensors >/dev/null 2>&1; then echo -e "$(GREEN)✓$(NC)"; else echo -e "$(RED)✗$(NC)"; fi
	@echo -n "curl: "
	@if command -v curl >/dev/null 2>&1; then echo -e "$(GREEN)✓$(NC)"; else echo -e "$(RED)✗$(NC)"; fi
	@echo -n "git: "
	@if command -v git >/dev/null 2>&1; then echo -e "$(GREEN)✓$(NC)"; else echo -e "$(RED)✗$(NC)"; fi

install-deps: ## Installer les dépendances de développement
	@echo -e "$(YELLOW)Installation des dépendances de développement...$(NC)"
	@sudo apt update
	@sudo apt install -y shellcheck ruby ruby-dev rubygems build-essential
	@sudo gem install fpm
	@echo -e "$(GREEN)Dépendances installées !$(NC)"

status: ## Afficher le statut de l'installation
	@echo -e "$(BLUE)Statut de MOTD-AMD64:$(NC)"
	@echo ""
	@if [ -d "/etc/motd-amd64" ]; then \
		echo -e "$(GREEN)✓ Installé$(NC)"; \
		echo -e "Configuration: /etc/motd-amd64/"; \
		echo -e "Scripts MOTD: /etc/update-motd.d/"; \
		echo ""; \
		echo -e "$(PURPLE)Configuration actuelle:$(NC)"; \
		if [ -f "/etc/motd-amd64/config" ]; then cat /etc/motd-amd64/config; fi; \
	else \
		echo -e "$(RED)✗ Non installé$(NC)"; \
	fi
	@echo ""

info: ## Afficher les informations système
	@echo -e "$(BLUE)Informations système AMD64:$(NC)"
	@echo ""
	@echo -e "$(YELLOW)Architecture:$(NC) $(shell uname -m)"
	@echo -e "$(YELLOW)Système:$(NC) $(shell lsb_release -d 2>/dev/null | cut -f2 || echo "Unknown")"
	@echo -e "$(YELLOW)Noyau:$(NC) $(shell uname -r)"
	@echo -e "$(YELLOW)CPU:$(NC) $(shell grep 'model name' /proc/cpuinfo | head -1 | cut -d':' -f2 | sed 's/^ *//')"
	@echo -e "$(YELLOW)Mémoire:$(NC) $(shell free -h | awk '/^Mem:/ {print $2}')"
	@if command -v sensors >/dev/null 2>&1; then \
		TEMP=$(sensors 2>/dev/null | grep -E "Core 0|Package id 0|Tctl" | head -1 | grep -oE '\+[0-9]+\.[0-9]+°C' | head -1); \
		if [ -n "$TEMP" ]; then \
			echo -e "$(YELLOW)Température:$(NC) $TEMP"; \
		fi; \
	fi
	@if command -v nvidia-smi >/dev/null 2>&1; then \
		GPU=$(nvidia-smi --query-gpu=name --format=csv,noheader,nounits 2>/dev/null | head -1); \
		echo -e "$(YELLOW)GPU:$(NC) $GPU"; \
	elif lspci | grep -i vga >/dev/null 2>&1; then \
		GPU=$(lspci | grep -i vga | head -1 | sed 's/.*: //' | cut -d'(' -f1); \
		echo -e "$(YELLOW)GPU:$(NC) $GPU"; \
	fi

backup: ## Sauvegarder la configuration actuelle
	@echo -e "$(YELLOW)Sauvegarde de la configuration...$(NC)"
	@if [ -d "/etc/motd-amd64" ]; then \
		sudo tar -czf motd-amd64-config-backup-$(shell date +%Y%m%d-%H%M%S).tar.gz \
			-C /etc motd-amd64/ \
			-C /etc/update-motd.d 00-motd-amd64 10-motd-services 2>/dev/null || true; \
		echo -e "$(GREEN)Sauvegarde créée !$(NC)"; \
	else \
		echo -e "$(RED)Aucune configuration à sauvegarder$(NC)"; \
	fi

restore: ## Restaurer une sauvegarde (BACKUP=fichier.tar.gz)
	@if [ -z "$(BACKUP)" ]; then \
		echo -e "$(RED)Erreur: Spécifiez le fichier de sauvegarde avec BACKUP=fichier.tar.gz$(NC)"; \
		exit 1; \
	fi
	@echo -e "$(YELLOW)Restauration de $(BACKUP)...$(NC)"
	@sudo tar -xzf $(BACKUP) -C /
	@echo -e "$(GREEN)Restauration terminée !$(NC)"

benchmark: ## Benchmark du temps d'affichage MOTD
	@echo -e "$(YELLOW)Benchmark du MOTD...$(NC)"
	@echo "Temps d'exécution (moyenne sur 5 tests):"
	@time_total=0; \
	for i in 1 2 3 4 5; do \
		start=$(date +%s%3N); \
		sudo run-parts /etc/update-motd.d/ >/dev/null 2>&1; \
		end=$(date +%s%3N); \
		time_diff=$((end - start)); \
		time_total=$((time_total + time_diff)); \
		echo "Test $i: ${time_diff}ms"; \
	done; \
	time_avg=$((time_total / 5)); \
	echo -e "$(GREEN)Temps moyen: ${time_avg}ms$(NC)"

dev-setup: install-deps ## Configuration de l'environnement de développement
	@echo -e "$(YELLOW)Configuration de l'environnement de développement...$(NC)"
	@git config --local core.autocrlf false
	@git config --local core.eol lf
	@echo -e "$(GREEN)Environnement de développement configuré !$(NC)"

release: lint package deb ## Créer une release complète
	@echo -e "$(GREEN)Release $(VERSION) créée avec succès !$(NC)"
	@echo -e "Fichiers générés:"
	@ls -la dist/

# Variables par défaut
VERSION ?= 1.0.0
BACKUP ?=

# Aide par défaut
.DEFAULT_GOAL := help
