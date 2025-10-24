# 🚀 Guide Supabase - BoxToBikers

Guide complet pour utiliser Supabase dans l'application BoxToBikers.

---

## ✅ Configuration

Supabase est déjà configuré dans le projet avec :
- ✅ `supabase_flutter: ^2.10.3` dans `pubspec.yaml`
- ✅ Service Supabase (`lib/core/services/supabase_service.dart`)
- ✅ Initialisation automatique au démarrage
- ✅ Variables d'environnement sécurisées

**[Configuration détaillée →](setup.md)**

---

## 💻 Utilisation Rapide

### Authentification

```text
import 'package:boxtobikers/core/services/supabase_service.dart';

// Se connecter
final response = await SupabaseService.instance.signInWithEmail(
  email: 'user@example.com',
  password: 'password',
);

// Vérifier si connecté
if (SupabaseService.instance.isAuthenticated) {
  final user = SupabaseService.instance.currentUser;
}

// Se déconnecter
await SupabaseService.instance.signOut();
```

### Données (CRUD)

```text
// Lire
final users = await SupabaseService.instance.getTableData('users');

// Créer
await SupabaseService.instance.insertData('users', {
  'email': 'user@example.com',
  'name': 'John Doe',
});

// Mettre à jour
await SupabaseService.instance.updateData('users', 'id', {
  'name': 'Jane Doe',
});

// Supprimer
await SupabaseService.instance.deleteData('users', 'id');
```

### Requêtes Personnalisées

```text
final supabase = SupabaseService.instance.client;

final bikers = await supabase
    .from('users')
    .select('id, email, full_name')
    .eq('role', 'biker')
    .order('created_at', ascending: false);
```

---

## 🏗️ Exemples d'Intégration


### Provider d'Authentification

```text
class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _currentUser = SupabaseService.instance.currentUser;
    
    SupabaseService.instance.authStateChanges.listen((state) {
      _currentUser = state.session?.user;
      notifyListeners();
    });
  }

  Future<void> signIn(String email, String password) async {
    final response = await SupabaseService.instance.signInWithEmail(
      email: email,
      password: password,
    );
    _currentUser = response.user;
    notifyListeners();
  }
}
```

---

## 🔒 Sécurité

### Row Level Security (RLS)

Activez RLS sur vos tables Supabase :

```sql
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own profile"
ON users FOR SELECT
USING (auth.uid() = id);
```

### Gestion des Erreurs

```text
try {
  final data = await SupabaseService.instance.getTableData('users');
} on PostgrestException catch (e) {
  debugPrint('Erreur Supabase : ${e.message}');
} catch (e) {
  debugPrint('Erreur : $e');
}
```

---

## 📚 Ressources

### Documentation du projet
- **[Configuration](setup.md)** - Mise en place détaillée
- **[Mises à jour](updates.md)** - Changelog et versions

### Documentation externe
- **[Supabase Docs](https://supabase.com/docs)** - Documentation officielle
- **[Supabase Flutter](https://supabase.com/docs/reference/dart)** - API Dart
- **[Dashboard](https://supabase.com/dashboard)** - Console Supabase

---

## 🆘 Problèmes Courants

### "Invalid API key"
→ Vérifiez `SUPABASE_ANON_KEY` dans `config/dev.json`

### "Failed to initialize"
→ Lancez `flutter pub get`

### "Not authenticated"
→ Connectez-vous d'abord avec `signInWithEmail()`

---

📖 **[Retour à la documentation →](../../README.md)**

