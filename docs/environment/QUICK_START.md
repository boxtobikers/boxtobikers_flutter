# 🚀 Guide de démarrage rapide - Environnements

## 3 environnements disponibles

### 🐳 Local (Docker) - Recommandé pour le développement

**Quand l'utiliser** :
- Développement quotidien
- Tests de nouvelles fonctionnalités
- Pas besoin de connexion Internet
- Modifications du schéma DB

**Prérequis** :
```bash
# 1. Docker Desktop installé et démarré
# 2. Supabase CLI installé
make check-supabase
```

**Lancer** :
```bash
# Démarrer Docker Supabase
make db-start

# Lancer l'app
make local
```

**Avantages** :
- ✅ Base de données isolée
- ✅ Données de seed automatiques
- ✅ Pas de risque pour la prod
- ✅ Détection automatique émulateur Android

**URL utilisée** :
- Android Emulator : `http://10.0.2.2:54321`
- iOS/Desktop : `http://localhost:54321`

---

### ☁️ Development (Supabase.io)

**Quand l'utiliser** :
- Tester avec des données réelles
- Collaboration en équipe
- Tests d'intégration

**Configuration requise** :
Créez `config/dev.json` :
```json
{
  "SUPABASE_URL": "https://xxx.supabase.co",
  "SUPABASE_ANON_KEY": "eyJhbGc...",
  "API_URL": "https://api-dev.boxtobikers.com",
  "ENV": "development"
}
```

**Lancer** :
```bash
make dev
```

---

### 🚀 Production (Supabase.io)

**Quand l'utiliser** :
- Tests finaux avant release
- Build de production

**Configuration requise** :
Créez `config/prod.json` :
```json
{
  "SUPABASE_URL": "https://prod.supabase.co",
  "SUPABASE_ANON_KEY": "eyJhbGc...",
  "API_URL": "https://api.boxtobikers.com",
  "ENV": "production"
}
```

**Lancer** :
```bash
make prod
```

---

## 🔀 Switcher entre environnements

### Méthode 1 : Make (Recommandé)

```bash
make local    # Docker local
make dev      # Supabase.io dev
make prod     # Production
```

### Méthode 2 : VS Code

1. Appuyez sur `F5`
2. Sélectionnez :
   - `BoxToBikers (Local - Docker)`
   - `BoxToBikers (Development)`
   - `BoxToBikers (Production)`

### Méthode 3 : Ligne de commande

```bash
flutter run --dart-define-from-file=config/local.json
flutter run --dart-define-from-file=config/dev.json
flutter run --dart-define-from-file=config/prod.json
```

---

## 📱 Workflow recommandé

### Développement quotidien

```bash
# Matin : démarrer Docker
make db-start

# Développer
make local

# Modifier le schéma si besoin
open http://localhost:54323

# Générer la migration
make db-diff-migration name=ma_feature

# Tester
make db-reset

# Soir : arrêter Docker
make db-stop
```

### Avant de commiter

```bash
# 1. Tester en local
make local

# 2. Tester sur dev cloud
make dev

# 3. Si tout est OK, commiter
git add .
git commit -m "feat: nouvelle fonctionnalité"
git push
```

### Déploiement en production

```bash
# 1. Déployer les migrations DB
make db-login
make db-link ref=VOTRE_PROJECT_REF
make db-push

# 2. Tester l'app en prod
make prod

# 3. Build pour release
make build-android-prod
```

---

## 🐛 Problèmes courants

### Android Emulator ne se connecte pas

**Symptôme** : Connection refused

**Solution** : Le système utilise automatiquement `10.0.2.2`. 

Vérifiez :
```bash
# Docker est bien démarré ?
make db-status

# Supabase est bien lancé ?
docker ps | grep supabase
```

### Configuration manquante

**Erreur** : `SUPABASE_URL not found`

**Solution** : 
```bash
# Utilisez make au lieu de flutter run
make local  # au lieu de flutter run
```

### Je veux changer d'environnement

Stoppez l'app (`Ctrl+C`) et relancez :
```bash
make local  # ou make dev ou make prod
```

---

## 🔍 Vérifier la configuration

L'app affiche automatiquement l'environnement au démarrage :

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
📋 Configuration de l'environnement
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
🌍 Environnement : local
🐳 Mode : Docker Local
📱 Plateforme : Android
🔗 Supabase URL : http://10.0.2.2:54321
🔑 Supabase Key : ✓ Définie
✅ Configuration valide : Oui
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 📚 En savoir plus

- [Documentation complète des environnements](README.md)
- [Guide de migration](MIGRATION_LOCAL_CONFIG.md)
- [Configuration Supabase](../backend/supabase/SETUP_GUIDE.md)

