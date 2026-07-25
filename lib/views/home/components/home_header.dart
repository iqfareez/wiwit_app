import 'package:flutter/material.dart';

import '../../../shared/models/wiwit_api/profile/profile_response.dart';
import '../../profile/settings_page.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.greeting,
    required this.profileDetail,
  });

  final String greeting;
  final ProfileResponse? profileDetail;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .stretch,
            children: [
              Text(greeting, style: TextStyle(fontSize: 14)),
              AnimatedSwitcher(
                duration: Durations.medium2,
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeOutCubic,
                layoutBuilder: (currentChild, previousChildren) => Stack(
                  alignment: Alignment.centerLeft,
                  children: [...previousChildren, ?currentChild],
                ),
                child: Text(
                  profileDetail?.name ?? '',
                  key: ValueKey(profileDetail),
                  style: TextStyle(fontSize: 24, fontWeight: .bold),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          child: Row(
            mainAxisAlignment: .end,
            children: [
              IconButton(
                onPressed: () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const SettingsPage())),
                tooltip: 'Settings',
                icon: _buildAvatar(context, profileDetail),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

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

/// Build avatar widget based on user's data
Widget _buildAvatar(BuildContext context, ProfileResponse? profileDetail) {
  if (profileDetail == null) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      child: const Icon(Icons.person_outline),
    );
  }
  // if profile detail is available, show profile picture accordingly
  if (profileDetail.profilePhotoUrl == null) {
    final initials = _getInitials(profileDetail.name);

    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
      child: Text(initials.isEmpty ? '' : initials),
    );
  }

  // if profile photo url exists
  return CircleAvatar(
    backgroundImage: NetworkImage(profileDetail.profilePhotoUrl!),
  );
}
