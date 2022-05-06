import 'package:crypt_alert/src/common/widgets/text_divider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crypt_alert/src/common/widgets/page_scaffold.dart';
import 'package:crypt_alert/src/app/cubits/dialog_cubit.dart';
import 'package:crypt_alert/src/app/cubits/router_cubit.dart';
import 'package:crypt_alert/src/common/widgets/loading_indicator.dart';

import 'bloc/home_page_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final usernameFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  bool showValidationError = false;
  String username = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      showAppBar: false,
      content: content(context),
    );
  }

  Widget content(BuildContext context) {
    return BlocProvider(
      create: (_) => HomePageBloc(
        dialogCubit: context.read<DialogCubit>(),
        routerCubit: context.read<RouterCubit>(),
      ),
      child: BlocBuilder<HomePageBloc, HomePageState>(
        builder: (context, state) {
          return mapStateToContent(context, state);
        },
      ),
    );
  }

  Widget mapStateToContent(
    BuildContext context,
    HomePageState state,
  ) {
    switch (state.runtimeType) {
      case InitialState:
        return initialContent(context, state as InitialState);
      case LoadSuccessState:
        return loadSuccessContent(context, state as LoadSuccessState);
      case LoginRequestingState:
        return loginRequestingContent(context, state as LoginRequestingState);
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
      child: Column(
        children: [
          const SizedBox(height: 56),
          appLogo(),
          const SizedBox(height: 24),
          appName(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(children: [
              usernameField(),
              //
              const SizedBox(height: 16),
              //
              passwordField(),
              //
              const SizedBox(height: 32),
              //
              loginButton(context),
              //
              const SizedBox(height: 20),
              //
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: TextDivider(label: "or"),
              ),
              //
              // const SizedBox(height: 8),
              //
              registerButton(context),
              //
            ]),
          )
        ],
      ),
    );
  }

  Widget appLogo() {
    return Stack(
      children: [
        Center(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.amber, borderRadius: BorderRadius.circular(160)),
            child: const SizedBox(
              width: 176,
              height: 176,
            ),
          ),
        ),
        const Center(
          child: Padding(
            padding: EdgeInsets.only(top: 8),
            child: Icon(
              Icons.notifications,
              size: 152,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  Widget appName() {
    return const Text(
      "Crypt Alert",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black54,
        fontSize: 32,
      ),
    );
  }

  Widget usernameField() {
    return TextField(
      controller: usernameFieldController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'Username',
        errorText: showValidationError
            ? fieldErrorText(usernameFieldController)
            : null,
      ),
      onChanged: (text) {
        setState(() {
          username = text;
        });
      },
    );
  }

  Widget passwordField() {
    return TextField(
      controller: passwordFieldController,
      obscureText: true,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Password',
          errorText: showValidationError
              ? fieldErrorText(passwordFieldController)
              : null),
      onChanged: (text) {
        setState(() {
          password = text;
        });
      },
    );
  }

  String? fieldErrorText(TextEditingController controller) {
    final text = controller.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }

    return null;
  }

  Widget loginButton(BuildContext context) {
    final bloc = context.read<HomePageBloc>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.amber,
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
          textStyle:
              const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      onPressed: () {
        final isLoginFormValid = username.isNotEmpty && password.isNotEmpty;

        if (isLoginFormValid) {
          bloc.add(LoginRequestedEvent(username, password));
        } else {
          setState(() {
            showValidationError = true;
          });
        }
      },
      child: const Text(
        'Log in',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget registerButton(BuildContext context) {
    final bloc = context.read<HomePageBloc>();

    return TextButton(
      style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
      onPressed: () {
        bloc.add(RegisterRequestedEvent());
      },
      child: const Text(
        'Sign up',
        style: TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
    );
  }

  Widget loginRequestingContent(
    BuildContext context,
    LoginRequestingState state,
  ) {
    return const LoadingIndicator();
  }
}
