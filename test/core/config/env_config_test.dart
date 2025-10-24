import 'package:flutter_test/flutter_test.dart';
import 'package:boxtobikers/core/config/env_config.dart';

/// Tests pour la configuration des variables d'environnement
///
/// Ces tests vérifient que EnvConfig fonctionne correctement.
///
/// Pour lancer les tests :
/// ```bash
/// flutter test test/core/config/env_config_test.dart
/// ```
void main() {
  group('EnvConfig', () {
    test('devrait avoir des constantes définies', () {
      // Les constantes doivent être accessibles
      expect(EnvConfig.supabaseUrl, isA<String>());
      expect(EnvConfig.supabaseAnonKey, isA<String>());
      expect(EnvConfig.apiUrl, isA<String>());
      expect(EnvConfig.environment, isA<String>());
    });

    test('environment devrait avoir une valeur par défaut', () {
      // La valeur par défaut est 'development'
      expect(EnvConfig.environment, isNotEmpty);
    });

    test('les helpers d\'environnement devraient fonctionner', () {
      // Au moins un helper doit être true
      final isDev = EnvConfig.isDevelopment;
      final isStaging = EnvConfig.isStaging;
      final isProd = EnvConfig.isProduction;

      expect(isDev || isStaging || isProd, isTrue);
    });

    test('isValid devrait vérifier les variables requises', () {
      // Si les variables ne sont pas définies, isValid doit être false
      // Si elles sont définies, isValid doit être true
      final valid = EnvConfig.isValid;
      expect(valid, isA<bool>());

      if (valid) {
        expect(EnvConfig.supabaseUrl, isNotEmpty);
        expect(EnvConfig.supabaseAnonKey, isNotEmpty);
      }
    });

    test('printInfo ne devrait pas crasher', () {
      // printInfo ne doit pas lever d'exception
      expect(() => EnvConfig.printInfo(), returnsNormally);
    });

    group('validate()', () {
      test('devrait lever une exception si SUPABASE_URL est vide', () {
        // Ce test ne peut être effectué que si les variables ne sont pas définies
        // Ignorer si elles sont définies
        if (EnvConfig.supabaseUrl.isEmpty) {
          expect(
            () => EnvConfig.validate(),
            throwsException,
          );
        }
      });

      test('ne devrait pas lever d\'exception si tout est configuré', () {
        // Ce test ne réussit que si les variables sont définies
        if (EnvConfig.isValid) {
          expect(() => EnvConfig.validate(), returnsNormally);
        }
      });
    });

    group('Environnement Detection', () {
      test('un seul environnement doit être actif à la fois', () {
        final environments = [
          EnvConfig.isDevelopment,
          EnvConfig.isStaging,
          EnvConfig.isProduction,
        ];

        // Compter le nombre d'environnements actifs
        final activeCount = environments.where((e) => e).length;

        // Un seul doit être actif
        expect(activeCount, equals(1));
      });

      test('environment doit correspondre au helper actif', () {
        if (EnvConfig.isDevelopment) {
          expect(EnvConfig.environment, equals('development'));
        } else if (EnvConfig.isStaging) {
          expect(EnvConfig.environment, equals('staging'));
        } else if (EnvConfig.isProduction) {
          expect(EnvConfig.environment, equals('production'));
        }
      });
    });
  });
}

