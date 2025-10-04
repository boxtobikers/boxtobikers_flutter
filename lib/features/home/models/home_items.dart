import 'package:flutter/material.dart';

class HomeItems {
  final IconData icon;
  final String titleKey;
  final String descriptionKey;
  final VoidCallback onTap;

  const HomeItems({
    required this.icon,
    required this.titleKey,
    required this.descriptionKey,
    required this.onTap,
  });
}

