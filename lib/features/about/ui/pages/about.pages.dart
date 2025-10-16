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
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
      drawer: const AppNavigationDrawer(
        selectedIndex: 1, // About est à l'index 1
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Section supérieure avec icône Flutter et titre
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height / 3,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/btb_header_moto.jpg'),
                        fit: BoxFit.cover,
                      ),
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
                  ),
                  Positioned(
                    top: 24.0,
                    left: 8.0,
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
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Titre fixe
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Qui sommes-nous ?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Zone de contenu scrollable
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  Card(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BoxToBikers fourni un service sécurisé de "gardiennage" de son équipement, aux adeptes du 2 roues.',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Concrètement, visiter, se baigner, déjeuner, ..., sans son équipement, c'est apporter plus de liberté.",
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
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          {
                            'year': '2023',
                            'descriptions': ["L'idée du service en marche !", "La marque est protégée"],
                          },
                          {
                            'year': '2025',
                            'descriptions': ["Le design et le développement de l'application démarrent."],
                          },
                          {
                            'year': "Aujourd'hui",
                            'descriptions': ["On est sur les stores Apple, Android !", "x clients", "y lieux de dépose"],
                          },
                        ].asMap().entries.map((entry) {
                          final index = entry.key;
                          final data = entry.value;
                          final year = data['year'] as String;
                          final descriptions = data['descriptions'] as List<String>;

                          return Padding(
                            padding: EdgeInsets.only(
                              right: index < 2 ? 16.0 : 0,
                            ),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Card(
                                color: Theme.of(context).colorScheme.secondaryContainer,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        year,
                                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      ...descriptions.map((description) => Padding(
                                        padding: const EdgeInsets.only(bottom: 8.0),
                                        child: Text(
                                          description,
                                          style: Theme.of(context).textTheme.bodyLarge,
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    color: Theme.of(context).colorScheme.tertiaryContainer,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Merci de votre confiance !',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}