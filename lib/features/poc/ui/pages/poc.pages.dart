import 'package:boxtobikers/features/poc/domain/models/planet_model.dart' show Planet;
import 'package:boxtobikers/features/poc/domain/services/poc.service.dart' show PocService;
import 'package:boxtobikers/generated/l10n.dart';
import 'package:flutter/material.dart';

class PocPages extends StatefulWidget {
  const PocPages({super.key});

  @override
  State<StatefulWidget> createState() => _PocPagesState();
}

class _PocPagesState extends State<PocPages> {
  final PocService _pocService = PocService();
  List<Planet>? _planets;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadPlanets();
  }

  /// Charge les planètes depuis l'API SWAPI
  Future<void> _loadPlanets() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final planets = await _pocService.getPlanets(page: 1);

    setState(() {
      _isLoading = false;
      if (planets != null) {
        _planets = planets;
      } else {
        _errorMessage = 'Erreur lors du chargement des planètes';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

    final double headerImageHeight = MediaQuery.of(context).size.height / 4;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
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
                    height: headerImageHeight,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/btb_header_bordeaux.jpg'),
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
                    top: 8.0,
                    left: 8.0,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            // Zone de contenu scrollable
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _errorMessage!,
                                style: TextStyle(color: Theme.of(context).colorScheme.error),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadPlanets,
                                child: Text(l10n.commonRetry),
                              ),
                            ],
                          ),
                        )
                      : _planets == null || _planets!.isEmpty
                          ? const Center(child: Text('Aucune planète trouvée'))
                          : ListView.builder(
                              padding: const EdgeInsets.all(16.0),
                              itemCount: _planets!.length,
                              itemBuilder: (context, index) {
                                final planet = _planets![index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12.0),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                      child: Icon(
                                        Icons.public,
                                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      ),
                                    ),
                                    title: Text(
                                      planet.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 4),
                                        Text('Diamètre: ${planet.diameter} km'),
                                        Text('Terrain: ${planet.terrain}'),
                                      ],
                                    ),
                                    isThreeLine: true,
                                  ),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }
}