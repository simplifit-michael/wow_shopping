import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wow_shopping/widgets/common.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

final connectionProvider = ChangeNotifierProvider((ref) {
  return ConnectionProvider(Connectivity());
});

class ConnectionProvider extends ChangeNotifier {
  late final StreamSubscription _subscription;
  ConnectionProvider(Connectivity connectivity) {
    _subscription = connectivity.onConnectivityChanged.listen((event) {});
  }

  bool _hasConnection = false;
  bool get hasConnection => _hasConnection;
  set hasConnection(bool value) {
    _hasConnection = value;
    notifyListeners();
  }

  @override
  Future<void> dispose() async {
    await _subscription.cancel();
    super.dispose();
  }
}

@immutable
class ConnectionMonitor extends StatefulWidget {
  const ConnectionMonitor({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ConnectionMonitor> createState() => _ConnectionMonitorState();
}

class _ConnectionMonitorState extends State<ConnectionMonitor> {
  final connectivity = Connectivity();
  late final checkConnectivity = connectivity.checkConnectivity();
  late final onConnectivityChanged = connectivity.onConnectivityChanged;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: checkConnectivity,
      builder:
          (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return emptyWidget;
        }
        return StreamBuilder(
          initialData: snapshot.requireData,
          stream: onConnectivityChanged,
          builder: (BuildContext context,
              AsyncSnapshot<ConnectivityResult> snapshot) {
            final result = snapshot.requireData;
            return _ConnectivityBannerHost(
              isConnected: result != ConnectivityResult.none,
              banner: Material(
                color: Colors.red,
                child: Padding(
                  padding: verticalPadding4 + horizontalPadding12,
                  child: const Text(
                    'Please check your internet connection',
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              child: widget.child,
            );
          },
        );
      },
    );
  }
}

@immutable
class _ConnectivityBannerHost extends StatefulWidget {
  const _ConnectivityBannerHost({
    required this.isConnected,
    required this.banner,
    required this.child,
  });

  final bool isConnected;
  final Widget banner;
  final Widget child;

  @override
  State<_ConnectivityBannerHost> createState() =>
      _ConnectivityBannerHostState();
}

class _ConnectivityBannerHostState extends State<_ConnectivityBannerHost>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      value: widget.isConnected ? 0.0 : 1.0,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.fastOutSlowIn,
    );
  }

  @override
  void didUpdateWidget(covariant _ConnectivityBannerHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isConnected != widget.isConnected) {
      if (widget.isConnected) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomMultiChildLayout(
      delegate: _ConnectivityBannerHostDelegate(_animation),
      children: [
        LayoutId(
          id: _ConnectivityBannerHostWidgetId.child,
          child: widget.child,
        ),
        LayoutId(
          id: _ConnectivityBannerHostWidgetId.banner,
          child: widget.banner,
        ),
      ],
    );
  }
}

enum _ConnectivityBannerHostWidgetId { child, banner }

class _ConnectivityBannerHostDelegate extends MultiChildLayoutDelegate {
  _ConnectivityBannerHostDelegate(this._animation)
      : super(relayout: _animation);

  final Animation<double> _animation;

  @override
  void performLayout(Size size) {
    layoutChild(
        _ConnectivityBannerHostWidgetId.child, BoxConstraints.tight(size));
    positionChild(_ConnectivityBannerHostWidgetId.child, Offset.zero);

    final bannerSize = layoutChild(
      _ConnectivityBannerHostWidgetId.banner,
      BoxConstraints.tightFor(width: size.width),
    );
    positionChild(
      _ConnectivityBannerHostWidgetId.banner,
      Offset(
        0.0,
        size.height - (_animation.value * bannerSize.height),
      ),
    );
  }

  @override
  bool shouldRelayout(covariant _ConnectivityBannerHostDelegate oldDelegate) {
    return _animation != oldDelegate._animation;
  }
}
