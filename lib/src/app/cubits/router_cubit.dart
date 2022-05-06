import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'router_state.dart';

typedef _State = RouterCubitState;

class RouterCubit extends Cubit<_State?> {
  RouterCubit() : super(null);

  void push({
    required Widget page,
  }) {
    emit(PushState(page: page));
  }

  void pushReplacement({
    required Widget page,
  }) {
    emit(PushReplacementState(page: page));
  }

  void pop() {
    emit(PopState());
  }
}
