import 'package:flutter/material.dart';
import 'home_items.dart';
import '../../about/ui/pages/about.pages.dart';
import '../../riding/ui/pages/riding.pages.dart';
import '../../settings/ui/pages/settings.pages.dart';

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
            MaterialPageRoute(builder: (context) => const RidingPages()),
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
            MaterialPageRoute(builder: (context) => const AboutPages()),
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
            MaterialPageRoute(builder: (context) => const SettingsPages()),
          );
        },
      ),
    ];
  }
}
