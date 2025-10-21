/// Énumération des unités de distance supportées par l'application
/// Principe SOLID : Single Responsibility - gère uniquement les unités de distance
enum DistanceUnit {
  kilometers('km', 'Kilometers'),
  miles('mi', 'Miles');

  final String symbol;
  final String name;

  const DistanceUnit(this.symbol, this.name);

  /// Retourne l'unité de distance par défaut selon la locale
  /// Principe DRY : centralise la logique de mapping locale -> unité de distance
  ///
  /// Règle métier :
  /// - France et pays européens : kilomètres
  /// - Pays anglo-saxons (US, UK, etc.) : miles
  static DistanceUnit fromLocale(String localeCode) {
    // Extrait le code pays ou langue de la locale (ex: 'en_US' -> 'US', 'fr_FR' -> 'FR')
    final languageCode = localeCode.contains('_')
        ? localeCode.split('_').first.toLowerCase()
        : localeCode.toLowerCase();

    final countryCode = localeCode.contains('_')
        ? localeCode.split('_').last.toUpperCase()
        : '';

    // Pays utilisant les miles
    switch (countryCode) {
      case 'US': // États-Unis
      case 'GB': // Royaume-Uni
        return DistanceUnit.miles;
    }

    // Si pas de code pays spécifique, on se base sur la langue
    switch (languageCode) {
      case 'en': // Anglais (par défaut miles sauf exceptions)
        // Si c'est de l'anglais sans code pays spécifique, on utilise miles
        return DistanceUnit.miles;
      default:
        // Tous les autres pays utilisent le système métrique (kilomètres)
        return DistanceUnit.kilometers;
    }
  }

  /// Retourne une unité de distance à partir de son symbole
  static DistanceUnit fromSymbol(String symbol) {
    return DistanceUnit.values.firstWhere(
      (unit) => unit.symbol == symbol,
      orElse: () => DistanceUnit.kilometers,
    );
  }
}

