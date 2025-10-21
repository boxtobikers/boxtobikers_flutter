import 'package:boxtobikers/features/about/ui/pages/about.pages.dart';
import 'package:boxtobikers/features/home/ui/pages/home.pages.dart';
import 'package:boxtobikers/features/profil/ui/pages/profil.pages.dart';
import 'package:boxtobikers/features/riding/ui/pages/riding.pages.dart';
import 'package:boxtobikers/features/settings/ui/pages/settings.pages.dart';
import 'package:boxtobikers/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Classe centralisée pour la gestion des routes de l'application
/// Respecte les principes DRY (Don't Repeat Yourself) et SOLID
class AppRouter {
  // Noms des routes (constantes)
  static const String home = '/home';
  static const String about = '/about';
  static const String settings = '/settings';
  static const String riding = '/riding';
  static const String profil = '/profil';

  /// Route initiale de l'application
  static const String initialRoute = home;

  /// Génère les routes de l'application
  static Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      home: (context) => HomePages(title: S.of(context).homeTitle),
      about: (context) => const AboutPages(),
      settings: (context) => const SettingsPages(),
      riding: (context) => const RidingPages(),
      profil: (context) => const ProfilPages(),
    };
  }

  /// Navigation helper - permet de naviguer vers une route
  static Future<T?> navigateTo<T>(BuildContext context, String routeName) {
    return Navigator.pushNamed<T>(context, routeName);
  }

  /// Navigation helper - permet de naviguer en remplaçant la route actuelle
  static Future<T?> navigateAndReplace<T, TO extends Object?>(
    BuildContext context,
    String routeName, {
    TO? result,
  }) {
    return Navigator.pushReplacementNamed<T, TO>(context, routeName, result: result);
  }

  /// Navigation helper - permet de revenir à la page précédente
  static void goBack<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop<T>(context, result);
  }
}
