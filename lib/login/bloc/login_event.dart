part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class LoginPasswordChanged extends LoginEvent {
  const LoginPasswordChanged(this.password);

  final String password;

  @override
  List<Object> get props => [password];
}

class LoginPasswordObscuredChanged extends LoginEvent {
  const LoginPasswordObscuredChanged(this.passwordObscured);

  final bool passwordObscured;

  @override
  List<Object> get props => [passwordObscured];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}