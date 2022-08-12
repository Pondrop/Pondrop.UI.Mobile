import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/login/login.dart';
import 'package:user_repository/user_repository.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  const testEmail = 'test@test.com';
  const testPassword = 'super_secure_password';

  late AuthenticationRepository authenticationRepository;
  late UserRepository userRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    userRepository = MockUserRepository();
  });

  group('LoginBloc', () {
    test('initial state is LoginState', () {
      expect(
        LoginBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,).state,
        equals(const LoginState()));
    });

    blocTest<LoginBloc, LoginState>(
      'emits new email when LoginEmailChanged added',
      build: () => LoginBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,),
      act: (bloc) => bloc.add(const LoginEmailChanged(testEmail)),
      expect: () => [const LoginState(email: testEmail)],
    );

    blocTest<LoginBloc, LoginState>(
      'emits new password when LoginPasswordChanged added',
      build: () => LoginBloc(
          authenticationRepository: authenticationRepository,
          userRepository: userRepository,),
      act: (bloc) => bloc.add(const LoginPasswordChanged(testPassword)),
      expect: () => [const LoginState(password: testPassword)],
    );
  });
}
