# 📚 Documentation BoxToBikers

Bienvenue dans la documentation complète du projet BoxToBikers !

---

## 🚀 Démarrage Rapide

Nouveau sur le projet ? Commencez ici :

- **[Guide de démarrage rapide](getting-started/quick-start.md)** - Installation en 3 minutes ⚡
- **[Installation complète](getting-started/setup-complete.md)** - Tous les détails de la configuration

---

## 📖 Documentation par Thématique

### 🔧 Variables d'Environnement

Configuration des variables d'environnement pour dev/staging/prod.

- **[Guide complet](environment/README.md)** - Documentation technique détaillée
- **[Configuration](environment/configuration.md)** - Guide de configuration pas à pas
- **[Exemple de code](environment/examples/main_with_env_example.dart)** - Exemple d'utilisation

### 🔗 Backend & Services

#### Supabase

- **[Guide Supabase](backend/supabase/README.md)** - Intégration et utilisation
- **[Configuration](backend/supabase/STARTER.md)** - Mise en place de Supabase
- **[Notes de version](backend/supabase/updates.md)** - Mises à jour et changelog

#### HTTP

- **[Client HTTP](backend/http/README.md)** - Configuration et utilisation de Dio
- **[Exemples](backend/http/examples/)** - Exemples d'utilisation
- **[Exemple de code](backend/http/examples/example_usage.dart)** - Exemple d'utilisation
### 👨‍💻 Guide Développeur

Guides et astuces pour le développement quotidien.

- **[Guide développeur](development/README.md)** - Hot reload, debugging, etc.
- **[App Launcher](development/app-launcher.md)** - Système de démarrage et state management

### 🏗️ Architecture

Compréhension de la structure du projet.

- **[Vue d'ensemble](architecture/README.md)** - Architecture générale
- **[Structure du projet](architecture/project-structure.md)** - Organisation des dossiers

---

## 🎯 Guides par Cas d'Usage

### Je veux...

- **Démarrer rapidement** → [Quick Start](getting-started/quick-start.md)
- **Configurer les variables d'env** → [Configuration Env](environment/configuration.md)
- **Intégrer Supabase** → [Guide Supabase](backend/supabase/README.md)
- **Comprendre l'architecture** → [Architecture](architecture/README.md)
- **Développer au quotidien** → [Guide Développeur](development/README.md)
- **Résoudre un problème** → [Troubleshooting](getting-started/quick-start.md#-problèmes-)

---

## 📁 Structure de la Documentation

```
docs/
├── README.md                          # Ce fichier
├── getting-started/                   # Démarrage
│   ├── quick-start.md
│   └── setup-complete.md
├── environment/                       # Variables d'environnement
│   ├── README.md
│   ├── configuration.md
│   └── examples/
├── backend/                           # Backend & Services
│   ├── supabase/
│   │   ├── README.md
│   │   ├── setup.md
│   │   ├── updates.md
│   │   └── examples/
│   └── http/
│       └── README.md
├── development/                       # Développement
│   ├── README.md
│   └── app-launcher.md
└── architecture/                      # Architecture
    ├── README.md
    └── project-structure.md
```

---

## 🔗 Liens Rapides

### Configuration
- [Makefile](../Makefile) - Toutes les commandes disponibles
- [VS Code Launch](../.vscode/launch.json) - Configurations de lancement

### Configuration Technique
- [config/example.json](../config/example.json) - Template de configuration

### Code Source
- [lib/core/config/](../lib/core/config/) - Configuration de l'app
- [lib/core/services/](../lib/core/services/) - Services (Supabase, etc.)

---

## 🆘 Support

**Besoin d'aide ?**

1. Consultez d'abord la documentation pertinente
2. Vérifiez les exemples de code dans la documentation
3. Consultez les logs d'erreur
4. Demandez à l'équipe

---

## 🤝 Contribuer à la Documentation

Cette documentation est vivante ! Pour l'améliorer :

1. Créez une branche
2. Modifiez ou ajoutez de la documentation
3. Créez une Pull Request
4. Mettez à jour les liens si nécessaire

**Merci de garder cette documentation à jour !** 📝

---

## 📊 Statut de la Documentation

| Section | Complétude | Dernière MAJ |
|---------|------------|--------------|
| Getting Started | ✅ Complet | Oct 2025 |
| Environment | ✅ Complet | Oct 2025 |
| Supabase | ✅ Complet | Oct 2025 |
| Development | ✅ Complet | Oct 2025 |
| Architecture | 🚧 En cours | Oct 2025 |

---

**[⬅️ Retour au README principal](../README.md)**

---

*Documentation maintenue par l'équipe BoxToBikers*  
*Dernière mise à jour : Octobre 2025*

