import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../shared/providers/auth_provider.dart';
import '../shared/providers/server_url_provider.dart';
import 'auth/login_page.dart';
import 'home/home.dart';
import 'onboarding/server_set_page.dart';

/// The screen the app shows when nothing is pushed on top of it.
enum _RootPage {
  serverSetup,
  login,
  home;

  Widget build() => switch (this) {
    _RootPage.serverSetup => const ServerSetPage(),
    _RootPage.login => const LoginPage(),
    _RootPage.home => const Home(),
  };
}

class RootView extends ConsumerStatefulWidget {
  const RootView({super.key});

  @override
  ConsumerState<RootView> createState() => _RootViewState();
}

class _RootViewState extends ConsumerState<RootView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  /// MaterialApp only installs a hero controller on its own Navigator, and one
  /// controller cannot serve two Navigators. Without this, Hero flights across
  /// root screens (the logo between onboarding and login) silently do nothing.
  final _heroController = MaterialApp.createMaterialHeroController();

  @override
  void dispose() {
    _heroController.dispose();
    super.dispose();
  }

  _RootPage _pageFor({required bool hasServer, required bool isAuthenticated}) {
    if (!hasServer) return _RootPage.serverSetup;
    if (!isAuthenticated) return _RootPage.login;

    return _RootPage.home;
  }

  @override
  Widget build(BuildContext context) {
    final hasServer = ref.watch(serverUrlProvider).value?.isNotEmpty ?? false;
    final isAuthenticated = ref.watch(isAuthenticatedProvider);

    final page = _pageFor(
      hasServer: hasServer,
      isAuthenticated: isAuthenticated,
    );

    // This Navigator is nested inside MaterialApp's, so system back presses
    // reach the outer one first. Without this handler, backing out of Settings
    // would try to close the app instead.
    return NavigatorPopHandler(
      onPopWithResult: (_) => _navigatorKey.currentState?.pop(),
      child: HeroControllerScope(
        controller: _heroController,
        child: Navigator(
          key: _navigatorKey,
          pages: [_FadeScalePage(key: ValueKey(page), child: page.build())],
          // Only ever one page in the list, so a page is removed exactly when
          // the state that produced it already changed. Nothing left to do
          // here.
          onDidRemovePage: (_) {},
        ),
      ),
    );
  }
}

/// Swaps root screens with a fade and a subtle scale.
class _FadeScalePage extends Page<void> {
  const _FadeScalePage({required this.child, required super.key});

  static const _duration = Duration(milliseconds: 550);
  static const _scaleBegin = 0.94;

  final Widget child;

  @override
  Route<void> createRoute(BuildContext context) {
    return PageRouteBuilder<void>(
      settings: this,
      transitionDuration: _duration,
      pageBuilder: (_, _, _) => child,
      transitionsBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOutCubic,
        );

        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: _scaleBegin, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
