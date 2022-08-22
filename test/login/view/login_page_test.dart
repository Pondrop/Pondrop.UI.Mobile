import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/login/login.dart';
import 'package:pondrop/repositories/repositories.dart';

import '../../helpers/helpers.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late AuthenticationRepository authenticationRepository;
  late UserRepository userRepository;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    userRepository = MockUserRepository();
  });

  group('LoginPage', () {
    test('is routable', () {
      expect(LoginPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a LoginForm', (tester) async {
      await tester.pumpApp(MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authenticationRepository),
          RepositoryProvider.value(value: userRepository),
        ],
        child: const LoginPage()
      ));
      expect(find.byType(LoginForm), findsOneWidget);
    });
  });
}
