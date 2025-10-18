/// Énumération des devises supportées par l'application
/// Principe SOLID : Single Responsibility - gère uniquement les devises
enum Currency {
  euro('€', 'EUR', 'Euro'),
  dollar('\$', 'USD', 'US Dollar'),
  pound('£', 'GBP', 'British Pound'),
  yen('¥', 'JPY', 'Japanese Yen');

  final String symbol;
  final String code;
  final String name;

  const Currency(this.symbol, this.code, this.name);

  /// Retourne la devise par défaut selon la locale
  /// Principe DRY : centralise la logique de mapping locale -> devise
  static Currency fromLocale(String localeCode) {
    // Extrait le code pays de la locale (ex: 'en_US' -> 'US', 'fr_FR' -> 'FR')
    final countryCode = localeCode.contains('_')
        ? localeCode.split('_').last.toUpperCase()
        : localeCode.toUpperCase();

    switch (countryCode) {
      case 'FR':
      case 'DE':
      case 'IT':
      case 'ES':
      case 'PT':
      case 'BE':
      case 'NL':
      case 'AT':
      case 'IE':
      case 'FI':
      case 'GR':
        return Currency.euro;

      case 'US':
      case 'CA':
      case 'MX':
        return Currency.dollar;

      case 'GB':
        return Currency.pound;

      case 'JP':
        return Currency.yen;

      default:
        return Currency.euro; // Par défaut
    }
  }

  /// Retourne une devise à partir de son code
  static Currency fromCode(String code) {
    return Currency.values.firstWhere(
      (currency) => currency.code == code,
      orElse: () => Currency.euro,
    );
  }

  /// Retourne une devise à partir de son symbole
  static Currency fromSymbol(String symbol) {
    return Currency.values.firstWhere(
      (currency) => currency.symbol == symbol,
      orElse: () => Currency.euro,
    );
  }
}

