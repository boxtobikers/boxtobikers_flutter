# 🚀 Guide de Démarrage - BoxToBikers

Bienvenue dans le projet BoxToBikers ! Ce guide vous aidera à mettre en place votre environnement de développement.

---

## 📋 Prérequis

Avant de commencer, assurez-vous d'avoir :

- ✅ **Flutter SDK 3.9.2+** installé
- ✅ **Un compte Supabase** (gratuit sur https://supabase.com)
- ✅ **Un éditeur de code** (VS Code recommandé)
- ✅ **Git** pour cloner le projet

---

## ⚡ Installation Rapide

### 1. Cloner le projet

```bash
git clone <url-du-repo>
cd flutter
```

### 2. Installer les dépendances

```bash
flutter pub get
```

### 3. Configurer les variables d'environnement

```bash
# Copier le template
cp config/example.json config/dev.json

# Éditer avec vos clés Supabase
nano config/dev.json
```

**📖 [Guide détaillé de configuration →](../environment/configuration.md)**

### 4. Lancer l'application

```bash
make dev
```

**C'est tout ! 🎉**

---

## 📱 Lancement dans VS Code

1. Ouvrez le projet dans VS Code
2. Appuyez sur `F5`
3. Sélectionnez **"BoxToBikers (Development)"**
4. L'app démarre automatiquement

---

## ✅ Vérifier que tout fonctionne

Après le lancement, vous devriez voir dans la console :

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Configuration de l'environnement
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌍 Environnement : development
🔗 Supabase URL : https://xxxxx.supabase.co
🔑 Supabase Key : ✓ Définie
✅ Configuration valide : Oui
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✅ Supabase initialisé : https://xxxxx.supabase.co
```

Si vous voyez ce message → **Tout fonctionne !** ✅

---

## 🎯 Prochaines Étapes

Maintenant que votre environnement est configuré :

1. **[Découvrir l'architecture](../architecture/README.md)** - Comprendre la structure du projet
2. **[Guide développeur](../development/README.md)** - Astuces pour le développement
3. **[Guide Supabase](../backend/supabase/README.md)** - Utiliser le backend
4. **[Commencer à coder !](../development/features.md)** - Fonctionnalités disponibles

---

## 🧰 Commandes Essentielles

```bash
# Développement
make dev              # Lancer en mode développement
make staging          # Lancer en mode staging
make prod             # Lancer en mode production

# Tests
make test             # Lancer tous les tests
make test-coverage    # Tests avec rapport de couverture

# Build
make build-android-prod  # Build Android pour production
make build-ios-prod      # Build iOS pour production

# Maintenance
make clean            # Nettoyer le projet
make clean-all        # Nettoyage complet
make help             # Afficher toutes les commandes
```

---

## 📚 Documentation Complémentaire

### Configuration
- **[Quick Start](quick-start.md)** - Démarrage ultra-rapide (3 min)
- **[Installation complète](setup-complete.md)** - Tous les détails

### Environnement
- **[Variables d'environnement](../environment/README.md)** - Guide technique
- **[Configuration](../environment/configuration.md)** - Pas à pas

### Backend
- **[Supabase](../backend/supabase/README.md)** - Intégration complète
- **[HTTP Client](../backend/http/README.md)** - Configuration Dio

---

## 🆘 Problèmes Courants

### "Configuration manquante : SUPABASE_URL"

**Cause** : Vous n'avez pas lancé avec les variables d'environnement

**Solution** :
```bash
make dev
```

### "No such file: config/dev.json"

**Cause** : Le fichier de configuration n'existe pas

**Solution** :
```bash
cp config/example.json config/dev.json
# Éditez ensuite avec vos clés
```

### L'app ne démarre pas dans VS Code

**Cause** : Configuration VS Code manquante ou incorrecte

**Solution** :
- Vérifiez que `.vscode/launch.json` existe
- Redémarrez VS Code
- Sélectionnez "BoxToBikers (Development)" dans le menu debug

### Les variables sont vides

**Cause** : Syntaxe JSON invalide

**Solution** :
- Vérifiez la syntaxe JSON (pas de virgule finale, guillemets corrects)
- Utilisez un validateur JSON en ligne
- Comparez avec `config/example.json`

---

## 🔒 Sécurité - Important !

### ✅ À faire
- Garder `config/*.json` dans `.gitignore` (déjà fait)
- Utiliser des clés différentes pour dev/staging/prod
- Ne jamais hardcoder les clés dans le code

### ❌ À ne jamais faire
- Committer `config/dev.json`, `config/staging.json`, `config/prod.json`
- Partager vos clés API par email ou Slack
- Publier vos clés dans les logs ou le code

**📖 [En savoir plus sur la sécurité →](../environment/README.md#-sécurité)**

---

## 📊 Checklist d'Installation

- [ ] ✅ Flutter SDK installé et à jour
- [ ] ✅ Projet cloné
- [ ] ✅ Dépendances installées (`flutter pub get`)
- [ ] ✅ Compte Supabase créé
- [ ] ✅ `config/dev.json` créé et rempli
- [ ] ✅ Application lancée (`make dev`)
- [ ] ✅ Message de configuration affiché
- [ ] ✅ Pas d'erreur au démarrage

---

## 🎓 Ressources Utiles

### Documentation du projet
- **[Index de la documentation](../README.md)** - Table des matières
- **[Architecture](../architecture/README.md)** - Structure du projet
- **[Guide développeur](../development/README.md)** - Développement quotidien

### Documentation externe
- **[Flutter](https://flutter.dev/docs)** - Documentation officielle Flutter
- **[Supabase](https://supabase.com/docs)** - Documentation Supabase
- **[Dart](https://dart.dev/guides)** - Language Dart

---

## 🤝 Besoin d'Aide ?

1. Consultez d'abord la [documentation](../README.md)
2. Vérifiez les [problèmes courants](#-problèmes-courants)
3. Consultez les logs d'erreur
4. Demandez à l'équipe

---

**Prêt à développer ? [Découvrez l'architecture →](../architecture/README.md)** 🚀

---

📖 **[Retour à l'index de la documentation](../README.md)**

