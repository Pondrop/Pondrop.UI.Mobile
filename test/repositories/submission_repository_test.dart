import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:uuid/uuid.dart';

import '../fake_data/fake_data.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockSubmissionApi extends Mock implements SubmissionApi {}

void main() {
  final User user = User(email: 'me@email.com', accessToken: const Uuid().v4());

  late UserRepository userRepository;
  late SubmissionApi submissionApi;

  setUp(() {
    userRepository = MockUserRepository();
    submissionApi = MockSubmissionApi();

    when(() => userRepository.getUser())
        .thenAnswer((invocation) => Future<User?>.value(user));
  });

  group('SubmissionRepository', () {
    test('Construct an instance', () {
      expect(
          SubmissionRepository(
              userRepository: userRepository, submissionApi: submissionApi),
          isA<SubmissionRepository>());
    });
  });

  group('StoreRepository Templates', () {
    test('Get templates from API', () async {
      final templates = FakeStoreSubmissionTemplates.fakeTemplates();

      when(() => submissionApi.fetchTemplates(user.accessToken))
          .thenAnswer((invocation) => Future.value(templates));

      final repo = SubmissionRepository(
          userRepository: userRepository, submissionApi: submissionApi);

      final result = await repo.fetchTemplates();

      expect(result, templates);
    });
  });

  group('StoreRepository StoreVisit', () {
    test('Start StoreVisit', () async {
      final storeId = const Uuid().v4();
      final visit = StoreVisitDto(
          id: const Uuid().v4(),
          storeId: storeId,
          userId: const Uuid().v4(),
          latitude: 0,
          longitude: 0);

      when(() => submissionApi.startStoreVisit(user.accessToken, storeId, null))
          .thenAnswer((invocation) => Future.value(visit));

      final repo = SubmissionRepository(
          userRepository: userRepository, submissionApi: submissionApi);

      final result = await repo.startStoreVisit(storeId, null);

      expect(result, visit);
    });

    test('End StoreVisit', () async {
      final storeId = const Uuid().v4();
      final visit = StoreVisitDto(
          id: const Uuid().v4(),
          storeId: storeId,
          userId: const Uuid().v4(),
          latitude: 0,
          longitude: 0);

      when(() => submissionApi.endStoreVisit(user.accessToken, visit.id, null))
          .thenAnswer((invocation) => Future.value(visit));

      final repo = SubmissionRepository(
          userRepository: userRepository, submissionApi: submissionApi);

      final result = await repo.endStoreVisit(visit.id, null);

      expect(result, visit);
    });
  });
}
