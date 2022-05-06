import 'package:flutter/material.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold(
      {Key? key,
      this.floatingActionButton,
      this.appBarActions,
      this.showAppBar = true,
      this.title,
      required this.content})
      : super(key: key);

  final String? title;
  final Widget content;
  final bool showAppBar;
  final Widget? floatingActionButton;
  final List<Widget>? appBarActions;

  @override
  Widget build(BuildContext context) {
    final title = this.title;

    return page(
      tapHandler: collapseKeyboard,
      appBar: showAppBar
          ? appBar(
              title: (title != null) ? title : "No Title",
              actions: appBarActions,
            )
          : null,
      content: content,
      floatingActionButton: floatingActionButton,
    );
  }

  Widget page({
    required Function tapHandler,
    required AppBar? appBar,
    required Widget content,
    required Widget? floatingActionButton,
  }) {
    return GestureDetector(
      onTap: () => tapHandler(),
      child: Scaffold(
        appBar: appBar,
        body: SafeArea(child: content),
        floatingActionButton: floatingActionButton,
      ),
    );
  }

  AppBar appBar({
    required String title,
    List<Widget>? actions,
  }) {
    return AppBar(
      elevation: 0,
      title: Text(title),
      actions: actions,
    );
  }

  void collapseKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
