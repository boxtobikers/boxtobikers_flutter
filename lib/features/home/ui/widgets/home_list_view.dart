import 'package:flutter/material.dart';
import '../../../../generated/l10n.dart';
import '../../models/home_items_data.dart';

class HomeListView extends StatelessWidget {
  const HomeListView({super.key});

  @override
  Widget build(BuildContext context) {
    final listItems = HomeItemsData.getHomeItems(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        itemCount: listItems.length,
        itemBuilder: (context, index) {
          final item = listItems[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _HomeInteractiveItem(
              icon: item.icon,
              title: _getLocalizedString(context, item.titleKey),
              description: _getLocalizedString(context, item.descriptionKey),
              onTap: item.onTap,
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

// ---------------------------------------------------------------------------
// Interactive Home Item with Material 3 state layer styling
// ---------------------------------------------------------------------------
class _HomeInteractiveItem extends StatefulWidget {
  const _HomeInteractiveItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  @override
  State<_HomeInteractiveItem> createState() => _HomeInteractiveItemState();
}

class _HomeInteractiveItemState extends State<_HomeInteractiveItem> {
  final Set<WidgetState> _states = {};

  void _updateState(WidgetState state, bool value) {
    setState(() {
      if (value) {
        _states.add(state);
      } else {
        _states.remove(state);
      }
    });
  }

  bool get _isHovered => _states.contains(WidgetState.hovered);
  bool get _isFocused => _states.contains(WidgetState.focused);
  bool get _isPressed => _states.contains(WidgetState.pressed);

  // Material 3 state layer opacity values
  double _getStateLayerOpacity() {
    if (_isPressed) return 0.12;  // Pressed state
    if (_isHovered) return 0.08;  // Hover state
    if (_isFocused) return 0.12;  // Focus state
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final radius = BorderRadius.circular(12.0);

    // Calculate state layer color
    final stateLayerOpacity = _getStateLayerOpacity();
    final backgroundColor = stateLayerOpacity > 0
        ? Color.alphaBlend(
            colorScheme.primary.withValues(alpha: stateLayerOpacity),
            colorScheme.surface,
          )
        : colorScheme.surface;

    // Border color based on state
    final borderOpacity = _isPressed ? 0.9 : (_isHovered ? 0.8 : (_isFocused ? 0.85 : 0.6));
    final borderColor = colorScheme.primary.withValues(alpha: borderOpacity);

    return Material(
      color: Colors.transparent,
      child: FocusableActionDetector(
        onShowFocusHighlight: (focused) => _updateState(WidgetState.focused, focused),
        onShowHoverHighlight: (hovered) => _updateState(WidgetState.hovered, hovered),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: backgroundColor,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: radius,
          ),
          child: InkWell(
            onTap: widget.onTap,
            onHighlightChanged: (pressed) => _updateState(WidgetState.pressed, pressed),
            borderRadius: radius,
            splashColor: colorScheme.primary.withValues(alpha: 0.12),
            highlightColor: colorScheme.primary.withValues(alpha: 0.08),
            child: ListTile(
              leading: Icon(
                widget.icon,
                size: 24.0,
                color: colorScheme.primary,
              ),
              title: Text(
                widget.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                widget.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right,
                size: 24.0,
                color: colorScheme.primary,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
