import 'package:material_ui/material_ui.dart';

import '../models/wiwit_api/profile/profile_response.dart';

class ProfileAvatarWidget extends StatelessWidget {
  const ProfileAvatarWidget({super.key, this.profileDetail, this.radius = 20});

  final ProfileResponse? profileDetail;
  final double? radius;

  /// Get initial from name. Max two letters only.
  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) {
      return '';
    }

    final parts = name.trim().split(RegExp(r'\s+'));
    final initials = <String>[];

    for (final part in parts.take(2)) {
      if (part.isNotEmpty) {
        initials.add(part[0].toUpperCase());
      }
    }

    return initials.join();
  }

  @override
  Widget build(BuildContext context) {
    final avatarBgColor = Theme.of(context).colorScheme.tertiary;
    final avatarFgColor = Theme.of(context).colorScheme.onTertiary;

    if (profileDetail == null) {
      return CircleAvatar(
        backgroundColor: avatarBgColor,
        radius: radius,
        child: Icon(Icons.person_outline, color: avatarFgColor),
      );
    }

    // if no profile picture, display user's initial
    if (profileDetail!.profilePhotoUrl == null) {
      final initials = _getInitials(profileDetail!.name);

      return CircleAvatar(
        backgroundColor: avatarBgColor,
        radius: radius,
        child: Text(
          initials.isEmpty ? '' : initials,
          style: TextStyle(color: avatarFgColor, fontWeight: .bold),
        ),
      );
    }

    // show profile picture
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(profileDetail!.profilePhotoUrl!),
    );
  }
}
