import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypt_alert/src/app/cubits/authentication_cubit.dart';
import 'package:crypt_alert/src/repositories/token_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crypt_alert/src/app/cubits/dialog_cubit.dart';

import '../../../models/alert.dart';
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
    required this.alertCollection,
  }) : super(InitialState()) {
    on<StartedEvent>(_onStarted);
    on<LoadRequestedEvent>(_onLoadRequested);
    on<LoadSucceededEvent>(_onLoadSucceeded);
    on<LoadFailedEvent>(_onLoadFailed);
  }

  final DialogCubit dialogCubit;
  final AuthenticationCubit authenticationCubit;
  final TokenRepository tokenRepository;
  final CollectionReference<Alert> alertCollection;

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

    for (var token in tokens) {
      token.hasActiveAlert = await _hasActiveAlert(token);
    }

    add(LoadSucceededEvent(tokens: tokens));
  }

  Future<bool> _hasActiveAlert(Token token) async {
    QuerySnapshot<Alert> querySnapshot =
        await alertCollection.where("tokenName", isEqualTo: token.name).get();

    final alerts = querySnapshot.docs.map((doc) {
      final alert = doc.data();
      alert.id = doc.id;

      if (alert.compareTo == "Price") {
        final x = token.price;
        final isConditionMatched = (alert.compareBy == "Greater"
            ? x > alert.compareValue
            : x < alert.compareValue);

        alert.isConditionMatched = isConditionMatched;
      } else {
        final x = token.dailyChange;

        alert.isConditionMatched = (alert.compareBy == "Greater"
            ? x > alert.compareValue
            : x < alert.compareValue);
      }

      return alert;
    }).toList();

    return alerts
        .where((element) => element.isConditionMatched)
        .toList()
        .isNotEmpty;
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
