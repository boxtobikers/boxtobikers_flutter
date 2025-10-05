import 'package:boxtobikers/features/settings/ui/pages/settings.dart';
import 'package:flutter/material.dart';
import 'home_items.dart';
import '../../about/ui/pages/about.dart';
import '../../riding/ui/pages/riding.dart';
import '../../settings/ui/pages/settings.dart';

class HomeItemsData {
  static List<HomeItems> getHomeItems(BuildContext context) {
    return [
      HomeItems(
        icon: Icons.explore,
        titleKey: 'homeItemExploreTitle',
        descriptionKey: 'homeItemExploreDescription',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RidingPage()),
          );
        },
      ),
      HomeItems(
        icon: Icons.person,
        titleKey: 'homeItemWhoAmITitle',
        descriptionKey: 'homeItemWhoAmIDescription',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AboutPage()),
          );
        },
      ),
      HomeItems(
        icon: Icons.settings,
        titleKey: 'homeItemSettingsTitle',
        descriptionKey: 'homeItemSettingsDescription',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsPage()),
          );
        },
      ),
    ];
  }
}
