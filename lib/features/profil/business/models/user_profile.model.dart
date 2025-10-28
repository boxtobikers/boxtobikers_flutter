class UserProfileModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final DateTime? dateOfBirth;

  UserProfileModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    this.dateOfBirth,
  });

  String get fullName => '$firstName $lastName';

  UserProfileModel copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    DateTime? dateOfBirth,
  }) {
    return UserProfileModel(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
    };
  }

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'] as String)
          : null,
    );
  }

  /// Factory pour créer un profil visiteur anonyme par défaut
  factory UserProfileModel.createVisitor() {
    return UserProfileModel(
      firstName: 'Visiteur',
      lastName: '',
      email: '',
      phone: '',
      address: '',
      dateOfBirth: null,
    );
  }
}

