import 'package:boxtobikers/features/about/ui/pages/about.pages.dart';
import 'package:boxtobikers/features/history/ui/pages/history.pages.dart';
import 'package:boxtobikers/features/home/models/home_items.model.dart';
import 'package:boxtobikers/features/poc/ui/pages/poc.pages.dart';
import 'package:boxtobikers/features/riding/ui/pages/riding.pages.dart';
import 'package:boxtobikers/features/settings/ui/pages/settings.pages.dart';
import 'package:flutter/material.dart';

class HomeItemsDataModel {
  static List<HomeItemsModel> getHomeItems(BuildContext context) {
    return [
      HomeItemsModel(
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
      HomeItemsModel(
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
      HomeItemsModel(
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
      HomeItemsModel(
        icon: Icons.travel_explore,
        titleKey: 'homeItemHistoryTitle',
        descriptionKey: 'homeItemHistoryDescription',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const HistoryPages()),
          );
        },
      ),
      HomeItemsModel(
        icon: Icons.car_crash,
        titleKey: 'homeItemPocTitle',
        descriptionKey: 'homeItemPocDescription',
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PocPages()),
          );
        },
      ),
    ];
  }
}
