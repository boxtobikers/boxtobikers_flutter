import 'package:flutter/material.dart';
import 'home_items.dart';

class HomeItemsData {
  static List<HomeItems> getHomeItems() {
    return [
      HomeItems(
        icon: Icons.explore,
        titleKey: 'homeItemExploreTitle',
        descriptionKey: 'homeItemExploreDescription',
        onTap: () {
          // TODO: Navigate to riding page
        },
      ),
      HomeItems(
        icon: Icons.person,
        titleKey: 'homeItemWhoAmITitle',
        descriptionKey: 'homeItemWhoAmIDescription',
        onTap: () {
          // TODO: Navigate to riding page
        },
      ),
      HomeItems(
        icon: Icons.settings,
        titleKey: 'homeItemSettingsTitle',
        descriptionKey: 'homeItemSettingsDescription',
        onTap: () {
          // TODO: Navigate to settings page
        },
      ),
    ];
  }
}

