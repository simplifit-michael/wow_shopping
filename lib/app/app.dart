import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:wow_shopping/app/config.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/backend/backend_init.dart';
import 'package:wow_shopping/features/login/login_screen.dart';
import 'package:wow_shopping/features/main/main_screen.dart';
import 'package:wow_shopping/features/splash/splash_screen.dart';

export 'package:wow_shopping/app/config.dart';

const _appTitle = 'Shop Wow';

class ShopWowApp extends ConsumerStatefulWidget {
  const ShopWowApp({
    super.key,
    required this.config,
  });

  final AppConfig config;

  @override
  ConsumerState<ShopWowApp> createState() => _ShopWowAppState();
}

class _ShopWowAppState extends ConsumerState<ShopWowApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState? get navigatorState => _navigatorKey.currentState;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Intl.defaultLocale = PlatformDispatcher.instance.locale.toLanguageTag();
  }

  void _onLoginStateChanged(bool oldIsLoggedIn, bool newIsLoggedIn) {
    if (oldIsLoggedIn && !newIsLoggedIn) {
      oldIsLoggedIn = newIsLoggedIn;
      navigatorState?.pushAndRemoveUntil(LoginScreen.route(), (route) => false);
    } else if (!oldIsLoggedIn && newIsLoggedIn) {
      oldIsLoggedIn = newIsLoggedIn;
      navigatorState?.pushAndRemoveUntil(MainScreen.route(), (route) => false);
    } else {
      debugPrint('OldValue: $oldIsLoggedIn, NewValue: $newIsLoggedIn');
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(
        authProvider,
        (previous, next) => _onLoginStateChanged(
            previous?.isLoggedIn ?? false, next.isLoggedIn));
    return ref.watch(backendInitProvider).when(
          data: (_) => AnnotatedRegion<SystemUiOverlayStyle>(
              value: appOverlayDarkIcons,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: _navigatorKey,
                title: _appTitle,
                theme: generateLightTheme(),
                onGenerateRoute: (RouteSettings settings) {
                  if (settings.name == Navigator.defaultRouteName) {
                    if (ref.read(authProvider).isLoggedIn) {
                      return LoginScreen.route();
                    }
                    return MainScreen.route();
                  } else {
                    return null; // Page not found
                  }
                },
              )),
          error: (_, __) => const Center(child: Text('An Error Occured')),
          loading: () => Theme(
            data: generateLightTheme(),
            child: const Directionality(
              textDirection: TextDirection.ltr,
              child: SplashScreen(),
            ),
          ),
        );
  }
}
