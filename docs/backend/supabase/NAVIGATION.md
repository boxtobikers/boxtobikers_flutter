# 🗺️ Guide de Navigation - Documentation Supabase

**Vous cherchez quelque chose ? Voici où trouver l'information rapidement !**

---

## 🎯 Par objectif

### "Je veux démarrer rapidement"
→ **[setup.md](STARTER.md)** - Configuration en 5 minutes

### "Je veux tout comprendre en détail"
→ **[SETUP_GUIDE.md](SETUP_GUIDE.md)** - Guide complet

### "Je veux déployer automatiquement"
→ **[GITHUB_ACTIONS_SETUP.md](GITHUB_ACTIONS_SETUP.md)** - Configuration CI/CD

### "J'ai déjà une base de données"
→ **[MIGRATION_FROM_EXISTING.md](MIGRATION_FROM_EXISTING.md)** - Import du schéma

### "Ça ne marche pas !"
→ **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Solutions aux problèmes

### "Vue d'ensemble"
→ **[README.md](README.md)** - Index général

---

## 🚀 Commandes rapides

```bash
# Démarrer
make db-start

# Créer une migration
make db-migration name=ma_feature

# Générer depuis changements
make db-diff-migration name=ma_feature

# Réinitialiser
make db-reset

# Déployer
make db-push

# Troubleshoot
make db-status
make check-supabase
```

**[Toutes les commandes →](README.md#commandes-utiles)**

---

## 📚 Ressources externes

- [Documentation Supabase](https://supabase.com/docs) - Officielle
- [Supabase CLI](https://supabase.com/docs/guides/cli) - Commandes CLI
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security) - Guide RLS
- [Changelog supabase_flutter](https://pub.dev/packages/supabase_flutter/changelog) - Versions

---

**💡 Astuce :** Commencez par [setup.md](STARTER.md) si c'est votre première fois, puis consultez [SETUP_GUIDE.md](SETUP_GUIDE.md) pour approfondir !

