part of 'home_page_bloc.dart';

abstract class HomePageEvent {}

class StartedEvent extends _Event {}

class LoadRequestedEvent extends _Event {}

class LoadSucceededEvent extends _Event {
  LoadSucceededEvent({required this.tokens});

  final List<Token> tokens;
}

class LoadFailedEvent extends _Event {
  LoadFailedEvent(this.error);

  final String error;
}
