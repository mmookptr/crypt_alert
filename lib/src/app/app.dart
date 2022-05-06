import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crypt_alert/src/app/cubits/authentication_cubit.dart';
import 'package:crypt_alert/src/app/cubits/dialog_cubit.dart';
import 'package:crypt_alert/src/app/cubits/router_cubit.dart';
import 'package:crypt_alert/src/common/widgets/app_dialog.dart';

import '../pages/login_page/login_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthenticationCubit>(
          create: (_) => AuthenticationCubit(),
        ),
        BlocProvider<DialogCubit>(
          create: (_) => DialogCubit(),
        ),
        BlocProvider<RouterCubit>(
          create: (_) => RouterCubit(),
        ),
      ],
      child: app(
        title: "CryptAlert",
        theme: theme(),
        home: MultiBlocListener(
          listeners: [
            BlocListener<DialogCubit, DialogData?>(
              listener: (context, dialogData) {
                if (dialogData == null) return;

                showDialog(
                  context: context,
                  builder: (context) {
                    return AppDialog(
                      title: dialogData.title,
                      content: dialogData.content,
                      proceedButtonLabel: dialogData.proceedButtonLabel,
                      proceedHandler: dialogData.proceedHandler,
                    );
                  },
                );
              },
            ),
            BlocListener<RouterCubit, RouterCubitState?>(
              listener: (context, state) {
                switch (state.runtimeType) {
                  case PushState:
                    {
                      final pushState = state as PushState;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => pushState.page,
                        ),
                      );

                      break;
                    }
                  case PushReplacementState:
                    {
                      final pushReplacementState =
                          state as PushReplacementState;

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => pushReplacementState.page,
                        ),
                      );

                      break;
                    }
                  case PopState:
                    {
                      Navigator.pop(context);

                      break;
                    }
                  default:
                    return;
                }
              },
            )
          ],
          child: const LoginPage(),
        ),
      ),
    );
  }

  Widget app({
    required String title,
    required Widget home,
    ThemeData? theme,
  }) {
    return MaterialApp(
      title: title,
      theme: theme,
      home: home,
    );
  }

  ThemeData theme() {
    return ThemeData(
      primaryColor: Colors.black,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white10,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
    );
  }
}
