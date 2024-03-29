part of 'home_page_bloc.dart';

abstract class HomePageState {}

class InitialState extends _State {}

class LoadInProgressState extends _State {}

class LoadSuccessState extends _State {
  LoadSuccessState({required this.tokens});

  final List<Token> tokens;
}

class LoadFailureState extends _State {}
