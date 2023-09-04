import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/backend/api_service.dart';
import 'package:wow_shopping/backend/auth_repo.dart';
import 'package:wow_shopping/backend/cart_repo.dart';
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/backend/wishlist_repo.dart';
import 'package:wow_shopping/features/connection_monitor/connection_proxy.dart';
import 'package:wow_shopping/features/splash/splash_screen.dart';
export 'package:wow_shopping/backend/product_repo.dart';
export 'package:wow_shopping/backend/wishlist_repo.dart';

Future<void> _initDI() async {
  GetIt.I.registerSingleton(ApiService(() async => GetIt.I<AuthRepo>().token));
  GetIt.I.registerSingletonAsync(() => AuthRepo.create(GetIt.I()));
  GetIt.I.registerSingletonAsync(() => ProductsRepo.create());
  GetIt.I.registerSingletonAsync(() => WishlistRepo.create(GetIt.I()),
      dependsOn: [ProductsRepo]);
  GetIt.I.registerSingletonAsync(() => CartRepo.create());
  GetIt.I.registerSingleton(ConnectionProxy(Connectivity()));
}

@immutable
class DIWidget extends StatefulWidget {
  const DIWidget({
    required this.child,
    Key? key,
  }) : super(key: key);

  final Widget child;

  @override
  State<DIWidget> createState() => _DIWidgetState();
}

class _DIWidgetState extends State<DIWidget> {
  @override
  void initState() {
    _initDI();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: GetIt.I.allReady(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Theme(
              data: generateLightTheme(),
              child: const Directionality(
                  textDirection: TextDirection.ltr, child: SplashScreen()));
        }
        return StreamBuilder<bool?>(
            stream: GetIt.I<AuthRepo>().streamIsLoggedIn,
            builder: (context, snapshot) {
              if (snapshot.data == null) {
                return Theme(
                    data: generateLightTheme(),
                    child: const Directionality(
                        textDirection: TextDirection.ltr,
                        child: SplashScreen()));
              }
              return widget.child;
            });
      },
    );
  }
}
