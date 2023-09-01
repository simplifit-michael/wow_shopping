part of 'connection_monitor_bloc.dart';

@immutable
sealed class ConnectionMonitorState {
  bool get isConnected => this is ConnectionMonitorConnectedState;
}

final class ConnectionMonitorConnectedState extends ConnectionMonitorState {}

final class ConnectionMonitorDisconnectedState extends ConnectionMonitorState {}
