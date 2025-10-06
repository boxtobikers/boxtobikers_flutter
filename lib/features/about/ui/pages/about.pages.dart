import 'package:flutter/material.dart';
import '../../../shared/ui/widgets/app_navigation_drawer.dart';
import '../../../../generated/l10n.dart';

class AboutPages extends StatefulWidget {
  const AboutPages({super.key});

  @override
  State<StatefulWidget> createState() => _AboutPagesState();
}

class _AboutPagesState extends State<AboutPages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      drawer: const AppNavigationDrawer(
        selectedIndex: 1, // About est à l'index 1
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Section supérieure avec icône Flutter et titre
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 24.0, bottom: 24.0, right: 16.0),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Builder(
                      builder: (context) => IconButton(
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(Icons.menu),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    S.of(context).appDrawerAboutTitle,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
            // Zone de contenu
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24.0),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Si vous êtes arrivés là,',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Vous voulez savoir ce que l'on fait, pourquoi on le fait, ou tout simplement nous connaître, histoire d'être rassuré.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Bon réflexe, vous êtes au bon endroit !.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiaryContainer,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Chez BoxToBikers, notre mission est de fournir un service sécurisé de "gardiennage" de son équipement, aux adeptes du 2 roues.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Concrètement, pouvoir visiter, se baigner, déjeuner, ..., sans son équipement, c'est vous apporter plus de liberté.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Voici notre engagement, alors à bientôt et merci de votre confiance.",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}