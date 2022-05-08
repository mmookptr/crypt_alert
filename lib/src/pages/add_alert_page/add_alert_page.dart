import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:crypt_alert/src/common/widgets/token_card.dart';
import 'package:crypt_alert/src/common/widgets/page_scaffold.dart';
import 'package:crypt_alert/src/app/cubits/dialog_cubit.dart';
import 'package:crypt_alert/src/common/widgets/loading_indicator.dart';

import '../../models/alert.dart';
import '../../models/token.dart';

import 'bloc/add_alert_page_bloc.dart';

class AddAlertPage extends StatefulWidget {
  const AddAlertPage({
    Key? key,
    required this.token,
  }) : super(key: key);

  final Token token;

  @override
  State<AddAlertPage> createState() => _AddAlertPageState();
}

class _AddAlertPageState extends State<AddAlertPage> {
  final CollectionReference<Alert> alertCollection =
      FirebaseFirestore.instance.collection('alerts').withConverter<Alert>(
            fromFirestore: (snapshot, _) => Alert.fromJson(snapshot.data()!),
            toFirestore: (alert, _) => alert.toJson(),
          );

  final compareValueFieldController = TextEditingController();
  bool showValidationError = false;
  String compareTo = "Price";
  String compareBy = "Greater";
  num? compareValue;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddAlertPageBloc(
        dialogCubit: context.read<DialogCubit>(),
        alertCollection: alertCollection,
        token: widget.token,
      ),
      child: PageScaffold(
        title: "Add Alert",
        content: content(context),
        backgroundColor: Colors.amber,
      ),
    );
  }

  Widget content(BuildContext context) {
    return BlocBuilder<AddAlertPageBloc, AddAlertPageState>(
      builder: (context, state) {
        return mapStateToContent(context, state);
      },
    );
  }

  Widget mapStateToContent(
    BuildContext context,
    AddAlertPageState state,
  ) {
    switch (state.runtimeType) {
      case InitialState:
        return initialContent(context, state as InitialState);
      case LoadSuccessState:
        return loadSuccessContent(context, state as LoadSuccessState);
      case AddAlertInProgressState:
        return addAlertInProgressContent(
            context, state as AddAlertInProgressState);
      case AddAlertSuccessState:
        return addAlertSuccessContent(context, state as AddAlertSuccessState);
      default:
        throw Exception(
            "Incomplete State Mapping Case: No case for ${state.runtimeType}");
    }
  }

  Widget initialContent(
    BuildContext context,
    AddAlertPageState state,
  ) {
    context.read<AddAlertPageBloc>().add(StartedEvent());

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
            TokenCard(token: widget.token),
            const SizedBox(height: 16),
            addAlertCard(context),
          ],
        ),
      ),
    );
  }

  Widget addAlertCard(BuildContext context) {
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
                "Alert Info",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          compareToField(),
          const SizedBox(height: 16),
          compareByField(),
          const SizedBox(height: 16),
          compareValueField(),
          const SizedBox(height: 24),
          _addAlertButton(context),
        ],
      ),
    );
  }

  Widget compareToField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Compare to: ",
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          DropdownButton<String>(
            value: compareTo,
            icon: (compareTo == "Price")
                ? const Icon(
                    Icons.monetization_on,
                    color: Colors.amber,
                  )
                : const Icon(Icons.price_change, color: Colors.amber),
            elevation: 16,
            style: const TextStyle(color: Colors.black54, fontSize: 16),
            underline: Container(
              height: 2,
              color: Colors.amber,
            ),
            onChanged: (String? newValue) {
              setState(() {
                compareTo = newValue!;
              });
            },
            items: <String>['Price', 'DailyChange']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget compareByField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Compare by: ",
            style: TextStyle(color: Colors.black54, fontSize: 16),
          ),
          DropdownButton<String>(
            value: compareBy,
            icon: (compareBy == "Greater")
                ? const Icon(
                    Icons.add,
                    color: Colors.amber,
                  )
                : const Icon(
                    Icons.remove,
                    color: Colors.amber,
                  ),
            elevation: 16,
            style: const TextStyle(color: Colors.black54, fontSize: 16),
            underline: Container(
              height: 2,
              color: Colors.amber,
            ),
            onChanged: (String? newValue) {
              setState(() {
                compareBy = newValue!;
              });
            },
            items: <String>['Greater', 'Lesser']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget compareValueField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: compareValueFieldController,
        decoration: InputDecoration(
          labelText: "Target $compareTo",
          border: const OutlineInputBorder(),
          errorText: showValidationError ? compareValueFieldErrorText() : null,
        ),
        keyboardType: TextInputType.number,
        onChanged: (amount) {
          setState(() {
            compareValue = num.parse(amount);
          });
        },
      ),
    );
  }

  String? compareValueFieldErrorText() {
    final text = compareValueFieldController.value.text;

    try {
      final amount = double.parse(text);

      if (compareTo == "Price" && amount < 0) {
        return 'Must be greater than 0';
      }
    } catch (error) {
      return 'Must be a number';
    }

    return null;
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

  Widget _addAlertButton(BuildContext context) {
    final bloc = context.read<AddAlertPageBloc>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.amber,
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
          textStyle:
              const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      onPressed: () {
        final compareValue = this.compareValue;
        final isAddAlertFormValid = compareValue != null;

        if (isAddAlertFormValid) {
          bloc.add(
            AddAlertRequestedEvent(
              alert: Alert(
                compareBy: compareBy,
                compareTo: compareTo,
                compareValue: compareValue,
                tokenName: widget.token.name,
              ),
            ),
          );
        } else {
          setState(() {
            showValidationError = true;
          });
        }
      },
      child: const Text(
        "add",
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget addAlertInProgressContent(
    BuildContext context,
    AddAlertInProgressState state,
  ) {
    return const LoadingIndicator();
  }

  Widget addAlertSuccessContent(
    BuildContext context,
    AddAlertSuccessState state,
  ) {
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.of(context).pop(true);
    });

    return Container();
  }
}
