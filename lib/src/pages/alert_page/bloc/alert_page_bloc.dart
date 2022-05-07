import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crypt_alert/src/app/cubits/dialog_cubit.dart';

import '../../../models/alert.dart';
import '../../../models/token.dart';

part 'alert_page_state.dart';
part 'alert_page_event.dart';

typedef _Event = AlertPageEvent;
typedef _State = AlertPageState;

class AlertPageBloc extends Bloc<_Event, _State> {
  AlertPageBloc({
    required this.dialogCubit,
    required this.alertCollection,
    required this.token,
  }) : super(InitialState()) {
    on<StartedEvent>(_onStarted);
    on<LoadRequestedEvent>(_onLoadRequested);
    on<LoadSucceededEvent>(_onLoadSucceeded);
    on<LoadFailedEvent>(_onLoadFailed);
  }

  final DialogCubit dialogCubit;
  final CollectionReference<Alert> alertCollection;
  final Token token;

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

    _loadAlerts(token.name);
  }

  void _loadAlerts(String tokenName) async {
    QuerySnapshot<Alert> querySnapshot =
        await alertCollection.where("tokenName", isEqualTo: tokenName).get();

    final alerts = querySnapshot.docs.map((doc) => doc.data()).toList();

    add(LoadSucceededEvent(alerts: alerts));
  }

  void _onLoadSucceeded(
    LoadSucceededEvent event,
    Emitter<_State> emit,
  ) async {
    emit(LoadSuccessState(alerts: event.alerts));
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
