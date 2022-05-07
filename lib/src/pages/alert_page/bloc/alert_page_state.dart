part of 'alert_page_bloc.dart';

abstract class AlertPageState {}

class InitialState extends _State {}

class LoadInProgressState extends _State {}

class LoadSuccessState extends _State {
  LoadSuccessState({required this.alerts});

  final List<Alert> alerts;
}

class LoadFailureState extends _State {}
