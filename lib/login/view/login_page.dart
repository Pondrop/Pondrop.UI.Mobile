import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/login/login.dart';
import 'package:user_repository/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) {
            return LoginBloc(
              authenticationRepository:
                  RepositoryProvider.of<AuthenticationRepository>(context),
              userRepository: RepositoryProvider.of<UserRepository>(context),
            );
          },
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: SvgPicture.asset('assets/pondrop.svg'),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: LoginForm(),
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
