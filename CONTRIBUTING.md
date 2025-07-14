# Guide de contribution - MOTD-AMD64

Merci de votre intérêt pour contribuer à MOTD-AMD64 ! Ce guide vous explique comment participer au développement du projet.

## 🤝 Comment contribuer

### Types de contributions acceptées

- 🐛 **Corrections de bugs**
- ✨ **Nouvelles fonctionnalités**
- 📚 **Amélioration de la documentation**
- 🎨 **Améliorations de l'interface**
- 🔧 **Optimisations de performance**
- 🧪 **Tests et validation**
- 🌐 **Traductions**

## 🚀 Commencer

### 1. Prérequis de développement

```bash
# Cloner le dépôt
git clone https://github.com/alphagoones/motd-amd64.git
cd motd-amd64

# Installer les outils de développement
make dev-setup

# Vérifier les dépendances
make check-deps
```

### 2. Configuration de l'environnement

```bash
# Installer les outils de lint
sudo apt install shellcheck

# Installer fpm pour les packages
sudo gem install fpm

# Configurer Git
git config user.name "Votre Nom"
git config user.email "votre.email@example.com"
```

## 📋 Processus de contribution

### 1. Issues et propositions

Avant de commencer à coder :

1. **Vérifiez les issues existantes** sur GitHub
2. **Créez une issue** pour discuter de votre idée
3. **Attendez l'approbation** pour les grosses fonctionnalités

### 2. Workflow Git

```bash
# 1. Créer une branche pour votre fonctionnalité
git checkout -b feature/ma-nouvelle-fonctionnalite

# 2. Faire vos modifications
# ... développement ...

# 3. Tester vos changements
make lint
make test

# 4. Committer avec un message clair
git add .
git commit -m "feat: Ajouter support pour nouveaux capteurs de température"

# 5. Pousser votre branche
git push origin feature/ma-nouvelle-fonctionnalite

# 6. Créer une Pull Request sur GitHub
```

### 3. Standards de code

#### Scripts Bash
- Utilisez `#!/bin/bash` en en-tête
- Indentez avec 4 espaces
- Utilisez des noms de variables explicites
- Commentez les sections complexes
- Gérez les erreurs avec `set -e`

#### Exemple de style :
```bash
#!/bin/bash

# Description de la fonction
function ma_fonction() {
    local param1="$1"
    local param2="$2"
    
    if [[ -z "$param1" ]]; then
        print_error "Paramètre manquant"
        return 1
    fi
    
    # Logique de la fonction
    echo "Traitement de $param1"
}
```

