import 'package:flutter/material.dart';
import 'app_drawer_destination.dart';
import '../../../generated/l10n.dart';

/// Retourne la liste des destinations de navigation de l'application avec les traductions
List<AppDrawerDestination> getAppDrawerDestinations(BuildContext context) {
  final s = S.of(context);

  return [
    AppDrawerDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: s.appDrawerHomeTitle,
      route: '/home',
    ),
    AppDrawerDestination(
      icon: Icons.info_outlined,
      selectedIcon: Icons.info,
      label: s.appDrawerAboutTitle,
      route: '/about',
    ),
    AppDrawerDestination(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: s.appDrawerSettingsTitle,
      route: '/settings',
    ),
    AppDrawerDestination(
      icon: Icons.directions_bike_outlined,
      selectedIcon: Icons.directions_bike,
      label: s.appDrawerRidingTitle,
      route: '/riding',
    ),
  ];
}
