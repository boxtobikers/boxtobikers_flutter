# 🔐 Documentation Authentification - BoxToBikers

Bienvenue dans la documentation du système d'authentification de BoxToBikers.

## 📚 Guides disponibles

| Document | Description | Pour qui ? | Temps |
|----------|-------------|-----------|-------|
| **[VISITOR_SYSTEM.md](VISITOR_SYSTEM.md)** | 👤 **NOUVEAU !** Système VISITOR avec profil pré-créé | Développeurs | 15 min |
| **[QUICK_START.md](QUICK_START.md)** | ⚡ Démarrage rapide - Comment tester | Tous | 5 min |
| **[IMPLEMENTATION_COMPLETE.md](IMPLEMENTATION_COMPLETE.md)** | ✅ Vue complète de l'implémentation | Tech Lead | 20 min |
| **[COMMANDS.md](COMMANDS.md)** | 🛠️ Commandes et exemples de code | Développeurs | 10 min |
| **[CHANGELOG.md](CHANGELOG.md)** | 📝 Historique des modifications | Tous | 3 min |

## 🚀 Par où commencer ?

### Vous découvrez le projet ?
1. Lisez **[QUICK_START.md](QUICK_START.md)** pour tester rapidement
2. Consultez **[VISITOR_SYSTEM.md](VISITOR_SYSTEM.md)** pour comprendre le système
3. Parcourez **[IMPLEMENTATION_COMPLETE.md](IMPLEMENTATION_COMPLETE.md)** pour la vue d'ensemble

### Vous devez implémenter une fonctionnalité ?
1. Consultez **[COMMANDS.md](COMMANDS.md)** pour les exemples de code
2. Référez-vous à **[VISITOR_SYSTEM.md](VISITOR_SYSTEM.md)** pour les concepts
3. Suivez les patterns dans **[IMPLEMENTATION_COMPLETE.md](IMPLEMENTATION_COMPLETE.md)**

### Vous déboguez un problème ?
1. Consultez la section "Dépannage" dans **[VISITOR_SYSTEM.md](VISITOR_SYSTEM.md)**
2. Vérifiez les logs dans **[QUICK_START.md](QUICK_START.md)**
3. Référez-vous à **[IMPLEMENTATION_COMPLETE.md](IMPLEMENTATION_COMPLETE.md)** pour l'architecture

## 🎯 Concepts clés

### Système VISITOR (Nouveau - v2.0)

Le système d'authentification de BoxToBikers utilise un **profil VISITOR unique pré-créé** pour tous les utilisateurs non connectés.

**Caractéristiques :**
- ✅ Un seul profil VISITOR partagé (UUID: `00000000-0000-0000-0000-000000000000`)
- ✅ Aucun utilisateur Supabase créé pour les visiteurs
- ✅ Session locale uniquement (SharedPreferences)
- ✅ Accès en lecture seule aux données publiques
- ✅ Transition fluide vers connexion/inscription

**Voir [VISITOR_SYSTEM.md](VISITOR_SYSTEM.md) pour tous les détails**

### Rôles utilisateur

| Rôle | Description | Authentification | Permissions |
|------|-------------|------------------|-------------|
| **VISITOR** | Utilisateur non connecté | ❌ Non | Lecture seule |
| **CLIENT** | Utilisateur inscrit | ✅ Oui | Créer rides, ratings, modifier profil |
| **ADMIN** | Administrateur | ✅ Oui | Accès complet, gestion destinations |

### Architecture

```
┌─────────────────────────────────────────┐
│           Presentation Layer             │
│  (Widgets, Pages, AuthGuard)            │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│          Business Logic Layer            │
│  (AuthProvider - ChangeNotifier)        │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│            Data Layer                    │
│  (AuthRepository, SessionService)       │
└────────────────┬────────────────────────┘
                 │
┌────────────────▼────────────────────────┐
│         External Services                │
│  (Supabase Auth, SharedPreferences)     │
└─────────────────────────────────────────┘
```

## 🔄 Flux d'authentification

### 1. Première installation
```
App démarre
  → Aucune session trouvée
  → Création session VISITOR locale
  → Profil VISITOR pré-créé (UUID fixe)
  → App accessible en lecture seule
```

### 2. Connexion
```
User VISITOR clique "Se connecter"
  → Email + Password
  → Authentification Supabase
  → Récupération profil CLIENT
  → Mise à jour session (VISITOR → CLIENT)
  → Accès complet débloqué
```

### 3. Inscription
```
User VISITOR clique "S'inscrire"
  → Email + Password + Données
  → Création compte Supabase
  → Trigger crée profil CLIENT
  → Session CLIENT créée
  → Accès complet immédiat
```

### 4. Déconnexion
```
User CLIENT clique "Se déconnecter"
  → Déconnexion Supabase
  → Suppression session locale
  → Recréation session VISITOR
  → Retour en mode lecture seule
```

