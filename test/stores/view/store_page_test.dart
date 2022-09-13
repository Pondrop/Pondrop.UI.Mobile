import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/authentication/bloc/authentication_bloc.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/stores/view/store_list.dart';
import 'package:pondrop/stores/view/store_page.dart';

import '../../helpers/helpers.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}
class MockLocationRepository extends Mock implements LocationRepository {}
class MockStoreRepository extends Mock implements StoreRepository {}
class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

void main() {
  late AuthenticationRepository authenticationRepository;
  late LocationRepository locationRepository;
  late StoreRepository storeRepository;
  late AuthenticationBloc authenticationBloc;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    locationRepository = MockLocationRepository();
    storeRepository = MockStoreRepository();
    authenticationBloc = MockAuthenticationBloc();
  });

  group('Store', () {
    test('is routable', () {
      expect(StorePage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a Store List', (tester) async {
      const authState = AuthenticationState.authenticated(User(email: 'me@me.com', accessToken: 'let_me_in'));
      
      when(() => authenticationRepository.status)
        .thenAnswer((_) => 
          Stream<AuthenticationStatus>
            .fromIterable([AuthenticationStatus.authenticated]));
      when(() => authenticationBloc.stream)
        .thenAnswer((_) => 
          Stream<AuthenticationState>
            .fromIterable([authState]));
      when(() => authenticationBloc.state)
        .thenReturn(authState);
      
      await tester.pumpApp(MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: authenticationRepository),
          RepositoryProvider.value(value: storeRepository),
          RepositoryProvider.value(value: locationRepository),
        ],
        child: BlocProvider.value(
          value: authenticationBloc,
          child: const StorePage(),)
      ));

      await tester.pumpAndSettle();

      expect(find.byType(StoresList), findsOneWidget);
    });    
  });
}
