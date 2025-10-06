import 'package:flutter/material.dart';
import '../../../shared/ui/widgets/app_navigation_drawer.dart';

class SettingsPages extends StatefulWidget {
  const SettingsPages({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPagesState();
}

class _SettingsPagesState extends State<SettingsPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppNavigationDrawer(
        selectedIndex: 2, // Settings est à l'index 2
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Settings Page',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('This is the Settings Page'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}