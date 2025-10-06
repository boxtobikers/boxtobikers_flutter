import 'package:flutter/material.dart';
import '../../../shared/ui/widgets/app_navigation_drawer.dart';

class RidingPages extends StatefulWidget {
  const RidingPages({super.key});

  @override
  State<StatefulWidget> createState() => _RidingPagesState();
}

class _RidingPagesState extends State<RidingPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppNavigationDrawer(
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
                    'Riding Page',
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