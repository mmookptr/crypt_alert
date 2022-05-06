import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:crypt_alert/src/app/cubits/dialog_cubit.dart';
import 'package:crypt_alert/src/app/cubits/router_cubit.dart';

import '../../register_page/register_page.dart';

part 'login_page_state.dart';
part 'login_page_event.dart';

typedef _Event = LoginPageEvent;
typedef _State = LoginPageState;

class LoginPageBloc extends Bloc<_Event, _State> {
  LoginPageBloc({
    required this.dialogCubit,
    required this.routerCubit,
  }) : super(InitialState()) {
    on<StartedEvent>(_onStarted);
    on<LoadSuccededEvent>(_onLoadSucceeded);
    on<LoginRequestedEvent>(_onLoginRequested);
    on<LoginSucceededEvent>(_onLoginSucceeded);
    on<LoginFailedEvent>(_onLoginFailed);
    on<RegisterRequestedEvent>(_onRegisterRequested);
  }

  final DialogCubit dialogCubit;
  final RouterCubit routerCubit;

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

    Timer(const Duration(seconds: 1),
        () => add(LoginSucceededEvent(username: event.username)));
  }

  void _onLoginSucceeded(
    LoginSucceededEvent event,
    Emitter<_State> emit,
  ) async {
    emit(state);

    // routerCubit.pushReplacement(page: HomePage(username: event.username));
  }

  void _onLoginFailed(
    LoginFailedEvent event,
    Emitter<_State> emit,
  ) async {
    final errorMessage = event.error;

    dialogCubit.show(title: "Login Failed", content: errorMessage);

    emit(state);
  }

  void _onRegisterRequested(
    RegisterRequestedEvent event,
    Emitter<_State> emit,
  ) async {
    routerCubit.push(page: const RegisterPage());

    emit(state);
  }
}
