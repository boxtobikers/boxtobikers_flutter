# 🎯 BoxToBikers - Démarrage Rapide

## ⚡ Installation en 3 minutes

### 1️⃣ Copier le template de configuration
```bash
cp config/example.json config/dev.json
```

### 2️⃣ Obtenir vos clés Supabase

**Allez sur :** https://supabase.com/dashboard

1. Sélectionnez votre projet
2. `Settings` → `API`
3. Copiez :
   - **Project URL** 
   - **anon public**

### 3️⃣ Éditer config/dev.json
```json
{
  "SUPABASE_URL": "COLLEZ_ICI",
  "SUPABASE_ANON_KEY": "COLLEZ_ICI",
  "ENV": "development"
}
```

### 4️⃣ Lancer l'app
```bash
make dev
```

**C'est tout ! 🎉**

---

## 📱 VS Code

**Appuyez sur `F5`** → Sélectionnez **"BoxToBikers (Development)"**

---

## 🧰 Commandes

```bash
make dev      # 🚀 Lancer en dev
make test     # 🧪 Tests
make clean    # 🧹 Nettoyer
make help     # 📖 Aide
```

---

## ⚠️ Sécurité

- ❌ Ne JAMAIS commit `config/dev.json`
- ❌ Ne JAMAIS partager vos clés
- ✅ Déjà protégé par `.gitignore`

---

## 📚 Documentation Complémentaire

| Document | Description |
|----------|-------------|
| [Configuration détaillée](../environment/configuration.md) | Guide complet des variables d'env |
| [Variables d'environnement](../environment/README.md) | Documentation technique |
| [Installation complète](setup-complete.md) | Tous les détails de l'installation |
| [Guide Supabase](../backend/supabase/README.md) | Intégration backend |

---

## 🆘 Problèmes ?

**"Configuration manquante"** → `make dev`  
**"File not found"** → `cp config/example.json config/dev.json`  
**VS Code** → Vérifier `.vscode/launch.json`

---

📖 **[Retour à l'index de la documentation](../README.md)**

