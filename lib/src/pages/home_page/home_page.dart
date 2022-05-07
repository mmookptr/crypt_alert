import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:intersperse/intersperse.dart';

import 'package:crypt_alert/src/common/widgets/token_card.dart';
import 'package:crypt_alert/src/pages/alert_page/alert_page.dart';
import 'package:crypt_alert/src/repositories/token_repository.dart';
import 'package:crypt_alert/src/app/cubits/authentication_cubit.dart';
import 'package:crypt_alert/src/pages/login_page/login_page.dart';
import 'package:crypt_alert/src/common/widgets/page_scaffold.dart';
import 'package:crypt_alert/src/app/cubits/dialog_cubit.dart';
import 'package:crypt_alert/src/common/widgets/loading_indicator.dart';

import 'bloc/home_page_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key? key,
    required this.username,
  }) : super(key: key);

  final String username;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomePageBloc(
        dialogCubit: context.read<DialogCubit>(),
        authenticationCubit: context.read<AuthenticationCubit>(),
        tokenRepository: TokenRepository(),
      ),
      child: PageScaffold(
        showAppBar: false,
        content: content(context),
        backgroundColor: Colors.amber,
      ),
    );
  }

  Widget content(BuildContext context) {
    return BlocBuilder<HomePageBloc, HomePageState>(
      builder: (context, state) {
        return mapStateToContent(context, state);
      },
    );
  }

  Widget mapStateToContent(
    BuildContext context,
    HomePageState state,
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
    HomePageState state,
  ) {
    context.read<HomePageBloc>().add(StartedEvent());

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                profile(context),
              ],
            ),
            const SizedBox(height: 16),
            pageTitleText(context),
            const SizedBox(height: 16),
            // ignore: unnecessary_cast
            ...(state.tokens
                    .map(
                      (token) => TokenCard(
                        token: token,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => AlertPage(token: token),
                            ),
                          );
                        },
                      ),
                    )
                    .toList() as List<Widget>)
                .intersperse(
              const SizedBox(height: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget profile(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        showAdaptiveActionSheet(
          context: context,
          actions: [
            BottomSheetAction(
              title: const Text('logout'),
              onPressed: () {
                Navigator.of(context).pop();

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                );
              },
            ),
          ],
          cancelAction: CancelAction(
            title: const Text('Cancel'),
          ), // onPressed parameter is optional by default will dismiss the ActionSheet
        )
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(
          //   color: Colors.black54,
          //   width: 2,
          // ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: const [
            CircleAvatar(
              backgroundImage: AssetImage('images/elonmusk.jpeg'),
              radius: 16,
            ),
            SizedBox(width: 8),
            Text(
              "Elon Musk",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget pageTitleText(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Text(
              "Token Lists",
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
