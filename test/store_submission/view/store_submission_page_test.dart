import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/dialogs/dialogs.dart';
import 'package:pondrop/models/store_submission.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/store_submission/store_submission.dart';
import 'package:pondrop/store_submission/view/camera_access_view.dart';

import '../../fake_data/fake_data.dart';
import '../../helpers/helpers.dart';

class MockCameraRepository extends Mock implements CameraRepository {}
class MockLocationRepository extends Mock implements LocationRepository {}
class MockSubmissionRepository extends Mock implements SubmissionRepository {}

void main() {
  late CameraRepository cameraRepository;
  late LocationRepository locationRepository;
  late SubmissionRepository submissionRepository;

  late StoreVisitDto visit;
  late StoreSubmission submission;

  setUp(() {
    cameraRepository = MockCameraRepository();
    locationRepository = MockLocationRepository();
    submissionRepository = MockSubmissionRepository();

    visit = FakeStoreVisit.fakeVist();
    submission =
        FakeStoreSubmissionTemplates.fakeTemplates().first.toStoreSubmission();
  });

  group('Store Submission Page', () {
    test('is routable', () {
      expect(
          StoreSubmissionPage.route(visit, submission),
          isA<MaterialPageRoute>());
    });

    testWidgets('renders camera request view', (tester) async {
      when(() => cameraRepository.isCameraEnabled())
        .thenAnswer((_) => Future.value(false));
      when(() => locationRepository.getLastKnownPosition())
        .thenAnswer((_) => Future.value(null));

      await tester.pumpApp(MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: submissionRepository),
          RepositoryProvider.value(value: cameraRepository),
          RepositoryProvider.value(value: locationRepository),
        ],
        child: StoreSubmissionPage(visit: visit, submission: submission,))
      );

      await tester.pumpAndSettle();

      expect(find.byType(CameraAccessView), findsOneWidget);
    });

    testWidgets('request camera access', (tester) async {
      when(() => cameraRepository.isCameraEnabled())
        .thenAnswer((_) => Future.value(false));
      when(() => cameraRepository.request())
        .thenAnswer((_) => Future.value(false));
      when(() => locationRepository.getLastKnownPosition())
        .thenAnswer((_) => Future.value(null));

      await tester.pumpApp(MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: submissionRepository),
          RepositoryProvider.value(value: cameraRepository),
          RepositoryProvider.value(value: locationRepository),
        ],
        child: StoreSubmissionPage(visit: visit, submission: submission,))
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byKey(CameraAccessView.okayButtonKey));
      await tester.pumpAndSettle();

      verify(() => cameraRepository.request()).called(1);

      expect(find.byType(CameraAccessView), findsOneWidget);
    });

    testWidgets('renders first step dialog', (tester) async {
      when(() => cameraRepository.isCameraEnabled())
        .thenAnswer((_) => Future.value(true));
      when(() => locationRepository.getLastKnownPosition())
        .thenAnswer((_) => Future.value(null));

      await tester.pumpApp(MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: submissionRepository),
          RepositoryProvider.value(value: cameraRepository),
          RepositoryProvider.value(value: locationRepository),
        ],
        child: StoreSubmissionPage(visit: visit, submission: submission,))
      );

      await tester.pumpAndSettle();

      expect(find.byType(DialogPage), findsOneWidget);
      expect(find.text(submission.steps.first.instructionsContinueButton), findsOneWidget);
    });
  });
}
