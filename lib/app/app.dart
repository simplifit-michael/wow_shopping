import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/app/config.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/features/login/login_screen.dart';
import 'package:wow_shopping/features/main/main_screen.dart';

export 'package:wow_shopping/app/config.dart';

const _appTitle = 'Shop Wow';

class ShopWowApp extends StatefulWidget with WatchItStatefulWidgetMixin{
  const ShopWowApp({
    super.key,
    required this.config,
  });

  final AppConfig config;

  @override
  State<ShopWowApp> createState() => _ShopWowAppState();
}

class _ShopWowAppState extends State<ShopWowApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get navigatorState => _navigatorKey.currentState!;

  bool? _isLoggedIn;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Intl.defaultLocale = PlatformDispatcher.instance.locale.toLanguageTag();
    _isLoggedIn = GetIt.I<AuthRepo>().isLoggedIn;
  }

  void _onLoginStateChanged(bool newIsLoggedIn) {
    if (_isLoggedIn??true && !newIsLoggedIn) {
      _isLoggedIn = newIsLoggedIn;
      navigatorState.pushAndRemoveUntil(LoginScreen.route(), (route) => false);
    } else if (!(_isLoggedIn??false) && newIsLoggedIn) {
      _isLoggedIn = newIsLoggedIn;
      navigatorState.pushAndRemoveUntil(MainScreen.route(), (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    registerStreamHandler<AuthRepo, bool?>(
      select: (repo) => repo.streamIsLoggedIn,
      handler: (context, isLoggedIn, cancel) {
        if (!isLoggedIn.hasData) return;
        _onLoginStateChanged(isLoggedIn.data!);
      },

    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appOverlayDarkIcons,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: _navigatorKey,
        title: _appTitle,
        theme: generateLightTheme(),
        onGenerateRoute: (RouteSettings settings) {
          if (settings.name == Navigator.defaultRouteName) {
            if (!(_isLoggedIn??false)) {
              return LoginScreen.route();
            }
            return MainScreen.route();
          } else {
            return null; // Page not found
          }
        },
      ),
    );
  }
}
