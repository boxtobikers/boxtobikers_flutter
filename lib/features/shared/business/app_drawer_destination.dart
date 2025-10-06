import 'package:flutter/material.dart';

/// Définition d'une classe pour représenter une destination du NavigationDrawer
class AppDrawerDestination {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final String route;

  const AppDrawerDestination({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.route,
  });
}

