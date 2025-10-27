/// Modèle représentant une destination depuis Supabase
class Destination {
  final String id;
  final String name;
  final String type;
  final String? description;
  final String? address;
  final double latitude;
  final double longitude;
  final String status;
  final int lockerCount;
  final String? imageUrl;
  final DateTime? createdAt;

  Destination({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.address,
    required this.latitude,
    required this.longitude,
    required this.status,
    required this.lockerCount,
    this.imageUrl,
    this.createdAt,
  });

  /// Crée une instance de Destination à partir d'un JSON Supabase
  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'] as String,
      name: json['name'] as String? ?? 'Unknown',
      type: json['type'] as String? ?? 'BUSINESS',
      description: json['description'] as String?,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'OPEN',
      lockerCount: json['locker_count'] as int? ?? 0,
      imageUrl: json['image_url'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  /// Convertit une instance de Destination en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'status': status,
      'locker_count': lockerCount,
      'image_url': imageUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  /// Retourne un libellé lisible pour le type de destination
  String get typeLabel {
    switch (type) {
      case 'BUSINESS':
        return 'Professionnel';
      case 'PRIVATE':
        return 'Particulier';
      default:
        return type;
    }
  }

  /// Retourne un libellé lisible pour le statut de la destination
  String get statusLabel {
    switch (status) {
      case 'OPEN':
        return 'Ouvert';
      case 'CLOSED':
        return 'Fermé';
      case 'PAUSED':
        return 'En pause';
      default:
        return status;
    }
  }
}

