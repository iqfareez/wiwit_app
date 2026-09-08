import 'package:material_ui/material_ui.dart';

/// A single tappable row inside a settings section.
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.isDestructive = false,
    this.isCompact = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  /// Paints the tile in the error palette for irreversible actions.
  final bool isDestructive;

  /// Trims the row down for actions that sit alongside content rather than
  /// heading their own section.
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final foreground = isDestructive
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).colorScheme.onSurface;
    final iconBackground = isDestructive
        ? Theme.of(context).colorScheme.errorContainer
        : Theme.of(context).colorScheme.secondaryContainer;

    return ListTile(
      onTap: onTap,
      dense: isCompact,
      visualDensity: isCompact ? VisualDensity.compact : null,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isCompact ? 0 : 4,
      ),
      leading: Container(
        height: isCompact ? 34 : 40,
        width: isCompact ? 34 : 40,
        decoration: BoxDecoration(
          color: iconBackground,
          borderRadius: BorderRadius.circular(isCompact ? 12 : 14),
        ),
        child: Icon(icon, size: isCompact ? 18 : 20, color: foreground),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(
          context,
        ).colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
      ),
    );
  }
}
