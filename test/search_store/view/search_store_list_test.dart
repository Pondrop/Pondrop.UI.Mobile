import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/location/location.dart';
import 'package:pondrop/stores/bloc/store_bloc.dart';
import 'package:store_service/store_service.dart';

import '../../helpers/helpers.dart';

class MockLocationRepository extends Mock implements LocationRepository {}
class MockStoreService extends Mock implements StoreService {}

class MockStoreBloc extends MockBloc<StoreEvent, StoreState> implements StoreBloc {}

void main() {

  late LocationRepository locationRepository;
  late StoreService storeService;

  setUp(() {
    locationRepository = MockLocationRepository();
    storeService = MockStoreService();
  });

  group('SeachStoreList', () {
    late StoreBloc storeBloc;

    setUp(() {
      storeBloc = MockStoreBloc();
    });
    
});

  //   testWidgets('adds Store Fetch to Store Page appears',
  //   (tester) async {  
  //     when(() => storeBloc.state).thenReturn(const StoreState());

  //     await tester.pumpApp(
  //       BlocProvider.value(
  //         value: storeBloc,
  //         child: Scaffold(body:  StoresList(header:'Test')),
  //       ),
  //     );

  //     await tester.enterText(
  //       find.byKey(LoginForm.emailInputKey),
  //       testEmail,
  //     );
      
  //     verify(() => 
  //       loginBloc.add(const LoginEmailChanged(testEmail)),
  //     ).called(1);
  //   });

  //   testWidgets('adds LoginPasswordChanged to LoginBloc when password updated',
  //   (tester) async {
  //     when(() => loginBloc.state).thenReturn(const LoginState());

  //     await tester.pumpApp(
  //       BlocProvider.value(
  //         value: loginBloc,
  //         child: Scaffold(body: LoginForm()),
  //       ),
  //     );

  //     await tester.enterText(
  //       find.byKey(LoginForm.passwordInputKey),
  //       testPassword,
  //     );
      
  //     verify(() => 
  //       loginBloc.add(const LoginPasswordChanged(testPassword)),
  //     ).called(1);
  //   });

  //   testWidgets('loading indicator shown when status is submitting',
  //   (tester) async {
  //     when(() => loginBloc.state)
  //       .thenReturn(const LoginState(status: FormSubmissionStatusSubmitting()));

  //     await tester.pumpApp(
  //       BlocProvider.value(
  //         value: loginBloc,
  //         child: Scaffold(body: LoginForm()),
  //       ),
  //     );

  //     expect(find.byType(ElevatedButton), findsNothing);
  //     expect(find.byType(CircularProgressIndicator), findsOneWidget);
  //   });

  //   testWidgets('does not add LoginSubmitted to LoginBloc when submitted & invalid',
  //   (tester) async {
  //     when(() => loginBloc.state)
  //       .thenReturn(const LoginState());

  //     await tester.pumpApp(
  //       BlocProvider.value(
  //         value: loginBloc,
  //         child: Scaffold(body: LoginForm()),
  //       ),
  //     );

  //     await tester.tap(find.byType(ElevatedButton));
  //     verifyNever(() => loginBloc.add(const LoginSubmitted()));
  //   });

  //   testWidgets('adds LoginSubmitted to LoginBloc when submitted & valid',
  //   (tester) async {
  //     when(() => loginBloc.state)
  //       .thenReturn(const LoginState(email: testEmail, password: testPassword));

  //     await tester.pumpApp(
  //       BlocProvider.value(
  //         value: loginBloc,
  //         child: Scaffold(body: LoginForm()),
  //       ),
  //     );

  //     await tester.tap(find.byType(ElevatedButton));
  //     verify(() => loginBloc.add(const LoginSubmitted())).called(1);
  //   });

  //   testWidgets('show SnackBar when submission failure',
  //   (tester) async {
  //     const errMsg = 'BOOM 💥';

  //     whenListen(
  //       loginBloc,
  //       Stream.fromIterable([
  //         const LoginState(status: FormSubmissionStatusSubmitting()),
  //         const LoginState(status: FormSubmissionStatusFailed(errMsg)),
  //       ]),
  //     );
  //     when(() => loginBloc.state).thenReturn(
  //       const LoginState(status: FormSubmissionStatusFailed(errMsg)),
  //     );

  //     await tester.pumpApp(
  //       BlocProvider.value(
  //         value: loginBloc,
  //         child: Scaffold(body: LoginForm()),
  //       ),
  //     );

  //     expect(find.byType(SnackBar), findsNothing);
  //     await tester.pump();
  //     expect(find.byType(SnackBar), findsOneWidget);
  //     expect(find.text(errMsg), findsOneWidget);
  //   });
  // });
}