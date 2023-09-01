import 'dart:async';
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart' hide TextDirection;
import 'package:wow_shopping/app/config.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/api_service.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/backend/cart_repo.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';
import 'package:wow_shopping/features/account/cubit/account_cubit.dart';
import 'package:wow_shopping/features/cart/cubit/cart_cubit.dart';
import 'package:wow_shopping/features/connection_monitor/bloc/connection_monitor_bloc.dart';
import 'package:wow_shopping/features/login/login_screen.dart';
import 'package:wow_shopping/features/main/cubit/product_cubit.dart';
import 'package:wow_shopping/features/main/main_screen.dart';
import 'package:wow_shopping/features/splash/splash_screen.dart';
import 'package:wow_shopping/features/wishlist/cubit/wishlist_cubit.dart';

export 'package:wow_shopping/app/config.dart';

const _appTitle = 'Shop Wow';

class ShopWowApp extends StatefulWidget {
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

  late Future<void> _appLoader;

  late final AuthRepo _authRepo;
  late final ProductsRepo _productsRepo;
  late final WishlistRepo _wishlistRepo;
  late final CartRepo _cartRepo;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Intl.defaultLocale = PlatformDispatcher.instance.locale.toLanguageTag();
    _appLoader = _loadApp();
  }

  Future<void> _loadApp() async {
    await initializeDateFormatting();
    final apiService = ApiService(() async => _authRepo.token);
    _authRepo = await AuthRepo.create(apiService);
    _productsRepo = await ProductsRepo.create();
    _wishlistRepo = await WishlistRepo.create(_productsRepo);
    _cartRepo = await CartRepo.create();
    _authRepo.retrieveUser();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: appOverlayDarkIcons,
      child: FutureBuilder<void>(
        future: _appLoader,
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Theme(
              data: generateLightTheme(),
              child: const Directionality(
                textDirection: TextDirection.ltr,
                child: SplashScreen(),
              ),
            );
          } else {
            return MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => AccountCubit(_authRepo)),
                BlocProvider(create: (context) => ProductCubit(_productsRepo)),
                BlocProvider(create: (context) => CartCubit(_cartRepo)),
                BlocProvider(create: (context) => WishlistCubit(_wishlistRepo)),
                BlocProvider(
                    create: (context) => ConnectionMonitorBloc(Connectivity())),
              ],
              child: Builder(builder: (context) {
                return BlocListener<AccountCubit, AccountState>(
                  listener: (context, state) {
                    final isLoggedIn = state is AccountLoggedInState;
                    if (!isLoggedIn) {
                      navigatorState.pushAndRemoveUntil(
                          LoginScreen.route(), (route) => false);
                    } else {
                      navigatorState.pushAndRemoveUntil(
                          MainScreen.route(), (route) => false);
                    }
                  },
                  child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    navigatorKey: _navigatorKey,
                    title: _appTitle,
                    theme: generateLightTheme(),
                    onGenerateRoute: (RouteSettings settings) {
                      if (settings.name == Navigator.defaultRouteName) {
                        final state = context.read<AccountCubit>().state;
                        if (state is AccountLoggedOutState) {
                          return LoginScreen.route();
                        }
                        return MainScreen.route();
                      } else {
                        return null; // Page not found
                      }
                    },
                  ),
                );
              }),
            );
          }
        },
      ),
    );
  }
}
