/// Énumération des devises supportées par l'application
/// Principe SOLID : Single Responsibility - gère uniquement les devises
enum CurrencyModel {
  euro('€', 'EUR', 'Euro'),
  dollar('\$', 'USD', 'US Dollar'),
  pound('£', 'GBP', 'British Pound'),
  yen('¥', 'JPY', 'Japanese Yen');

  final String symbol;
  final String code;
  final String name;

  const CurrencyModel(this.symbol, this.code, this.name);

  /// Retourne la devise par défaut selon la locale
  /// Principe DRY : centralise la logique de mapping locale -> devise
  static CurrencyModel fromLocale(String localeCode) {
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
        return CurrencyModel.euro;

      case 'US':
      case 'CA':
      case 'MX':
        return CurrencyModel.dollar;

      case 'GB':
        return CurrencyModel.pound;

      case 'JP':
        return CurrencyModel.yen;

      default:
        return CurrencyModel.euro; // Par défaut
    }
  }

  /// Retourne une devise à partir de son code
  static CurrencyModel fromCode(String code) {
    return CurrencyModel.values.firstWhere(
      (currency) => currency.code == code,
      orElse: () => CurrencyModel.euro,
    );
  }

  /// Retourne une devise à partir de son symbole
  static CurrencyModel fromSymbol(String symbol) {
    return CurrencyModel.values.firstWhere(
      (currency) => currency.symbol == symbol,
      orElse: () => CurrencyModel.euro,
    );
  }
}

