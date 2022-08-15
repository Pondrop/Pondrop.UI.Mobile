import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/app/app.dart';
import 'package:pondrop/counter/counter.dart';
import 'package:pondrop/location/repositories/location_repository.dart';
import 'package:pondrop/login/view/login_page.dart';
import 'package:store_service/store_service.dart';
import 'package:user_repository/user_repository.dart';
import 'package:uuid/uuid.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

class MockLocationRepository extends Mock implements LocationRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockStoreService extends Mock implements StoreService {}

void main() {
  late AuthenticationRepository authenticationRepository;
  late LocationRepository locationRepository;
  late UserRepository userRepository;
  late StoreService storeService;

  setUp(() {
    authenticationRepository = MockAuthenticationRepository();
    locationRepository = MockLocationRepository();
    userRepository = MockUserRepository();
    storeService = MockStoreService();
  });

  group('App', () {
    testWidgets('renders LoginPage when unauthenticated', (tester) async {
      when(() => authenticationRepository.status)
        .thenAnswer((_) => 
          Stream<AuthenticationStatus>
            .fromIterable([AuthenticationStatus.unauthenticated]));
      when(() => userRepository.getUser())
        .thenAnswer((_) => Future<User?>(() => null));

      await tester.pumpWidget(App(
        authenticationRepository: authenticationRepository,
        locationRepository: locationRepository,
        userRepository: userRepository,
        storeService: storeService
      ));

      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('renders CounterPage when authenticated', (tester) async {
      final user = User(const Uuid().v4(), email: 'dummy@email.com');

      when(() => authenticationRepository.status)
        .thenAnswer((_) => 
          Stream<AuthenticationStatus>
            .fromIterable([
              AuthenticationStatus.authenticated
            ]));
      when(() => userRepository.getUser())
        .thenAnswer((_) => Future<User?>(() => user));
      
      await tester.pumpWidget(App(
        authenticationRepository: authenticationRepository,
        locationRepository: locationRepository,
        userRepository: userRepository,
        storeService: storeService
      ));

      await tester.pumpAndSettle();
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
