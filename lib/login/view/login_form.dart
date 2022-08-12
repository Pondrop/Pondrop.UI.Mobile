import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/login/login.dart';

class LoginForm extends StatelessWidget {
  LoginForm({super.key});

  static const emailInputKey = Key('LoginForm_Email_Input');
  static const passwordInputKey = Key('LoginForm_Password_Input');
  static const submitButtonKey = Key('LoginForm_Submit_Input');

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          final formStatus = state.status;
          if (formStatus is FormSubmissionStatusFailed) {
            _showSnackBar(context, formStatus.errorMessage);
          }
        },
        child: Form(
            key: _formKey,
            child: Align(
              alignment: const Alignment(0, -1 / 3),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _emailField(),
                  const Padding(padding: EdgeInsets.all(12)),
                  _passwordField(),
                  const Padding(padding: EdgeInsets.all(12)),
                  _loginButton(),
                ],
              ),
            )));
  }

  Widget _emailField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      final l10n = context.l10n;

      return TextFormField(
        key: emailInputKey,
        initialValue: state.email,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.email),
          labelText: l10n.email,
        ),
        validator: (value) => state.isValidEmail ? null : l10n.emailInvalid,
        onChanged: (value) =>
            context.read<LoginBloc>().add(LoginEmailChanged(value)),
      );
    },
    buildWhen: (o, n) => 
      o.email != n.email,);
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      final l10n = context.l10n;

      return TextFormField(
        key: passwordInputKey,
        initialValue: state.password,
        obscureText: state.passwordObscured,        
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.security),
          suffixIcon: IconButton(
            icon: Icon(
                state.passwordObscured 
                  ? Icons.visibility
                  : Icons.visibility_off,
               ),
            onPressed: () => context
              .read<LoginBloc>()
              .add(LoginPasswordObscuredChanged(!state.passwordObscured)),
            ),
          labelText: l10n.password,
        ),
        validator: (value) =>
            state.isPasswordEmpty
            ? l10n.passwordCannotBeEmpty
            : null,
        onChanged: (value) =>
            context.read<LoginBloc>().add(LoginPasswordChanged(value)),
      );
    },
    buildWhen: (o, n) => 
      o.password != n.password ||
      o.passwordObscured != n.passwordObscured,);
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      final l10n = context.l10n;
      final formStatus = state.status;

      if (formStatus is FormSubmissionStatusSubmitting) {
        return const CircularProgressIndicator();
      } else if (formStatus is FormSubmissionStatusSuccess) {
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 48,);
      } else {
        return ElevatedButton(
          key: submitButtonKey,
          onPressed: () {
            final currentState = _formKey.currentState;
            if (currentState != null && currentState.validate()) {
              context.read<LoginBloc>().add(const LoginSubmitted());
            }
          },
          child: Text(l10n.signIn),
        );
      }
    },
    buildWhen: (o, n) => 
      o.status != n.status,);
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}
