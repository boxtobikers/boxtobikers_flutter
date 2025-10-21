import 'package:boxtobikers/features/about/ui/pages/about.pages.dart';
import 'package:boxtobikers/features/home/models/home_items.dart';
import 'package:boxtobikers/features/riding/ui/pages/riding.pages.dart';
import 'package:boxtobikers/features/settings/ui/pages/settings.pages.dart';
import 'package:flutter/material.dart';

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
