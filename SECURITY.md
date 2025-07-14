# Politique de sécurité - MOTD-AMD64

## 🔒 Versions supportées

| Version | Support Sécurité |
| ------- | --------------- |
| 1.0.x   | ✅ Support complet |
| < 1.0   | ❌ Non supporté |

## 🚨 Signaler une vulnérabilité

### Processus de signalement

Si vous découvrez une vulnérabilité de sécurité dans MOTD-AMD64, **NE PAS** créer d'issue publique. Suivez ce processus :

1. **Email privé** : Envoyez un email à `githubalphagoones@gmail.com`
2. **Objet** : `[SECURITY] MOTD-AMD64 - Description courte`
3. **Contenu** : Détails de la vulnérabilité (voir template ci-dessous)

### Template de rapport de sécurité

```
**Type de vulnérabilité**
[ ] Injection de commande
[ ] Escalade de privilèges
[ ] Exposition d'informations sensibles
[ ] Déni de service
[ ] Autre : _____________

**Description**
Description détaillée de la vulnérabilité.

**Impact**
- Confidentialité : Haut/Moyen/Bas
- Intégrité : Haut/Moyen/Bas
- Disponibilité : Haut/Moyen/Bas

**Reproduction**
Étapes pour reproduire la vulnérabilité :
1. ...
2. ...
3. ...

**Preuve de concept**
Code ou commandes démontrant la vulnérabilité.

**Environnement testé**
- OS : [ex. Ubuntu 22.04]
- Architecture : [ex. amd64]
- Version MOTD : [ex. 1.0.0]

**Suggestion de correction**
Propositions pour corriger la vulnérabilité.

**Coordonnées**
Nom : 
Email : 
Souhait de crédit public : Oui/Non
```

### Délais de réponse

- **Accusé de réception** : 48 heures
- **Évaluation initiale** : 5 jours ouvrés
- **Statut détaillé** : 10 jours ouvrés
- **Correction** : Selon la criticité (voir ci-dessous)

### Classification des vulnérabilités

#### 🔴 Critique (CVSS 9.0-10.0)
- **Délai de correction** : 7 jours
- **Exemples** : Exécution de code arbitraire en tant que root

#### 🟠 Haute (CVSS 7.0-8.9)
- **Délai de correction** : 30 jours
- **Exemples** : Escalade de privilèges, injection de commande

#### 🟡 Moyenne (CVSS 4.0-6.9)
- **Délai de correction** : 90 jours
- **Exemples** : Exposition d'informations, déni de service

#### 🟢 Basse (CVSS 0.1-3.9)
- **Délai de correction** : 180 jours
- **Exemples** : Fuite d'informations mineures

## 🛡️ Mesures de sécurité implémentées

### Sécurité du code

#### Validation des entrées
```bash
# Validation des paramètres utilisateur
validate_input() {
    local input="$1"
    
    # Vérification contre l'injection de commande
    if [[ "$input" =~ [;\|\&\$\`] ]]; then
        print_error "Caractères dangereux détectés"
        return 1
    fi
    
    # Limitation de taille
    if [[ ${#input} -gt 255 ]]; then
        print_error "Entrée trop longue"
        return 1
    fi
}
```

#### Exécution sécurisée
```bash
# Utilisation de chemins absolus
/usr/bin/systemctl status "$service"

# Échappement des variables
printf '%q' "$user_input"

# Validation des fichiers de configuration
if [[ ! -f "$config_file" ]] || [[ ! -r "$config_file" ]]; then
    print_error "Fichier de configuration invalide"
    exit 1
fi
```

### Permissions de fichiers

```bash
# Scripts MOTD (lecture seule pour users)
/etc/update-motd.d/00-motd-amd64   # 755 (root:root)
/etc/update-motd.d/10-motd-services  # 755 (root:root)

# Configuration (lecture seule pour users)
/etc/motd-amd64/config            # 644 (root:root)
/etc/motd-amd64/system_info       # 644 (root:root)
/etc/motd-amd64/services          # 644 (root:root)
```

### Isolation des privilèges

- **Installation** : Nécessite sudo/root
- **Exécution MOTD** : Fonctionne avec utilisateur standard
- **Configuration** : Stockée dans `/etc` (root uniquement)
- **Logs** : Pas de logs sensibles

## 🔍 Audit de sécurité

### Analyse statique

Le projet utilise plusieurs outils d'analyse :

```bash
# ShellCheck pour la sécurité des scripts
shellcheck install.sh

# Bandit pour l'analyse de sécurité (via CI/CD)
bandit -r . -f json -o security-report.json
```