## 📦 Installation

### Prérequis
- Flutter >= 3.0.0
- Supabase CLI
- Docker (pour Supabase local)

### Étapes d'installation

```bash
# 1. Démarrer Supabase local et créer le profil VISITOR
cd /Users/emmanuelgrenier/Projects/boxtobikers/flutter
supabase db reset

# 2. Vérifier que le profil VISITOR existe
# Ouvrir http://127.0.0.1:54323
# Table Editor → profiles → id = 00000000-0000-0000-0000-000000000000

# 3. Lancer l'application
flutter run
```

**Voir [QUICK_START.md](QUICK_START.md) pour plus de détails**

## 🧪 Tests

### Tester en mode VISITOR
```dart
// L'app démarre automatiquement en mode VISITOR
// Vérifier :
- ✅ Navigation possible dans l'app
- ✅ Destinations visibles
- ❌ Impossible de créer rides/ratings
- Message: "Connectez-vous pour accéder à cette fonctionnalité"
```

### Tester la connexion
```dart
// Se connecter avec des identifiants existants
final authProvider = context.read<AuthProvider>();
await authProvider.signInWithEmail(
  email: 'test@example.com',
  password: 'password123',
);

// Vérifier :
- ✅ Role passe à CLIENT
- ✅ Fonctionnalités débloquées
- ✅ Session persistée
```

### Tester la déconnexion
```dart
await authProvider.signOut();

// Vérifier :
- ✅ Retour en mode VISITOR
- ✅ Session locale VISITOR créée
- ✅ App reste accessible
```

## 🔒 Sécurité

### Row Level Security (RLS)
Toutes les tables ont des policies RLS strictes :
- Les VISITOR peuvent uniquement lire les données publiques
- Les CLIENT/ADMIN ont accès en écriture à leurs propres données
- Les ADMIN ont des permissions étendues

### Validation
- **Côté serveur** : Policies Supabase (RLS)
- **Côté client** : AuthGuard pour l'UX

### Bonnes pratiques
- ✅ Toujours utiliser AuthGuard pour les routes sensibles
- ✅ Vérifier les permissions côté serveur (RLS)
- ✅ Ne jamais stocker de mots de passe en clair
- ✅ Utiliser les tokens Supabase pour l'authentification

## 📝 Exemples de code

### Vérifier le rôle utilisateur
```dart
final authProvider = context.watch<AuthProvider>();

if (authProvider.currentSession?.role == UserRole.visitor) {
  // Afficher message "Connexion requise"
} else {
  // Fonctionnalité accessible
}
```

### Protéger une route
```dart
AuthGuard(
  allowedRoles: [UserRole.client, UserRole.admin],
  child: CreateRidePage(),
  deniedMessage: 'Connectez-vous pour créer un trajet',
)
```

### Écouter les changements de session
```dart
Consumer<AuthProvider>(
  builder: (context, authProvider, child) {
    if (authProvider.status == AuthStatus.anonymous) {
      return VisitorHomePage();
    } else if (authProvider.status == AuthStatus.authenticated) {
      return AuthenticatedHomePage();
    }
    return LoadingPage();
  },
)
```

**Voir [COMMANDS.md](COMMANDS.md) pour plus d'exemples**

## 🐛 Dépannage

### Erreur : "Profil VISITOR non trouvé"
```bash
supabase db reset
```

### Erreur : "Permission denied"
Vérifier que les migrations RLS sont appliquées :
```bash
supabase db reset
```

### Session ne persiste pas
Vérifier les logs de `SessionService` et s'assurer que `saveSession()` est appelé.

**Voir section "Dépannage" dans [VISITOR_SYSTEM.md](VISITOR_SYSTEM.md)**

## 🔄 Changelog

Voir [CHANGELOG.md](CHANGELOG.md) pour l'historique complet des modifications.

### Version actuelle : 2.0 (28 octobre 2024)
- ✨ **Nouveau système VISITOR avec profil pré-créé**
- 🗑️ Suppression de l'authentification anonyme Supabase
- 📦 Ajout de seed.sql avec profil VISITOR
- 🔒 Mise à jour des RLS policies
- 📚 Documentation complète du système VISITOR

## 📞 Support

Pour toute question ou problème :
1. Consultez la documentation appropriée ci-dessus
2. Vérifiez les logs Flutter et Supabase
3. Référez-vous aux exemples de code dans [COMMANDS.md](COMMANDS.md)

## ✅ Checklist de mise en production

Avant de déployer :
- [ ] Profil VISITOR créé en production
- [ ] Migrations appliquées
- [ ] RLS policies vérifiées
- [ ] Tests de bout en bout effectués
- [ ] Documentation à jour
- [ ] Logs de production configurés
- [ ] Variables d'environnement production configurées

---

**Dernière mise à jour** : 28 octobre 2024  
**Version** : 2.0 - Système VISITOR avec profil pré-créé

