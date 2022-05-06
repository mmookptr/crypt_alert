import 'package:flutter/material.dart';

class AppDialog extends StatelessWidget {
  const AppDialog({
    Key? key,
    this.proceedButtonLabel,
    this.proceedHandler,
    this.dismissButtonLabel,
    this.dismissHandler,
    required this.title,
    required this.content,
  }) : super(key: key);
  final String title;
  final String content;
  final String? proceedButtonLabel;
  final Function? proceedHandler;
  final String? dismissButtonLabel;
  final Function? dismissHandler;

  @override
  Widget build(BuildContext context) {
    return dialog(
      context,
      title: title,
      content: content,
      buttons: actionButtons(context),
    );
  }

  Widget dialog(
    BuildContext context, {
    required String title,
    required String content,
    required List<Widget> buttons,
  }) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: actionButtons(context),
    );
  }

  List<Widget> actionButtons(BuildContext context) {
    final dismissButtonLabel = this.dismissButtonLabel;
    final dismissHandler = this.dismissHandler;
    final proceedButtonLabel = this.proceedButtonLabel;
    final proceedHandler = this.proceedHandler;

    if (proceedHandler != null) {
      return [
        dismissButton(context,
            label: (dismissButtonLabel != null) ? dismissButtonLabel : "cancel",
            tapHandler: dismissHandler),
        proceedButton(
          label: (proceedButtonLabel != null) ? proceedButtonLabel : "proceed",
          tapHandler: () {
            Navigator.pop(context);
            proceedHandler();
          },
        )
      ];
    } else {
      return [
        dismissButton(
          context,
          label: "ok",
          tapHandler: dismissHandler,
        ),
      ];
    }
  }

  Widget dismissButton(
    BuildContext context, {
    String? label,
    Function? tapHandler,
  }) {
    return TextButton(
      onPressed: () =>
          (tapHandler != null) ? tapHandler() : closeDialog(context),
      child: Text((label != null) ? label : "close"),
    );
  }

  Widget proceedButton({
    required String label,
    required Function tapHandler,
  }) {
    return TextButton(
      onPressed: () => tapHandler(),
      child: Text(label),
    );
  }

  void closeDialog(BuildContext context) {
    return Navigator.pop(context);
  }
}
