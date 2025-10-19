import 'package:flutter/material.dart';
import 'app_drawer_destination.dart';
import 'app_router.dart';
import '../../../generated/l10n.dart';

/// Retourne la liste des destinations de navigation de l'application avec les traductions
List<AppDrawerDestination> getAppDrawerDestinations(BuildContext context) {
  final l10n = S.of(context);

  return [
    AppDrawerDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: l10n.appDrawerHomeTitle,
      route: AppRouter.home,
    ),
    AppDrawerDestination(
      icon: Icons.info_outlined,
      selectedIcon: Icons.info,
      label: l10n.appDrawerAboutTitle,
      route: AppRouter.about,
    ),
    AppDrawerDestination(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: l10n.appDrawerSettingsTitle,
      route: AppRouter.settings,
    ),
    AppDrawerDestination(
      icon: Icons.directions_bike_outlined,
      selectedIcon: Icons.directions_bike,
      label: l10n.appDrawerRidingTitle,
      route: AppRouter.riding,
    ),
  ];
}
