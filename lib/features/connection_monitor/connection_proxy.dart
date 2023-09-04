import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

class ConnectionProxy with ChangeNotifier {
  final Connectivity _connectivity;

  late final StreamSubscription<ConnectivityResult> _subscription;

  bool get hasConnection => _hasConnection;
  set hasConnection(bool value) {
    _hasConnection = value;
    notifyListeners();
  }

  bool _hasConnection = false;

  ConnectionProxy(this._connectivity) {
    _subscription = _connectivity.onConnectivityChanged
        .listen((value) => hasConnection = value != ConnectivityResult.none);
  }

  @override
  Future<void> dispose()async {
    await _subscription.cancel();
    super.dispose();
  }
}
