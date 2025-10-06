import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../widgets/home_list_view.widget.dart';

class HomePages extends StatelessWidget {
  const HomePages({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final stackHeight = screenHeight * 0.5;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: stackHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          'assets/btb_sea.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 16.0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: FilledButton.icon(
                              onPressed: () {
                                // TODO: Implement login functionality
                              },
                              style: FilledButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              ),
                              icon: const Icon(
                                Icons.login,
                                weight: 700,
                              ),
                              label: Text(
                                S.of(context).homeLoginButton,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 32,
                        right: 32,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            S.of(context).homeTitle,
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  offset: const Offset(0, 2),
                                  blurRadius: 4.0,
                                  color: Colors.black.withValues(alpha: 0.5),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: HomeListViewWidget(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}