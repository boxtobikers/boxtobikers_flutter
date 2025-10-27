import 'package:boxtobikers/core/http/http_service.dart';
import 'package:boxtobikers/features/poc/domain/models/planet_model.dart';

/// Service pour gérer les appels à l'API SWAPI
class PocService {
  final HttpService _httpService = HttpService.instance;

  /// Récupère la liste des planètes depuis l'API SWAPI
  ///
  /// [page] Le numéro de la page à récupérer (par défaut 1)
  /// Retourne une liste de planètes ou null en cas d'erreur
  Future<List<Planet>?> getPlanets({int page = 1}) async {
    try {
      // Appel à l'API SWAPI en utilisant le singleton HttpService
      // Utilise la constante d'API définie dans HttpService (dev pour le moment)
      final response = await _httpService.get<Map<String, dynamic>>(
        '${HttpService.swapiBaseUrlDev}/planets/?page=$page',
      );

      // Vérification si la réponse est un succès
      if (response.success && response.data != null) {
        // Conversion de la réponse JSON en objet PlanetsResponse
        final planetsResponse = PlanetsResponse.fromJson(response.data!);
        return planetsResponse.results;
      } else {
        // Gestion des erreurs
        print('Erreur lors de la récupération des planètes: ${response.message}');
        return null;
      }
    } catch (e) {
      // Gestion des exceptions
      print('Exception lors de la récupération des planètes: $e');
      return null;
    }
  }
}

