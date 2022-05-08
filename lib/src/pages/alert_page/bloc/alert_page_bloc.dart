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
    on<DeleteAlertRequestedEvent>(_onDeleteAlertRequested);
    on<DeleteAlertSucceededEvent>(_onDeleteAlertSucceeded);
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

  void _onDeleteAlertRequested(
    DeleteAlertRequestedEvent event,
    Emitter<_State> emit,
  ) async {
    emit(LoadInProgressState());

    deleteAlert(event.alert);
  }

  void deleteAlert(Alert alert) async {
    try {
      await alertCollection.doc(alert.id).delete();

      add(DeleteAlertSucceededEvent());
    } catch (error) {
      add(LoadFailedEvent(error.toString()));
    }
  }

  void _onDeleteAlertSucceeded(
    DeleteAlertSucceededEvent event,
    Emitter<_State> emit,
  ) {
    emit(state);

    add(LoadRequestedEvent());
  }
}
