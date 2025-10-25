# 🚀 Lancement de l'application depuis Android Studio

## ❌ Erreur : Configuration manquante SUPABASE_URL

Si vous obtenez cette erreur lors du lancement depuis Android Studio :

```
flutter: ❌ Erreur de configuration : Exception: ❌ Configuration manquante : SUPABASE_URL
flutter: 💡 Lancez l'application avec :
flutter:    flutter run --dart-define-from-file=config/dev.json
flutter:    ou : make dev
```

C'est parce que l'application nécessite des variables d'environnement qui ne sont pas passées automatiquement.

## ✅ Solution

### Option 1 : Utiliser les configurations prédéfinies (RECOMMANDÉ)

Des configurations de lancement ont été créées dans le dossier `.run/`. Elles sont automatiquement détectées par Android Studio.

**Comment faire :**

1. En haut à droite d'Android Studio, cliquez sur le sélecteur de configuration (à côté du bouton Run ▶)
2. Vous verrez apparaître 3 configurations :
   - **main.dart (local)** - Pour le développement local avec Docker Supabase
   - **main.dart (dev)** - Pour l'environnement de développement (Supabase.io)
   - **main.dart (prod)** - Pour l'environnement de production
3. Sélectionnez la configuration souhaitée (généralement "main.dart (dev)")
4. Cliquez sur Run ▶ ou Debug 🐛

### Option 2 : Modifier la configuration existante

Si vous avez déjà une configuration "main.dart" :

1. Cliquez sur le sélecteur de configuration
2. Sélectionnez "Edit Configurations..."
3. Dans la configuration "main.dart", ajoutez dans "Additional run args" :
   ```
   --dart-define-from-file=config/dev.json
   ```
4. Cliquez sur "Apply" puis "OK"

### Option 3 : Ligne de commande

Vous pouvez aussi lancer l'application depuis le terminal intégré :

```bash
# Mode développement
flutter run --dart-define-from-file=config/dev.json

# Ou avec make
make dev
```

## 📁 Fichiers de configuration disponibles

- **config/local.json** - Docker Supabase local (http://localhost:54321)
- **config/dev.json** - Supabase.io développement
- **config/prod.json** - Supabase.io production

## 🔍 Vérification de la configuration

Après avoir sélectionné une configuration, au lancement vous devriez voir :

```
✅ Mode development détecté
📡 Supabase URL: https://lnoondakrogdriiwqtcp.supabase.co
🔑 Anon Key: eyJhbGci...
🌍 API URL: https://api-dev.boxtobikers.com
```

## 📚 Plus d'informations

- Documentation environnements : `docs/environment/`
- Configurations de lancement : `.run/README.md`
- Configuration Supabase : `docs/backend/`

## ⚠️ Note importante

Ne lancez jamais `main.dart` directement sans sélectionner une configuration prédéfinie ou sans passer les arguments `--dart-define-from-file`. L'application nécessite absolument ces variables d'environnement pour fonctionner.

