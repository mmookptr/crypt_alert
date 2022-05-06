part of 'router_cubit.dart';

abstract class RouterCubitState {}

class PushState extends _State {
  PushState({required this.page});

  final Widget page;
}

class PushReplacementState extends _State {
  PushReplacementState({
    required this.page,
  });

  final Widget page;
}

class PopState extends _State {}
