import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:crypt_alert/src/common/widgets/token_card.dart';
import 'package:crypt_alert/src/common/widgets/page_scaffold.dart';
import 'package:crypt_alert/src/app/cubits/dialog_cubit.dart';
import 'package:crypt_alert/src/common/widgets/loading_indicator.dart';

import '../../models/alert.dart';
import '../../models/token.dart';

import '../add_alert_page/add_alert_page.dart';
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
        title: "${token.name} Alerts",
        content: content(context),
        backgroundColor: Colors.amber,
        appBarActions: [addAlertButton()],
      ),
    );
  }

  Widget addAlertButton() {
    return BlocBuilder<AlertPageBloc, AlertPageState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () {
            Navigator.of(context)
                .push(
              MaterialPageRoute(
                builder: (_) => AddAlertPage(
                  token: token,
                ),
              ),
            )
                .then(
              (value) {
                context.read<AlertPageBloc>().add(LoadRequestedEvent());
              },
            );
          },
          icon: const Icon(Icons.add),
        );
      },
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
            const SizedBox(height: 16),
            alertList(context, state.alerts),
          ],
        ),
      ),
    );
  }

  Widget alertList(BuildContext context, List<Alert> alerts) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Alerts",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          ...(alerts.isNotEmpty)
              ? alerts.map((alert) => alertCard(context, alert)).toList()
              : const [
                  SizedBox(
                    height: 16,
                  ),
                  Text("No Alert")
                ]
        ],
      ),
    );
  }

  Widget alertCard(BuildContext context, Alert alert) {
    final bloc = context.read<AlertPageBloc>();

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.amber,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              (alert.isConditionMatched)
                  ? Row(
                      children: const [
                        Icon(
                          Icons.notification_important,
                          size: 24,
                          color: Colors.red,
                        ),
                        SizedBox(width: 4),
                      ],
                    )
                  : const SizedBox(width: 24),
              Text(
                alert.compareTo.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                (alert.compareBy == "Greater") ? ">" : "<",
                style: TextStyle(
                  color: (alert.compareBy == "Greater")
                      ? Colors.green
                      : Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                alert.compareValue.toString(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          IconButton(
              onPressed: () {
                bloc.add(DeleteAlertRequestedEvent(alert: alert));
              },
              icon: const Icon(Icons.delete)),
        ],
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
