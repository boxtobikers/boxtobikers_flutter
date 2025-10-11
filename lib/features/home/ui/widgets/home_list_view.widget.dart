import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../models/home_items_data.dart';

class HomeListViewWidget extends StatefulWidget {
  const HomeListViewWidget({super.key});

  @override
  State<HomeListViewWidget> createState() => _HomeListViewWidgetState();
}

class _HomeListViewWidgetState extends State<HomeListViewWidget> {
  // Track the state of each item by index
  final Map<int, Set<WidgetState>> _itemStates = {};

  Set<WidgetState> _getItemStates(int index) {
    return _itemStates.putIfAbsent(index, () => {});
  }

  void _updateItemState(int index, WidgetState state, bool value) {
    setState(() {
      final states = _getItemStates(index);
      if (value) {
        states.add(state);
      } else {
        states.remove(state);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final listItems = HomeItemsData.getHomeItems(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          final item = listItems[index];
          final states = _getItemStates(index);
          final theme = Theme.of(context);
          final colorScheme = theme.colorScheme;
          final radius = BorderRadius.circular(12.0);

          // Use Material 3 primary button state colors
          final overlayColor = WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.onPrimaryContainer;
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primaryContainer;
            }
            if (states.contains(WidgetState.focused)) {
              return colorScheme.onPrimaryContainer;
            }
            return null;
          });

          // Use Material 3 primary container colors for background
          final backgroundColor = WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return colorScheme.primaryContainer;
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primaryContainer;
            }
            if (states.contains(WidgetState.focused)) {
              return colorScheme.primaryContainer;
            }
            return colorScheme.surface;
          }).resolve(states);

          // Use Material 3 primary colors for border
          final borderColor = WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed) ||
                states.contains(WidgetState.focused)) {
              return colorScheme.primary;
            }
            if (states.contains(WidgetState.hovered)) {
              return colorScheme.primary;
            }
            return colorScheme.outlineVariant;
          }).resolve(states);

          // Text colors adapt to background
          final isInteractive = states.contains(WidgetState.pressed) ||
                                 states.contains(WidgetState.hovered) ||
                                 states.contains(WidgetState.focused);

          final titleColor = isInteractive ? colorScheme.onPrimaryContainer : colorScheme.onSurface;
          final subtitleColor = isInteractive ? colorScheme.onPrimaryContainer : colorScheme.onSurfaceVariant;
          final iconColor = isInteractive ? colorScheme.onPrimaryContainer : colorScheme.primary;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Material(
              color: Colors.transparent,
              child: FocusableActionDetector(
                onShowFocusHighlight: (focused) => _updateItemState(index, WidgetState.focused, focused),
                onShowHoverHighlight: (hovered) => _updateItemState(index, WidgetState.hovered, hovered),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOutCubic,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    border: Border.all(color: borderColor, width: 1),
                    borderRadius: radius,
                  ),
                  child: InkWell(
                    onTap: item.onTap,
                    onHighlightChanged: (pressed) => _updateItemState(index, WidgetState.pressed, pressed),
                    borderRadius: radius,
                    overlayColor: overlayColor,
                    child: ListTile(
                      leading: Icon(
                        item.icon,
                        size: 24.0,
                        color: iconColor,
                      ),
                      title: Text(
                        _getLocalizedString(context, item.titleKey),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: titleColor,
                        ),
                      ),
                      subtitle: Text(
                        _getLocalizedString(context, item.descriptionKey),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: subtitleColor,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        size: 24.0,
                        color: iconColor,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _getLocalizedString(BuildContext context, String key) {
    final localizations = S.of(context);
    switch (key) {
      case 'homeItemExploreTitle':
        return localizations.homeItemExploreTitle;
      case 'homeItemExploreDescription':
        return localizations.homeItemExploreDescription;
      case 'homeItemWhoAmITitle':
        return localizations.homeItemWhoAmITitle;
      case 'homeItemWhoAmIDescription':
        return localizations.homeItemWhoAmIDescription;
      case 'homeItemSettingsTitle':
        return localizations.homeItemSettingsTitle;
      case 'homeItemSettingsDescription':
        return localizations.homeItemSettingsDescription;
      default:
        return key;
    }
  }
}
