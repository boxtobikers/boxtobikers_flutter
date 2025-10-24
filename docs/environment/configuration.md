# 🔧 Configuration des Variables d'Environnement

Guide complet pour configurer et utiliser les variables d'environnement dans BoxToBikers.

---

## ⚡ Configuration Rapide

### 1. Créer le fichier de configuration

```bash
cp config/example.json config/dev.json
```

### 2. Obtenir vos clés Supabase

1. Allez sur https://supabase.com/dashboard
2. Sélectionnez votre projet
3. Cliquez sur "Settings" → "API"
4. Copiez :
   - **Project URL** → `SUPABASE_URL`
   - **anon public** → `SUPABASE_ANON_KEY`

### 3. Éditer `config/dev.json`

```json
{
  "SUPABASE_URL": "https://votre-projet.supabase.co",
  "SUPABASE_ANON_KEY": "votre_cle_anon",
  "API_URL": "https://api-dev.boxtobikers.com",
  "ENV": "development"
}
```

### 4. Lancer l'application

```bash
make dev
```

**C'est tout ! 🎉**

---

## 📋 Variables Disponibles

| Variable | Description | Requis | Exemple |
|----------|-------------|--------|---------|
| `SUPABASE_URL` | URL de votre instance Supabase | ✅ Oui | `https://xxx.supabase.co` |
| `SUPABASE_ANON_KEY` | Clé anonyme publique Supabase | ✅ Oui | `eyJhbGc...` |
| `API_URL` | URL de l'API backend | ⚠️ Optionnel | `https://api.example.com` |
| `ENV` | Environnement d'exécution | ✅ Oui | `development` |

---

## 🎯 Utilisation dans le Code

### Accéder aux variables

```text
import 'package:boxtobikers/core/config/env_config.dart';

// Récupérer les valeurs
String supabaseUrl = EnvConfig.supabaseUrl;
String supabaseKey = EnvConfig.supabaseAnonKey;
String apiUrl = EnvConfig.apiUrl;

// Vérifier l'environnement
if (EnvConfig.isDevelopment) {
  print('Mode développement activé');
}

if (EnvConfig.isProduction) {
  print('Mode production activé');
}

// Vérifier la validité
if (EnvConfig.isValid) {
  print('Configuration OK');
}
```

### Initialiser au démarrage

```text
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Valider la configuration
  EnvConfig.validate();
  
  // Afficher les infos (dev uniquement)
  EnvConfig.printInfo();

  runApp(MyApp());
}
```

**[Voir l'exemple complet →](examples/main_with_env_example.dart)**

---

## 🔄 Environnements Multiples

### Development

```bash
make dev
# ou
flutter run --dart-define-from-file=config/dev.json
```

### Staging

```bash
make staging
# ou
flutter run --dart-define-from-file=config/staging.json
```

### Production

```bash
make prod
# ou
flutter run --dart-define-from-file=config/prod.json
```

---

## 📱 Configuration VS Code

Trois configurations disponibles (`.vscode/launch.json`) :

1. **BoxToBikers (Development)** - `config/dev.json`
2. **BoxToBikers (Staging)** - `config/staging.json`
3. **BoxToBikers (Production)** - `config/prod.json`

**Utilisation :**
- Appuyez sur `F5`
- Sélectionnez l'environnement désiré

---

## 🏗️ Build pour Production

### Android

```bash
flutter build apk --release --dart-define-from-file=config/prod.json
# ou
make build-android-prod
```

### iOS

```bash
flutter build ios --release --dart-define-from-file=config/prod.json
# ou
make build-ios-prod
```

---

## 🔒 Sécurité

### ✅ Bonnes Pratiques

1. **Fichiers protégés**
   - `config/*.json` sont dans `.gitignore`
   - Seul `example.json` est commité

2. **Clés séparées**
   - Utilisez des clés différentes pour dev/staging/prod
   - Ne réutilisez jamais les clés de production en dev

3. **Validation automatique**
   - `EnvConfig.validate()` vérifie les variables au démarrage
   - L'app refuse de démarrer si la config est invalide

### ❌ À Éviter

- ❌ Committer `config/dev.json`, `staging.json`, `prod.json`
- ❌ Hardcoder les clés dans le code
- ❌ Partager les clés par email/Slack
- ❌ Logger les clés sensibles
- ❌ Utiliser les mêmes clés en dev et prod

---

## 🧪 Tests

### Vérifier la configuration

```bash
# Script de vérification
./check_env_config.sh

# Tests unitaires
flutter test test/core/config/env_config_test.dart
```

### Tests manuels

```text
// Vérifier que les variables sont chargées
print('URL: ${EnvConfig.supabaseUrl}');
print('Key: ${EnvConfig.supabaseAnonKey.isNotEmpty}');
print('Env: ${EnvConfig.environment}');
print('Valid: ${EnvConfig.isValid}');
```

---

## ❗ Résolution des Problèmes

### "Configuration manquante : SUPABASE_URL"

**Cause :** Variables d'environnement non chargées

**Solution :**
```bash
make dev
```

### "No such file: config/dev.json"

**Cause :** Fichier non créé

**Solution :**
```bash
cp config/example.json config/dev.json
# Éditez ensuite avec vos clés
```

### Variables vides dans le code

**Cause :** Syntaxe JSON invalide

**Solution :**
- Vérifiez la syntaxe (pas de virgule finale)
- Validez avec un outil JSON en ligne
- Comparez avec `example.json`

### L'app ne démarre pas dans VS Code

**Cause :** Configuration manquante

**Solution :**
- Vérifiez `.vscode/launch.json`
- Redémarrez VS Code
- Sélectionnez la bonne configuration

---

## 📚 Ressources

- **[Quick Start](../getting-started/quick-start.md)** - Démarrage rapide
- **[Installation complète](../getting-started/setup-complete.md)** - Détails
- **[Exemple de code](examples/main_with_env_example.dart)** - Exemple d'utilisation
- **[Guide Supabase](../backend/supabase/README.md)** - Intégration backend

---

## 🎓 Pour Aller Plus Loin

### Ajouter de nouvelles variables

1. Ajouter dans `config/*.json` :
```json
{
  "MA_NOUVELLE_VAR": "valeur"
}
```

2. Ajouter dans `EnvConfig` :
```text
static const String maVariable = String.fromEnvironment(
  'MA_NOUVELLE_VAR',
  defaultValue: '',
);
```

3. Utiliser :
```text
String valeur = EnvConfig.maVariable;
```

### CI/CD

Pour les pipelines CI/CD, créez les fichiers de config dynamiquement :

```bash
# Dans votre CI
echo '{"SUPABASE_URL":"$CI_SUPABASE_URL",...}' > config/prod.json
flutter build apk --dart-define-from-file=config/prod.json
```

---

📖 **[Retour à la documentation →](../README.md)**

