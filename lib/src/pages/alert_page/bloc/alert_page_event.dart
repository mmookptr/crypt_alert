part of 'alert_page_bloc.dart';

abstract class AlertPageEvent {}

class StartedEvent extends _Event {}

class LoadRequestedEvent extends _Event {}

class LoadSucceededEvent extends _Event {
  LoadSucceededEvent({required this.alerts});

  final List<Alert> alerts;
}

class LoadFailedEvent extends _Event {
  LoadFailedEvent(this.error);

  final String error;
}

class DeleteAlertRequestedEvent extends _Event {
  DeleteAlertRequestedEvent({required this.alert});

  final Alert alert;
}

class DeleteAlertSucceededEvent extends _Event {}
