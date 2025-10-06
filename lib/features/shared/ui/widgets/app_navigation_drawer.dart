import 'package:flutter/material.dart';
import '../../business/drawer_destination.dart';

/// Liste centralisée des destinations de navigation de l'application
const List<DrawerDestination> appNavigationDestinations = [
  DrawerDestination(
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    label: 'Accueil',
    route: '/home',
  ),
  DrawerDestination(
    icon: Icons.info_outlined,
    selectedIcon: Icons.info,
    label: 'À propos',
    route: '/about',
  ),
  DrawerDestination(
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
    label: 'Paramètres',
    route: '/settings',
  ),
  DrawerDestination(
    icon: Icons.directions_bike_outlined,
    selectedIcon: Icons.directions_bike,
    label: 'Riding',
    route: '/riding',
  ),
];

/// Widget réutilisable pour le NavigationDrawer de l'application
class AppNavigationDrawer extends StatelessWidget {
  final int selectedIndex;
  final String? title;
  final List<DrawerDestination>? destinations;

  const AppNavigationDrawer({
    super.key,
    required this.selectedIndex,
    this.title = 'BoxtoBikers',
    this.destinations,
  });

  void _onDestinationSelected(BuildContext context, int index) {
    final destList = destinations ?? appNavigationDestinations;

    if (index == selectedIndex) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).pop(); // Ferme le drawer
    Navigator.pushReplacementNamed(context, destList[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final destList = destinations ?? appNavigationDestinations;

    return NavigationDrawer(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) => _onDestinationSelected(context, index),
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
            child: Text(
              title!,
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