#### Messages de commit
Utilisez le format [Conventional Commits](https://www.conventionalcommits.org/) :

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

**Types acceptés :**
- `feat:` Nouvelle fonctionnalité
- `fix:` Correction de bug
- `docs:` Documentation
- `style:` Formatage, pas de changement de code
- `refactor:` Refactoring de code
- `test:` Ajout de tests
- `chore:` Maintenance

**Exemples :**
```
feat: Ajouter support pour capteurs de température ARM Mali
fix: Corriger l'affichage de la mémoire sur Ubuntu 22.04
docs: Mettre à jour le guide d'installation
```

## 🧪 Tests et validation

### Tests obligatoires avant PR

```bash
# 1. Vérification syntaxique
make lint

# 2. Test d'installation
make install

# 3. Test de configuration
make configure

# 4. Test de fonctionnement
make test

# 5. Test de désinstallation
make uninstall
```

### Tests sur différentes plateformes

Testez vos modifications sur :
- **serveurs Intel/AMD 4/5** (serveurs Intel/AMD OS)
- **Orange Pi** (Ubuntu/Debian)
- **Autres SBC x86_64**

### Tests de régression

Vérifiez que vos changements n'affectent pas :
- L'installation existante
- La configuration sauvegardée
- Les thèmes de couleurs
- L'affichage des services

## 📝 Documentation

### Mise à jour de la documentation

Lors de l'ajout de fonctionnalités :

1. **README.md** - Fonctionnalités principales
2. **INSTALL.md** - Instructions d'installation
3. **Commentaires code** - Fonctions complexes
4. **Messages d'aide** - Interface utilisateur

### Captures d'écran

Pour les changements visuels :
1. Ajoutez des captures dans `examples/`
2. Utilisez le format PNG
3. Nommez clairement : `feature-description.png`

## 🐛 Rapporter des bugs

### Template d'issue pour bugs

```markdown
**Description du bug**
Description claire du problème.

**Reproduction**
Étapes pour reproduire :
1. Aller à '...'
2. Cliquer sur '....'
3. Voir l'erreur

**Comportement attendu**
Ce qui devrait se passer.

**Environnement**
- OS : [ex. Ubuntu 22.04]
- Architecture : [ex. amd64]
- Matériel : [ex. serveurs Intel/AMD 4]
- Version MOTD : [ex. 1.0.0]

**Logs d'erreur**
```
Coller les logs ici
```

**Informations additionnelles**
Contexte supplémentaire.
```

## 💡 Proposer des fonctionnalités

### Template d'issue pour fonctionnalités

```markdown
**Fonctionnalité souhaitée**
Description claire de la fonctionnalité.

**Motivation**
Pourquoi cette fonctionnalité est-elle utile ?

**Solution proposée**
Comment cette fonctionnalité pourrait être implémentée.

**Alternatives considérées**
Autres approches envisagées.

**Impact**
- Compatibilité : Casse-t-elle la compatibilité ?
- Performance : Impact sur les performances ?
- Maintenance : Complexité ajoutée ?
```

## 🎯 Domaines d'amélioration prioritaires

### Fonctionnalités recherchées

1. **Support multi-architecture**
   - Améliorer la compatibilité x86_64
   - Support RISC-V

2. **Nouveaux capteurs**
   - Support pour plus de SBC
   - Capteurs réseau avancés
   - Monitoring GPU

3. **Interface utilisateur**
   - Mode web pour configuration à distance
   - Présets de configuration
   - Export/import de config

4. **Performance**
   - Cache des informations système
   - Optimisation temps de démarrage
   - Mode léger pour systèmes contraints

5. **Intégrations**
   - Support Docker
   - Intégration Kubernetes
   - Monitoring externe (Prometheus)

### Documentation à améliorer

- Guides spécifiques par SBC
- Exemples de configurations
- Troubleshooting avancé
- Traductions (FR/EN/ES)

## 📋 Checklist Pull Request

Avant de soumettre votre PR :

- [ ] Les tests passent (`make lint && make test`)
- [ ] La documentation est mise à jour
- [ ] Les messages de commit suivent les conventions
- [ ] Le code respecte le style du projet
- [ ] Aucune régression introduite
- [ ] Les nouvelles fonctionnalités sont testées
- [ ] Les changements sont documentés

## 🏷️ Releases et versioning

### Versioning sémantique

Le projet suit [Semantic Versioning](https://semver.org/) :

- `MAJOR.MINOR.PATCH`
- **MAJOR** : Changements incompatibles
- **MINOR** : Nouvelles fonctionnalités compatibles
- **PATCH** : Corrections de bugs

### Processus de release

1. **Développement** sur `develop`
2. **Pull Request** vers `main`
3. **Review** et tests automatisés
4. **Merge** et création du tag
5. **Release automatique** via GitHub Actions

## 🤖 CI/CD

Le projet utilise GitHub Actions pour :

- **Lint** : Vérification syntaxique
- **Tests** : Tests sur multiple architectures
- **Sécurité** : Scan de sécurité
- **Build** : Génération des packages
- **Release** : Publication automatique

## 🎉 Reconnaissance

### Hall of Fame

Les contributeurs sont listés dans :
- `README.md` - Section remerciements
- `CONTRIBUTORS.md` - Liste complète
- Releases notes - Mentions spéciales

### Badges de contribution

- 🥇 **First Contributor** - Première contribution
- 🐛 **Bug Hunter** - Corrections de bugs
- ✨ **Feature Creator** - Nouvelles fonctionnalités
- 📚 **Documentation Master** - Améliorations doc
- 🧪 **Testing Hero** - Tests et validation

## 📞 Contact et support

### Canaux de communication

- **Issues GitHub** - Bugs et fonctionnalités
- **Discussions GitHub** - Questions générales
- **Email** - votre.email@example.com (mainteneur)

### Code de conduite

Ce projet suit le [Contributor Covenant](https://www.contributor-covenant.org/). Soyez respectueux et inclusif dans toutes vos interactions.

---

**Merci de contribuer à MOTD-AMD64 ! 🙏**

Ensemble, nous créons un meilleur MOTD pour la communauté x86_64.
