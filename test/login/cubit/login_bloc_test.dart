import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/login/login.dart';
import 'package:pondrop/repositories/repositories.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

class MockLocationRepository extends Mock implements LocationRepository {}

void main() {
  const testEmail = 'test@test.com';
  const testPassword = 'super_secure_password';

  late AuthenticationRepository authenticationRepository;
  late LocationRepository locationRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    locationRepository = MockLocationRepository();
  });

  group('LoginBloc', () {
    test('initial state is LoginState', () {
      expect(
        LoginBloc(
          authenticationRepository: authenticationRepository,
          locationRepository: locationRepository,).state,
        equals(const LoginState()));
    });

    blocTest<LoginBloc, LoginState>(
      'emits new email when LoginEmailChanged added',
      build: () => LoginBloc(
          authenticationRepository: authenticationRepository,
          locationRepository: locationRepository,),
      act: (bloc) => bloc.add(const LoginEmailChanged(testEmail)),
      expect: () => [const LoginState(email: testEmail)],
    );

    blocTest<LoginBloc, LoginState>(
      'emits new password when LoginPasswordChanged added',
      build: () => LoginBloc(
          authenticationRepository: authenticationRepository,
          locationRepository: locationRepository,),
      act: (bloc) => bloc.add(const LoginPasswordChanged(testPassword)),
      expect: () => [const LoginState(password: testPassword)],
    );
  });
}
