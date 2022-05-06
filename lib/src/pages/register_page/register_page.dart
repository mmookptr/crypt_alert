import 'package:crypt_alert/src/common/widgets/page_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:crypt_alert/src/app/cubits/dialog_cubit.dart';
import 'package:crypt_alert/src/app/cubits/router_cubit.dart';

import 'package:crypt_alert/src/common/widgets/loading_indicator.dart';

import 'bloc/register_page_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameFieldController = TextEditingController();
  final passwordFieldController = TextEditingController();
  final confirmPasswordFieldController = TextEditingController();
  bool showValidationError = false;
  String username = "";
  String password = "";
  String confirmPassword = "";

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: title(context),
      content: content(context),
    );
  }

  String title(BuildContext context) {
    return "";
  }

  Widget content(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterPageBloc(
        dialogCubit: context.read<DialogCubit>(),
        routerCubit: context.read<RouterCubit>(),
      ),
      child: BlocBuilder<RegisterPageBloc, RegisterPageState>(
        builder: (context, state) {
          return mapStateToContent(context, state);
        },
      ),
    );
  }

  Widget mapStateToContent(
    BuildContext context,
    RegisterPageState state,
  ) {
    switch (state.runtimeType) {
      case InitialState:
        return initialContent(context, state as InitialState);
      case LoadSuccessState:
        return loadSuccessContent(context, state as LoadSuccessState);
      case RegisterRequestingState:
        return registerRequestingContent(
            context, state as RegisterRequestingState);
      default:
        throw Exception(
            "Incomplete State Mapping Case: No case for ${state.runtimeType}");
    }
  }

  Widget initialContent(
    BuildContext context,
    RegisterPageState state,
  ) {
    context.read<RegisterPageBloc>().add(StartedEvent());

    return Container();
  }

  Widget loadSuccessContent(
    BuildContext context,
    LoadSuccessState state,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 32,
              vertical: 16,
            ),
            child: Column(children: [
              signupText(),
              //
              const SizedBox(height: 40),
              //
              usernameField(),
              //
              const SizedBox(height: 16),
              //
              passwordField(),
              //
              const SizedBox(height: 16),
              //
              confirmPasswordField(),
              //
              const SizedBox(height: 40),
              //
              registerButton(context)
            ]),
          )
        ],
      ),
    );
  }

  Widget signupText() {
    return Column(
      children: [
        Row(
          children: const [
            Text(
              "Sign up",
              style: TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Text(
              "let's get all the insights you need",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget usernameField() {
    return TextField(
      controller: usernameFieldController,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'Username',
        errorText: showValidationError ? usernameFieldErrorText() : null,
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
          errorText: showValidationError ? passwordFieldErrorText() : null),
      onChanged: (text) {
        setState(() {
          password = text;
        });
      },
    );
  }

  Widget confirmPasswordField() {
    return TextField(
      controller: confirmPasswordFieldController,
      obscureText: true,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: 'Confirm Password',
          errorText:
              showValidationError ? confirmPasswordFieldErrorText() : null),
      onChanged: (text) {
        setState(() {
          confirmPassword = text;
        });
      },
    );
  }

  String? usernameFieldErrorText() {
    final text = usernameFieldController.value.text;

    if (text.isEmpty) {
      return 'Can\'t be empty';
    }

    return null;
  }

  String? passwordFieldErrorText() {
    final passwordText = usernameFieldController.value.text;
    final confirmPasswordText = usernameFieldController.value.text;

    if (passwordText.isEmpty) {
      return 'Can\'t be empty';
    }

    if (passwordText != confirmPasswordText) {
      return 'Passwords are not matching';
    }

    return null;
  }

  String? confirmPasswordFieldErrorText() {
    final passwordText = usernameFieldController.value.text;
    final confirmPasswordText = usernameFieldController.value.text;

    if (confirmPasswordText.isEmpty) {
      return 'Can\'t be empty';
    }

    if (passwordText != confirmPasswordText) {
      return 'Passwords are not matching';
    }

    return null;
  }

  Widget registerButton(BuildContext context) {
    final bloc = context.read<RegisterPageBloc>();

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: Colors.amber,
          padding: const EdgeInsets.symmetric(horizontal: 64, vertical: 8),
          textStyle:
              const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      onPressed: () {
        final isPasswordAndConfirmPasswordMatched = password == confirmPassword;
        final isFieldNotEmpty = username.isNotEmpty &&
            password.isNotEmpty &&
            confirmPassword.isNotEmpty;
        final isRegisterFormValid =
            isFieldNotEmpty && isPasswordAndConfirmPasswordMatched;

        if (isRegisterFormValid) {
          bloc.add(RegisterRequestedEvent(username, password));
        } else {
          setState(() {
            showValidationError = true;
          });
        }
      },
      child: const Text(
        'Register',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget registerRequestingContent(
    BuildContext context,
    RegisterRequestingState state,
  ) {
    return const LoadingIndicator();
  }
}
