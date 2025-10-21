import 'package:boxtobikers/core/drawer/ui/widgets/app_navigation_drawer.widget.dart';
import 'package:boxtobikers/generated/l10n.dart';
import 'package:flutter/material.dart';

class RidingPages extends StatefulWidget {
  const RidingPages({super.key});

  @override
  State<StatefulWidget> createState() => _RidingPagesState();
}

class _RidingPagesState extends State<RidingPages> {
  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    return Scaffold(
      drawer: const AppNavigationDrawerWidget(
        selectedIndex: 3, // Riding est à l'index 3
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
                    l10n.ridingTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('This is the Riding Page'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}