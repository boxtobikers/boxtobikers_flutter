# Configurations de lancement Android Studio / IntelliJ

Ce dossier contient les configurations de lancement prédéfinies pour Android Studio et IntelliJ IDEA.

## Configurations disponibles

### 🏠 main.dart (local)
Lance l'application en mode **local** avec Docker Supabase.
- Configuration : `config/local.json`
- URL Supabase : http://10.0.2.2:54321 (Android) ou http://localhost:54321 (iOS/Desktop)
- Clé anonyme : clé par défaut de Supabase CLI

### 🔧 main.dart (dev)
Lance l'application en mode **développement** avec Supabase.io.
- Configuration : `config/dev.json`
- URL Supabase : https://lnoondakrogdriiwqtcp.supabase.co
- Environnement : development

### 🚀 main.dart (prod)
Lance l'application en mode **production** avec Supabase.io.
- Configuration : `config/prod.json`
- URL Supabase : définie dans config/prod.json
- Environnement : production

## Comment utiliser

1. Dans Android Studio, ouvrez le sélecteur de configuration (en haut à droite)
2. Sélectionnez la configuration souhaitée (local, dev ou prod)
3. Cliquez sur le bouton Run (▶) ou Debug (🐛)

## Alternative en ligne de commande

Vous pouvez aussi lancer l'application depuis le terminal :

```bash
# Mode local (Docker)
flutter run --dart-define-from-file=config/local.json

# Mode développement
flutter run --dart-define-from-file=config/dev.json

# Mode production
flutter run --dart-define-from-file=config/prod.json
```

Ou utiliser les commandes make :

```bash
make local   # Lance en mode local
make dev     # Lance en mode développement
make prod    # Lance en mode production
```

## Note importante

⚠️ Ne lancez jamais `main.dart` sans sélectionner une configuration !
Cela provoquera l'erreur : "Configuration manquante : SUPABASE_URL"

## Plus d'informations

Consultez la documentation dans `docs/environment/` pour plus de détails sur la configuration des environnements.

