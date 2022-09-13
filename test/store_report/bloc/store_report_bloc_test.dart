import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/store_report/bloc/store_report_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../fake_data/fake_data.dart';

class MockLocationRepository extends Mock implements LocationRepository {}

class MockSubmissionRepository extends Mock implements SubmissionRepository {}

void main() {
  late LocationRepository locationRepository;
  late SubmissionRepository submissionRepository;
  late Store store;
  late Position position;
  late StoreVisitDto storeVisitDto;

  const latitude = 33.8688;
  const longitude = 151.2093;

  setUp(() {
    locationRepository = MockLocationRepository();
    submissionRepository = MockSubmissionRepository();
    store = FakeStore.fakeStore();
    position = Position(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
      accuracy: 0,
      altitude: 0,
      heading: 0,
      speed: 0,
      speedAccuracy: 0
    );
    storeVisitDto = StoreVisitDto(
      id: const Uuid().v4().toString(),
      storeId: store.id, userId: const Uuid().v4().toString(),
      latitude: latitude,
      longitude: longitude
    );
  });

  group('StoreReportBloc', () {
    test('initial state is Initial', () {
      when(() => submissionRepository.submissions)
          .thenAnswer((invocation) => Stream.fromIterable([]));
      when(() => locationRepository.getLastKnownPosition())
          .thenAnswer((invocation) => Future.delayed(const Duration(days: 1)));

      final bloc = StoreReportBloc(
        store: store,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      expect(bloc.state, equals(StoreReportState(store: store)));
    });

    test('create StoreVisit success', () async {
      when(() => submissionRepository.submissions)
          .thenAnswer((invocation) => Stream.fromIterable([]));
      when(() => submissionRepository.startStoreVisit(store.id, any()))
          .thenAnswer((invocation) => Future.value(storeVisitDto));
      when(() => locationRepository.getLastKnownPosition()).thenAnswer(
          (invocation) => Future.value(position));

      final bloc = StoreReportBloc(
        store: store,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      await bloc.stream.first;

      verify(() => submissionRepository.startStoreVisit(store.id, any())).called(1);
      verify(() => locationRepository.getLastKnownPosition()).called(1);

      expect(bloc.state.visit, storeVisitDto);
      expect(bloc.state.visitStatus, StoreReportVisitStatus.started);
    });

    test('create StoreVisit failed', () async {
      when(() => submissionRepository.submissions)
          .thenAnswer((invocation) => Stream.fromIterable([]));
      when(() => submissionRepository.startStoreVisit(store.id, any()))
          .thenAnswer((invocation) => Future.value(null));
      when(() => locationRepository.getLastKnownPosition()).thenAnswer(
          (invocation) => Future.value(position));

      final bloc = StoreReportBloc(
        store: store,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      await bloc.stream.first;

      expect(bloc.state.visit, null);
      expect(bloc.state.visitStatus, StoreReportVisitStatus.failed);
    });

    test('Submission created', () async {
      final templates = FakeStoreSubmissionTemplates.fakeTemplates();
      final sumbission = templates.first.toStoreSubmission();

      when(() => submissionRepository.fetchTemplates())
          .thenAnswer((invocation) => Future.value(templates));
      when(() => submissionRepository.submissions)
          .thenAnswer((invocation) => Stream.fromIterable([
            sumbission
          ]));
      when(() => submissionRepository.startStoreVisit(store.id, any()))
          .thenAnswer((invocation) => Future.value(storeVisitDto));
      when(() => locationRepository.getLastKnownPosition()).thenAnswer(
          (invocation) => Future.value(position));

      final bloc = StoreReportBloc(
        store: store,
        submissionRepository: submissionRepository,
        locationRepository: locationRepository,
      );

      await bloc.stream.first;

      verify(() => submissionRepository.fetchTemplates()).called(1);

      expect(bloc.state.visit, storeVisitDto);
      expect(bloc.state.visitStatus, StoreReportVisitStatus.started);
      expect(bloc.state.templates, templates);
      expect(bloc.state.submissions, [ sumbission ]);
    });
  });
}
