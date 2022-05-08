import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crypt_alert/src/app/cubits/dialog_cubit.dart';

import '../../../models/alert.dart';
import '../../../models/token.dart';

part 'add_alert_page_state.dart';
part 'add_alert_page_event.dart';

typedef _Event = AddAlertPageEvent;
typedef _State = AddAlertPageState;

class AddAlertPageBloc extends Bloc<_Event, _State> {
  AddAlertPageBloc({
    required this.dialogCubit,
    required this.alertCollection,
    required this.token,
  }) : super(InitialState()) {
    on<StartedEvent>(_onStarted);
    on<LoadSucceededEvent>(_onLoadSucceeded);
    on<AddAlertRequestedEvent>(_onAddAlertRequested);
    on<AddAlertSucceededEvent>(_onAddAlertSucceeded);
    on<AddAlertFailedEvent>(_onAddAlertFailed);
  }

  final DialogCubit dialogCubit;
  final CollectionReference<Alert> alertCollection;
  final Token token;

  void _onStarted(
    StartedEvent event,
    Emitter<_State> emit,
  ) async {
    add(LoadSucceededEvent());
  }

  void _onLoadSucceeded(
    LoadSucceededEvent event,
    Emitter<_State> emit,
  ) {
    emit(LoadSuccessState());
  }

  void _onAddAlertRequested(
    AddAlertRequestedEvent event,
    Emitter<_State> emit,
  ) async {
    emit(AddAlertInProgressState());

    _addAlert(event.alert);
  }

  void _addAlert(Alert alert) async {
    try {
      await alertCollection.add(alert);

      add(AddAlertSucceededEvent());
    } catch (error) {
      add(AddAlertFailedEvent(error.toString()));
    }
  }

  void _onAddAlertSucceeded(
    AddAlertSucceededEvent event,
    Emitter<_State> emit,
  ) async {
    emit(AddAlertSuccessState());
  }

  void _onAddAlertFailed(
    AddAlertFailedEvent event,
    Emitter<_State> emit,
  ) async {
    final errorMessage = event.error;

    dialogCubit.show(title: "Load Failed", content: errorMessage);

    emit(state);
  }
}
