import 'package:boxtobikers/core/http/index.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Exemple d'utilisation du service HTTP centralisé
/// Ce fichier montre comment utiliser le HttpService dans votre application

// Modèles d'exemple
class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

/// Service d'exemple pour les utilisateurs
class UserService {
  static const String _basePath = '/users';

  /// Récupère tous les utilisateurs
  static Future<List<User>> getAllUsers() async {
    final response = await HttpService.instance.get<Map<String, dynamic>>(_basePath);

    if (response.success && response.data != null) {
      final List<dynamic> usersJson = response.data!['users'] ?? [];
      return usersJson.map((json) => User.fromJson(json)).toList();
    }

    throw Exception('Failed to fetch users: ${response.message}');
  }

  /// Récupère un utilisateur par ID
  static Future<User> getUserById(int id) async {
    final response = await HttpService.instance.get<Map<String, dynamic>>('$_basePath/$id');

    if (response.success && response.data != null) {
      return User.fromJson(response.data!);
    }

    throw Exception('Failed to fetch user: ${response.message}');
  }

  /// Crée un nouvel utilisateur
  static Future<User> createUser(User user) async {
    final response = await HttpService.instance.post<Map<String, dynamic>>(
      _basePath,
      data: user.toJson(),
    );

    if (response.success && response.data != null) {
      return User.fromJson(response.data!);
    }

    throw Exception('Failed to create user: ${response.message}');
  }

  /// Met à jour un utilisateur
  static Future<User> updateUser(int id, User user) async {
    final response = await HttpService.instance.put<Map<String, dynamic>>(
      '$_basePath/$id',
      data: user.toJson(),
    );

    if (response.success && response.data != null) {
      return User.fromJson(response.data!);
    }

    throw Exception('Failed to update user: ${response.message}');
  }

  /// Supprime un utilisateur
  static Future<void> deleteUser(int id) async {
    final response = await HttpService.instance.delete<void>('$_basePath/$id');

    if (!response.success) {
      throw Exception('Failed to delete user: ${response.message}');
    }
  }

  /// Upload d'un avatar
  static Future<String> uploadAvatar(int userId, String imagePath) async {
    final response = await HttpService.instance.uploadFile<Map<String, dynamic>>(
      '$_basePath/$userId/avatar',
      imagePath,
      fieldName: 'avatar',
      additionalData: {'user_id': userId},
    );

    if (response.success && response.data != null) {
      return response.data!['avatar_url'] ?? '';
    }

    throw Exception('Failed to upload avatar: ${response.message}');
  }
}

/// Exemple d'initialisation dans main.dart
void initializeHttpService() {
  // Configuration selon l'environnement
  final config = kDebugMode
      ? HttpConfig.development
      : HttpConfig.production;

  // Initialisation du service
  HttpService.instance.initialize(config);

  // Configuration de l'authentification (optionnel)
  HttpService.instance.configureAuth(
    getToken: () {
      // Récupérer le token depuis le stockage local
      return 'your-jwt-token';
    },
    refreshToken: () async {
      // Logique de refresh du token
      return 'new-jwt-token';
    },
  );
}

/// Exemple d'utilisation dans un widget
class UserListWidget extends StatefulWidget {
  const UserListWidget({super.key});

  @override
  _UserListWidgetState createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  List<User> users = [];
  bool isLoading = false;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final fetchedUsers = await UserService.getAllUsers();
      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _createUser() async {
    try {
      final newUser = User(
        id: 0, // L'ID sera généré par le serveur
        name: 'John Doe',
        email: 'john.doe@example.com',
      );

      final createdUser = await UserService.createUser(newUser);
      setState(() {
        users.add(createdUser);
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  Future<void> _deleteUser(int id) async {
    try {
      await UserService.deleteUser(id);
      setState(() {
        users.removeWhere((user) => user.id == id);
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: Column(
        children: [
          if (isLoading) const CircularProgressIndicator(),
          if (error != null) Text('Error: $error', style: const TextStyle(color: Colors.red)),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(user.name),
                  subtitle: Text(user.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteUser(user.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}

