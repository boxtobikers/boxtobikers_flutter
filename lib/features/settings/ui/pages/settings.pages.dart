import 'package:flutter/material.dart';
import '../../../shared/ui/widgets/app_navigation_drawer.dart';
import '../../../../generated/l10n.dart';

class SettingsPages extends StatefulWidget {
  const SettingsPages({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPagesState();
}

class _SettingsPagesState extends State<SettingsPages> {
  bool _notificationsEnabled = false;
  String _distanceUnit = 'km';
  String _currency = '€';

  IconData _getCurrencyIcon() {
    switch (_currency) {
      case '€':
        return Icons.euro_symbol;
      case '\$':
        return Icons.attach_money;
      case '£':
        return Icons.currency_pound;
      case '¥':
        return Icons.currency_yen;
      default:
        return Icons.euro_symbol;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = S.of(context);

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
                    height: MediaQuery.of(context).size.height / 4,
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
                          trailing: Text(
                            l10n.commonUpdate,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          onTap: () {
                            // Navigation vers les paramètres d'affichage
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
                            _getCurrencyIcon(),
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          title: Text(
                            l10n.settingsDeviseTitle,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          trailing: DropdownButton<String>(
                            value: _currency,
                            underline: const SizedBox(),
                            alignment: AlignmentDirectional.centerEnd,
                            items: const [
                              DropdownMenuItem(
                                value: '€',
                                child: Text('Euro (€)'),
                              ),
                              DropdownMenuItem(
                                value: '\$',
                                child: Text('Dollar US (\$)'),
                              ),
                              DropdownMenuItem(
                                value: '£',
                                child: Text('Livre Sterling (£)'),
                              ),
                              DropdownMenuItem(
                                value: '¥',
                                child: Text('Yen (¥)'),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _currency = value!;
                              });
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
                          trailing: SegmentedButton<String>(
                            segments: const [
                              ButtonSegment<String>(
                                value: 'km',
                                label: Text('km'),
                              ),
                              ButtonSegment<String>(
                                value: 'miles',
                                label: Text('miles'),
                              ),
                            ],
                            selected: {_distanceUnit},
                            onSelectionChanged: (Set<String> newSelection) {
                              setState(() {
                                _distanceUnit = newSelection.first;
                              });
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