### Tests de sécurité

#### Tests automatisés
```bash
# Test d'injection de commande
test_command_injection() {
    local malicious_input="; rm -rf /"
    
    # Doit échouer sans exécuter la commande
    if validate_input "$malicious_input"; then
        echo "ÉCHEC : Injection de commande possible"
        return 1
    fi
}

# Test d'escalade de privilèges
test_privilege_escalation() {
    # Vérifier que les scripts ne peuvent pas être modifiés
    local motd_script="/etc/update-motd.d/00-motd-amd64"
    
    if [[ -w "$motd_script" ]]; then
        echo "ÉCHEC : Script MOTD modifiable par l'utilisateur"
        return 1
    fi
}
```

### Revue de code sécurité

Chaque pull request est analysée pour :

- **Injection de commande** : Validation des entrées utilisateur
- **Gestion des erreurs** : Pas de leak d'informations sensibles
- **Permissions** : Respect du principe de moindre privilège
- **Chemins de fichiers** : Utilisation de chemins absolus
- **Variables d'environnement** : Pas d'exposition de secrets

## 🚧 Considérations de sécurité

### Risques identifiés et atténués

#### 1. Exécution de code arbitraire
**Risque** : Script exécuté à chaque connexion SSH
**Atténuation** :
- Validation stricte des configurations
- Fichiers en lecture seule pour users
- Pas d'exécution de code utilisateur

#### 2. Exposition d'informations système
**Risque** : Affichage d'informations sensibles
**Atténuation** :
- Informations système publiques uniquement
- Pas d'affichage de mots de passe ou clés
- Configuration des éléments affichés

#### 3. Déni de service
**Risque** : MOTD lent ou bloquant
**Atténuation** :
- Timeout sur les commandes système
- Limitation de la taille d'affichage
- Gestion d'erreur robuste

#### 4. Modification non autorisée
**Risque** : Altération des scripts MOTD
**Atténuation** :
- Permissions restrictives (root uniquement)
- Intégrité vérifiée à l'installation
- Checksums dans les releases

### Bonnes pratiques pour les utilisateurs

#### Installation sécurisée
```bash
# Vérifier la signature GPG (si disponible)
gpg --verify motd-amd64-1.0.0.tar.gz.sig

# Vérifier les checksums
sha256sum -c motd-amd64-1.0.0.tar.gz.sha256

# Installer depuis les sources officielles uniquement
curl -fsSL https://raw.githubusercontent.com/alphagoones/motd-amd64/main/install.sh | sudo bash
```

#### Configuration sécurisée
```bash
# Limiter les informations affichées en environnement sensible
sudo nano /etc/motd-amd64/system_info
# Retirer : ip, users, lastlog

# Surveiller uniquement les services critiques
sudo nano /etc/motd-amd64/services
# Garder : ssh, fail2ban, ufw
```

#### Maintenance sécurisée
```bash
# Vérifier régulièrement les mises à jour
curl -s https://api.github.com/repos/alphagoones/motd-amd64/releases/latest

# Sauvegarder la configuration
make backup

# Surveiller les logs système
journalctl -u ssh | grep motd
```

## 📋 Checklist sécurité pour développeurs

Avant chaque release :

- [ ] Audit de code pour injections de commande
- [ ] Test avec caractères spéciaux dans config
- [ ] Vérification des permissions de fichiers
- [ ] Test d'escalade de privilèges
- [ ] Validation des chemins de fichiers
- [ ] Test de déni de service (entrées volumineuses)
- [ ] Vérification absence de secrets hardcodés
- [ ] Test sur système durci (SELinux/AppArmor)

## 🔄 Processus de correction de sécurité

### 1. Réception et triage
- Validation de la vulnérabilité
- Classification CVSS
- Attribution de priorité

### 2. Développement du correctif
- Création de branche sécurité privée
- Développement et test du correctif
- Revue de code sécurité

### 3. Tests et validation
- Test sur environnements multiples
- Validation de la correction
- Test de non-régression

### 4. Communication et release
- Rédaction de l'advisory sécurité
- Préparation de la release de sécurité
- Publication coordonnée

### 5. Post-publication
- Monitoring des retours utilisateurs
- Documentation des leçons apprises
- Amélioration des processus

## 📞 Contact sécurité

- **Email** : githubalphagoones@gmail.com
- **Response Time** : 48h pour accusé réception

---

**La sécurité est une responsabilité partagée. Merci de nous aider à maintenir MOTD-AMD64 sécurisé ! 🔒**
