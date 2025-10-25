# 🔄 Migration vers la nouvelle configuration

## Changements effectués

### ✅ Suppression de l'environnement staging

L'environnement staging a été supprimé. Nous utilisons maintenant 3 environnements :

1. **local** - Docker Supabase (développement local)
2. **development** - Supabase.io (développement cloud)
3. **production** - Supabase.io (production)

### ✅ Nouvelle gestion des environnements

#### Avant
```bash
make dev      # Supabase.io dev
make staging  # Supabase.io staging ❌ SUPPRIMÉ
make prod     # Supabase.io prod
```

#### Maintenant
```bash
make local    # Docker local (nouveau) ⭐
make dev      # Supabase.io dev
make prod     # Supabase.io prod
```

### ✅ Détection automatique de la plateforme Android

Le système détecte maintenant automatiquement si vous êtes sur émulateur Android :

**Mode local** :
- Android Emulator → `http://10.0.2.2:54321`
- iOS Simulator → `http://localhost:54321`
- Desktop → `http://localhost:54321`
- Web → `http://localhost:54321`

Vous n'avez **rien à faire**, c'est automatique ! 🎉

### ✅ Fichiers de configuration

#### Fichiers créés
- ✅ `config/local.json` - Configuration pour Docker

#### Fichiers supprimés
- ❌ `config/staging.json` - Plus nécessaire

#### Fichiers conservés
- ✅ `config/dev.json` - Supabase.io développement
- ✅ `config/prod.json` - Supabase.io production

### ✅ Modifications du code

**`lib/core/config/env_config.dart`** :
- Ajout de la détection automatique de plateforme
- Support du mode `local`
- Suppression de `isStaging`
- Ajout de `isLocal`
- Clé Supabase locale hardcodée (sécurisé pour Docker)

## 🚀 Comment utiliser

### Mode local (Docker) - NOUVEAU ⭐

```bash
# 1. Démarrer Docker Supabase
make db-start

# 2. Lancer l'app en mode local
make local

# 3. L'app se connecte automatiquement à Docker
# - Android : http://10.0.2.2:54321
# - Autres : http://localhost:54321
```

**Avantages** :
- ✅ Pas besoin de connexion Internet
- ✅ Base de données isolée pour les tests
- ✅ Données de seed automatiques
- ✅ Pas de risque pour la prod

### Mode développement (Supabase.io)

```bash
# Lance l'app avec config/dev.json
make dev
```

**Utilise** :
- URL : Depuis `config/dev.json`
- Clé : Depuis `config/dev.json`

### Mode production (Supabase.io)

```bash
# Lance l'app avec config/prod.json
make prod
```

**Utilise** :
- URL : Depuis `config/prod.json`
- Clé : Depuis `config/prod.json`

## 🔍 Vérifier la configuration

Au démarrage, l'app affiche la configuration utilisée :

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

## 📱 Workflow recommandé

### Développement quotidien

```bash
# 1. Démarrer Docker le matin
make db-start

# 2. Développer en local
make local

# 3. Tester les changements
# Modifier le code, hot reload automatique

# 4. Arrêter Docker le soir
make db-stop
```

### Tester sur Supabase.io

```bash
# Basculer sur le cloud pour tester
make dev
```

### Déployer en production

```bash
# 1. Tester une dernière fois en dev
make dev

# 2. Build production
make build-android-prod

# 3. Déployer les migrations DB
make db-login
make db-link ref=VOTRE_PROJECT_REF
make db-push
```

## 🔧 Helpers dans le code

### Vérifier l'environnement

```dart
import 'package:boxtobikers/core/config/env_config.dart';

// Vérifier l'environnement
if (EnvConfig.isLocal) {
  print('Mode Docker local');
}

if (EnvConfig.isDevelopment) {
  print('Mode dev Supabase.io');
}

if (EnvConfig.isProduction) {
  print('Mode production');
}

// Accéder aux URLs (détection automatique)
String url = EnvConfig.supabaseUrl;  // Adapté à la plateforme
String key = EnvConfig.supabaseAnonKey;
```

### Valider la configuration

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Valider et afficher la config
  EnvConfig.validate();
  EnvConfig.printInfo();  // En dev/local seulement
  
  await Supabase.initialize(
    url: EnvConfig.supabaseUrl,
    anonKey: EnvConfig.supabaseAnonKey,
  );
  
  runApp(MyApp());
}
```

## 🐛 Dépannage

### L'émulateur Android ne se connecte pas

**Erreur** : `Connection refused` sur Android

**Solution** : C'est normal, le système utilise automatiquement `10.0.2.2`

Si ça ne marche pas :
1. Vérifiez que Docker est démarré : `make db-status`
2. Vérifiez que Supabase tourne : `docker ps | grep supabase`
3. Relancez l'app : `make local`

### Je veux forcer localhost

Si vous voulez tester `localhost` au lieu de la détection auto :

```dart
// Temporairement dans env_config.dart
static String get supabaseUrl {
  if (isLocal) {
    return 'http://localhost:54321';  // Forcer localhost
  }
  // ...
}
```

### L'app ne trouve pas la configuration

**Erreur** : `Configuration manquante : SUPABASE_URL`

**Cause** : Vous lancez avec `flutter run` au lieu de `make local`

**Solution** :
```bash
# ❌ Ne pas faire
flutter run

# ✅ Faire
make local
```

## 📚 Fichiers modifiés

- ✅ `lib/core/config/env_config.dart` - Nouvelle logique
- ✅ `config/local.json` - Nouveau fichier
- ✅ `Makefile` - Commandes mises à jour
- ✅ `README.md` - Documentation mise à jour
- ❌ `config/staging.json` - Supprimé

## ✨ Avantages

**Avant** :
- ❌ Staging inutilisé
- ❌ Pas de développement local
- ❌ Émulateur Android problématique
- ❌ Toujours besoin de connexion Internet

**Maintenant** :
- ✅ 3 environnements clairs
- ✅ Développement local avec Docker
- ✅ Détection automatique Android
- ✅ Développement offline possible
- ✅ Séparation locale/cloud claire

## 🎯 Prochaines étapes

1. **Testez le mode local** :
   ```bash
   make db-start
   make local
   ```

2. **Vérifiez que tout fonctionne** :
   - Connexion à la DB ✅
   - Authentification ✅
   - Requêtes ✅

3. **Développez en local** :
   - Modifiez le schéma dans Studio (http://localhost:54323)
   - Générez les migrations
   - Testez immédiatement

4. **Déployez quand prêt** :
   ```bash
   make db-push
   ```

---

**Migration terminée ! 🎉**

Vous pouvez maintenant développer en local avec Docker ou sur Supabase.io selon vos besoins.

