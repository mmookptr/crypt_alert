import 'package:crypt_alert/src/app/cubits/authentication_cubit.dart';
import 'package:crypt_alert/src/repositories/token_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crypt_alert/src/app/cubits/dialog_cubit.dart';

import '../../../models/token.dart';

part 'home_page_state.dart';
part 'home_page_event.dart';

typedef _Event = HomePageEvent;
typedef _State = HomePageState;

class HomePageBloc extends Bloc<_Event, _State> {
  HomePageBloc({
    required this.dialogCubit,
    required this.authenticationCubit,
    required this.tokenRepository,
  }) : super(InitialState()) {
    on<StartedEvent>(_onStarted);
    on<LoadRequestedEvent>(_onLoadRequested);
    on<LoadSucceededEvent>(_onLoadSucceeded);
    on<LoadFailedEvent>(_onLoadFailed);
  }

  final DialogCubit dialogCubit;
  final AuthenticationCubit authenticationCubit;
  final TokenRepository tokenRepository;

  void _onStarted(
    StartedEvent event,
    Emitter<_State> emit,
  ) async {
    add(LoadRequestedEvent());
  }

  void _onLoadRequested(
    LoadRequestedEvent event,
    Emitter<_State> emit,
  ) async {
    emit(LoadInProgressState());

    _loadTokens();
  }

  void _loadTokens() async {
    final tokens = await tokenRepository.getTokens();

    add(LoadSucceededEvent(tokens: tokens));
  }

  void _onLoadSucceeded(
    LoadSucceededEvent event,
    Emitter<_State> emit,
  ) async {
    emit(LoadSuccessState(tokens: event.tokens));
  }

  void _onLoadFailed(
    LoadFailedEvent event,
    Emitter<_State> emit,
  ) async {
    final errorMessage = event.error;

    dialogCubit.show(title: "Load Failed", content: errorMessage);

    emit(state);
  }
}
