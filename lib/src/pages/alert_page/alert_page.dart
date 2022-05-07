import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:crypt_alert/src/common/widgets/token_card.dart';
import 'package:crypt_alert/src/common/widgets/page_scaffold.dart';
import 'package:crypt_alert/src/app/cubits/dialog_cubit.dart';
import 'package:crypt_alert/src/common/widgets/loading_indicator.dart';

import '../../models/alert.dart';
import '../../models/token.dart';

import 'bloc/alert_page_bloc.dart';

class AlertPage extends StatelessWidget {
  AlertPage({
    Key? key,
    required this.token,
  }) : super(key: key);

  final Token token;

  final CollectionReference<Alert> alertCollection =
      FirebaseFirestore.instance.collection('alerts').withConverter<Alert>(
            fromFirestore: (snapshot, _) => Alert.fromJson(snapshot.data()!),
            toFirestore: (alert, _) => alert.toJson(),
          );

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlertPageBloc(
        dialogCubit: context.read<DialogCubit>(),
        alertCollection: alertCollection,
        token: token,
      ),
      child: PageScaffold(
        title: "${token.name} alerts",
        content: content(context),
        backgroundColor: Colors.amber,
        appBarActions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.add))
        ],
      ),
    );
  }

  Widget content(BuildContext context) {
    return BlocBuilder<AlertPageBloc, AlertPageState>(
      builder: (context, state) {
        return mapStateToContent(context, state);
      },
    );
  }

  Widget mapStateToContent(
    BuildContext context,
    AlertPageState state,
  ) {
    switch (state.runtimeType) {
      case InitialState:
        return initialContent(context, state as InitialState);
      case LoadInProgressState:
        return loadInProgressContent(context, state as LoadInProgressState);
      case LoadSuccessState:
        return loadSuccessContent(context, state as LoadSuccessState);
      default:
        throw Exception(
            "Incomplete State Mapping Case: No case for ${state.runtimeType}");
    }
  }

  Widget initialContent(
    BuildContext context,
    AlertPageState state,
  ) {
    context.read<AlertPageBloc>().add(StartedEvent());

    return Container();
  }

  Widget loadSuccessContent(
    BuildContext context,
    LoadSuccessState state,
  ) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TokenCard(token: token),
          ],
        ),
      ),
    );
  }

  Widget alertCard(BuildContext context, Alert alert) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [Text(alert.compareTo)],
      ),
    );
  }

  Widget pageTitleText(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Text(
              "Alerts",
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget loadInProgressContent(
    BuildContext context,
    LoadInProgressState state,
  ) {
    return const LoadingIndicator();
  }
}
