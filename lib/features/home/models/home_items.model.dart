import 'package:flutter/material.dart';

class HomeItemsModel {
  final IconData icon;
  final String titleKey;
  final String descriptionKey;
  final VoidCallback onTap;

  const HomeItemsModel({
    required this.icon,
    required this.titleKey,
    required this.descriptionKey,
    required this.onTap,
  });
}

