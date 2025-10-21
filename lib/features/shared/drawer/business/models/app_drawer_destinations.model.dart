import 'package:boxtobikers/features/shared/core/app_router.dart';
import 'package:boxtobikers/features/shared/drawer/business/models/app_drawer_destination.model.dart';
import 'package:boxtobikers/generated/l10n.dart';
import 'package:flutter/material.dart';

/// Retourne la liste des destinations de navigation de l'application avec les traductions
List<AppDrawerDestinationModel> getAppDrawerDestinations(BuildContext context) {
  final l10n = S.of(context);

  return [
    AppDrawerDestinationModel(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
      label: l10n.appDrawerHomeTitle,
      route: AppRouter.home,
    ),
    AppDrawerDestinationModel(
      icon: Icons.info_outlined,
      selectedIcon: Icons.info,
      label: l10n.appDrawerAboutTitle,
      route: AppRouter.about,
    ),
    AppDrawerDestinationModel(
      icon: Icons.settings_outlined,
      selectedIcon: Icons.settings,
      label: l10n.appDrawerSettingsTitle,
      route: AppRouter.settings,
    ),
    AppDrawerDestinationModel(
      icon: Icons.directions_bike_outlined,
      selectedIcon: Icons.directions_bike,
      label: l10n.appDrawerRidingTitle,
      route: AppRouter.riding,
    ),
  ];
}
