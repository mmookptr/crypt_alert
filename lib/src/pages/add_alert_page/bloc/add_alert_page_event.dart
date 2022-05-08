part of 'add_alert_page_bloc.dart';

abstract class AddAlertPageEvent {}

class StartedEvent extends _Event {}

class LoadSucceededEvent extends _Event {}

class AddAlertRequestedEvent extends _Event {
  AddAlertRequestedEvent({required this.alert});

  final Alert alert;
}

class AddAlertSucceededEvent extends _Event {}

class AddAlertFailedEvent extends _Event {
  AddAlertFailedEvent(this.error);

  final String error;
}
