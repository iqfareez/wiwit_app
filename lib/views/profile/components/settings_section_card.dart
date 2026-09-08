import 'package:material_ui/material_ui.dart';

class SettingsSectionCard extends StatelessWidget {
  const SettingsSectionCard({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }
}
