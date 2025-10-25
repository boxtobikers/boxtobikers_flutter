# Configuration des environnements

Ce dossier contient les fichiers de configuration pour les différents environnements de l'application.

## 📁 Fichiers

| Fichier | Environnement | Git | Description |
|---------|---------------|-----|-------------|
| `example.json` | Template | ✅ Commité | Template pour créer vos configs |
| `local.json` | Docker local | ✅ Commité | Configuration locale (pas de secrets) |
| `dev.json` | Development | ❌ Ignoré | Supabase.io développement |
| `prod.json` | Production | ❌ Ignoré | Supabase.io production |

## 🚀 Configuration initiale

### 1. Créer config/dev.json

```bash
cp config/example.json config/dev.json
```

Éditez `config/dev.json` avec vos clés Supabase de développement :
```json
{
  "SUPABASE_URL": "https://xxx.supabase.co",
  "SUPABASE_ANON_KEY": "votre_cle_anon",
  "API_URL": "https://api-dev.boxtobikers.com",
  "ENV": "development"
}
```

### 2. Créer config/prod.json

```bash
cp config/example.json config/prod.json
```

Éditez `config/prod.json` avec vos clés Supabase de production :
```json
{
  "SUPABASE_URL": "https://prod.supabase.co",
  "SUPABASE_ANON_KEY": "votre_cle_anon_prod",
  "API_URL": "https://api.boxtobikers.com",
  "ENV": "production"
}
```

### 3. local.json est déjà prêt

Aucune modification nécessaire, il utilise Docker local.

## 🔑 Où trouver les clés ?

1. Allez sur https://app.supabase.com
2. Sélectionnez votre projet
3. Allez dans `Settings` > `API`
4. Copiez :
   - **URL** : Project URL
   - **anon key** : anon/public key

## 🔒 Sécurité

- ⚠️ **Ne commitez JAMAIS `dev.json` ou `prod.json`**
- ✅ Ces fichiers sont déjà dans `.gitignore`
- ✅ `local.json` peut être commité (pas de secrets)
- ✅ `example.json` est un template (pas de vraies clés)

## 🎯 Utilisation

```bash
# Local (Docker)
make local

# Development (Supabase.io)
make dev

# Production (Supabase.io)
make prod
```

## 📚 Documentation

- [Guide de démarrage rapide](../docs/environment/QUICK_START.md)
- [Documentation complète](../docs/environment/README.md)
- [Guide de migration](../docs/environment/MIGRATION_LOCAL_CONFIG.md)

