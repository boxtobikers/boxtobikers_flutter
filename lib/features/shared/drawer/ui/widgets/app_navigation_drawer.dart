import 'package:boxtobikers/features/shared/core/utils/app_constants.dart';
import 'package:boxtobikers/features/shared/drawer/business/models/app_drawer_destination.dart';
import 'package:boxtobikers/features/shared/drawer/business/models/app_drawer_destinations.dart';
import 'package:flutter/material.dart';

/// Widget réutilisable pour le NavigationDrawer de l'application
class AppNavigationDrawer extends StatelessWidget {
  final int selectedIndex;
  final String? title;
  final List<AppDrawerDestination>? destinations;

  const AppNavigationDrawer({
    super.key,
    required this.selectedIndex,
    this.title,
    this.destinations,
  });

  void _onDestinationSelected(BuildContext context, int index, List<AppDrawerDestination> destList) {
    if (index == selectedIndex) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).pop(); // Ferme le drawer
    Navigator.pushReplacementNamed(context, destList[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final destList = destinations ?? getAppDrawerDestinations(context);
    final drawerTitle = title ?? AppConstants.appTitle;

    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => _onDestinationSelected(context, index, destList),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(32, 16, 16, 8),
          child: Text(
            drawerTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        ...destList.map((destination) => NavigationDrawerDestination(
              icon: Icon(destination.icon),
              selectedIcon: Icon(destination.selectedIcon),
              label: Text(destination.label),
            )),
      ],
    );
  }
}
