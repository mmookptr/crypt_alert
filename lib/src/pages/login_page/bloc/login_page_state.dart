part of 'login_page_bloc.dart';

abstract class LoginPageState {}

class InitialState extends _State {}

class LoadSuccessState extends _State {}

class LoginRequestingState extends _State {}

class LoginSuccessState extends _State {
  LoginSuccessState({required this.username});

  final String username;
}
