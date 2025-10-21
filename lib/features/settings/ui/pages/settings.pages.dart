import 'package:boxtobikers/features/shared/core/app_router.dart';
import 'package:boxtobikers/features/shared/core/models/currency.dart';
import 'package:boxtobikers/features/shared/core/models/distance_unit.dart';
import 'package:boxtobikers/features/shared/core/providers/app_state_provider.dart';
import 'package:boxtobikers/features/shared/drawer/ui/widgets/app_navigation_drawer.dart';
import 'package:boxtobikers/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPages extends StatefulWidget {
  const SettingsPages({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPagesState();
}

class _SettingsPagesState extends State<SettingsPages> {
  bool _notificationsEnabled = false;

  IconData _getCurrencyIcon(Currency currency) {
    switch (currency) {
      case Currency.euro:
        return Icons.euro_symbol;
      case Currency.dollar:
        return Icons.attach_money;
      case Currency.pound:
        return Icons.currency_pound;
      case Currency.yen:
        return Icons.currency_yen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);
    final appState = Provider.of<AppStateProvider>(context);
    final double headerImageHeight = MediaQuery.of(context).size.height / 4;

    return Scaffold(
      drawer: const AppNavigationDrawer(
        selectedIndex: 2, // Settings est à l'index 2
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
                    height: headerImageHeight,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        image: AssetImage('assets/btb_header_biker.jpg'),
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
            // Zone de contenu scrollable
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                children: [
                  // Titre paragraphe
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.settingsGeneralTitle,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.settingsGeneralSubTitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        // Ajoutez ici les options de paramètres générales
                        const SizedBox(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(
                            l10n.settingsProfilTitle,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: SizedBox(
                            height: 32,
                            child: FilledButton.tonal(
                              onPressed: () {
                                AppRouter.navigateTo(context, AppRouter.profil);
                              },
                              style: FilledButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                                minimumSize: const Size(0, 32),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                l10n.commonUpdate,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ),
                          onTap: () {
                            AppRouter.navigateTo(context, AppRouter.profil);
                          },
                        ),
                        const Divider(),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.notifications,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(
                            l10n.settingsNotificationsTitle,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            _notificationsEnabled
                              ? l10n.settingsNotificationsTextEnabled
                              : l10n.settingsNotificationsText,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          trailing: Switch(
                            value: _notificationsEnabled,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                          ),
                          onTap: () {
                            // Navigation vers les mentions légales
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.settingsDisplayTitle,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.brightness_6,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(
                            l10n.settingsThemeTitle,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: SegmentedButton<ThemeMode>(
                            segments: const [
                              ButtonSegment<ThemeMode>(
                                value: ThemeMode.light,
                                icon: Icon(Icons.light_mode, size: 18),
                              ),
                              ButtonSegment<ThemeMode>(
                                value: ThemeMode.dark,
                                icon: Icon(Icons.dark_mode, size: 18),
                              ),
                              ButtonSegment<ThemeMode>(
                                value: ThemeMode.system,
                                icon: Icon(Icons.brightness_auto, size: 18),
                              ),
                            ],
                            showSelectedIcon: false,
                            selected: {appState.themeMode},
                            onSelectionChanged: (Set<ThemeMode> newSelection) {
                              appState.setThemeMode(newSelection.first);
                            },
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            _getCurrencyIcon(appState.currency),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(
                            l10n.settingsDeviseTitle,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: DropdownButton<Currency>(
                            value: appState.currency,
                            underline: const SizedBox(),
                            alignment: AlignmentDirectional.centerEnd,
                            items: Currency.values.map((currency) {
                              return DropdownMenuItem(
                                value: currency,
                                child: Text('${currency.name} (${currency.symbol})'),
                              );
                            }).toList(),
                            onChanged: (currency) {
                              if (currency != null) {
                                appState.setCurrency(currency);
                              }
                            },
                          ),
                        ),
                        const Divider(),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.straighten,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(
                            l10n.settingsDistanceTitle,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: SegmentedButton<DistanceUnit>(
                            segments: const [
                              ButtonSegment<DistanceUnit>(
                                value: DistanceUnit.kilometers,
                                label: Text('km'),
                              ),
                              ButtonSegment<DistanceUnit>(
                                value: DistanceUnit.miles,
                                label: Text('miles'),
                              ),
                            ],
                            selected: {appState.distanceUnit},
                            onSelectionChanged: (Set<DistanceUnit> newSelection) {
                              appState.setDistanceUnit(newSelection.first);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.settingsLegalTitle,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.settingsLegalSubTitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                        // Ajoutez ici les options de paramètres générales
                        const SizedBox(height: 16),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: Icon(
                            Icons.gavel,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(
                            l10n.settingsLegalDocumentsTitle,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: Text(
                            l10n.commonView,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          onTap: () {
                            // Navigation vers les mentions légales
                          },
                        ),
                      ],
                    ),
                  ),
                ]
              ),
            ),
          ],
        ),
      ),
    );
  }
}
