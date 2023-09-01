import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'connection_monitor_event.dart';
part 'connection_monitor_state.dart';

class ConnectionMonitorBloc
    extends Bloc<ConnectionMonitorEvent, ConnectionMonitorState> {
  final Connectivity _connectivity;

  late final StreamSubscription<ConnectivityResult>
      _onConnectivityChangedSubscription;

  ConnectionMonitorBloc(this._connectivity)
      : super(ConnectionMonitorConnectedState()) {
    on<ConnectionMonitorEvent>((event, emit) {
      switch (event) {
        case ConnectionMonitorConnectionEstablishedEvent():
          _onConnectionEstablished(emit);
        case ConnectionMonitorConnectionLostEvent():
          _onConnectionLost(emit);
      }
    });

    _initAsync();
  }

  void _onConnectionEstablished(Emitter<ConnectionMonitorState> emit) {
    emit(ConnectionMonitorConnectedState());
  }

  void _onConnectionLost(Emitter<ConnectionMonitorState> emit) {
    emit(ConnectionMonitorConnectedState());
  }

  Future<void> _initAsync() async {
    final isConnected =
        (await _connectivity.checkConnectivity()) != ConnectivityResult.none;
    if (!isConnected) add(ConnectionMonitorConnectionLostEvent());

    _onConnectivityChangedSubscription = _connectivity.onConnectivityChanged
        .listen((value) =>
            _onConnectionStateChanged(value != ConnectivityResult.none));
  }

  void _onConnectionStateChanged(bool isConnected) {
    if (!isConnected) {
      add(ConnectionMonitorConnectionLostEvent());
    } else {
      add(ConnectionMonitorConnectionEstablishedEvent());
    }
  }

  @override
  Future<void> close() async {
    await _onConnectivityChangedSubscription.cancel();
    return super.close();
  }
}
