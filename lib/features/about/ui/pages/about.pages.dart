import 'package:flutter/material.dart';
import '../../../shared/ui/widgets/app_navigation_drawer.dart';

class AboutPages extends StatefulWidget {
  const AboutPages({super.key});

  @override
  State<StatefulWidget> createState() => _AboutPagesState();
}

class _AboutPagesState extends State<AboutPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppNavigationDrawer(
        selectedIndex: 1, // About est à l'index 1
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
                    'About Page',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            const Expanded(
              child: Center(
                child: Text('This is the About Page'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}