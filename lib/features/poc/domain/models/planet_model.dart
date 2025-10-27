/// Modèle représentant une planète de l'API SWAPI
class Planet {
  final String name;
  final String diameter;
  final String terrain;

  Planet({
    required this.name,
    required this.diameter,
    required this.terrain,
  });

  /// Crée une instance de Planet à partir d'un JSON
  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      name: json['name'] as String? ?? 'Unknown',
      diameter: json['diameter'] as String? ?? 'Unknown',
      terrain: json['terrain'] as String? ?? 'Unknown',
    );
  }

  /// Convertit une instance de Planet en JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'diameter': diameter,
      'terrain': terrain,
    };
  }
}

/// Modèle représentant la réponse de l'API SWAPI pour les planètes
class PlanetsResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Planet> results;

  PlanetsResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  /// Crée une instance de PlanetsResponse à partir d'un JSON
  factory PlanetsResponse.fromJson(Map<String, dynamic> json) {
    return PlanetsResponse(
      count: json['count'] as int? ?? 0,
      next: json['next'] as String?,
      previous: json['previous'] as String?,
      results: (json['results'] as List<dynamic>?)
              ?.map((e) => Planet.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Convertit une instance de PlanetsResponse en JSON
  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'next': next,
      'previous': previous,
      'results': results.map((e) => e.toJson()).toList(),
    };
  }
}

