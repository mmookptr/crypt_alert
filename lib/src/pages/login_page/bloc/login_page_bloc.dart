import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crypt_alert/src/app/cubits/dialog_cubit.dart';

part 'login_page_state.dart';
part 'login_page_event.dart';

typedef _Event = LoginPageEvent;
typedef _State = LoginPageState;

class LoginPageBloc extends Bloc<_Event, _State> {
  LoginPageBloc({
    required this.dialogCubit,
  }) : super(InitialState()) {
    on<StartedEvent>(_onStarted);
    on<LoadSuccededEvent>(_onLoadSucceeded);
    on<LoginRequestedEvent>(_onLoginRequested);
    on<LoginSucceededEvent>(_onLoginSucceeded);
    on<LoginFailedEvent>(_onLoginFailed);
  }

  final DialogCubit dialogCubit;

  void _onStarted(
    StartedEvent event,
    Emitter<_State> emit,
  ) async {
    add(LoadSuccededEvent());
  }

  void _onLoadSucceeded(
    LoadSuccededEvent event,
    Emitter<_State> emit,
  ) async {
    emit(LoadSuccessState());
  }

  void _onLoginRequested(
    LoginRequestedEvent event,
    Emitter<_State> emit,
  ) async {
    emit(LoginRequestingState());

    Timer(
      const Duration(seconds: 1),
      () => add(
        LoginSucceededEvent(username: event.username),
      ),
    );
  }

  void _onLoginSucceeded(
    LoginSucceededEvent event,
    Emitter<_State> emit,
  ) async {
    emit(LoginSuccessState(username: event.username));
  }

  void _onLoginFailed(
    LoginFailedEvent event,
    Emitter<_State> emit,
  ) async {
    final errorMessage = event.error;

    dialogCubit.show(title: "Login Failed", content: errorMessage);

    emit(state);
  }
}
