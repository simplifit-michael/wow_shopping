part of 'connection_monitor_bloc.dart';

@immutable
sealed class ConnectionMonitorEvent {}

class ConnectionMonitorConnectionEstablishedEvent
    extends ConnectionMonitorEvent {}

class ConnectionMonitorConnectionLostEvent extends ConnectionMonitorEvent {}
