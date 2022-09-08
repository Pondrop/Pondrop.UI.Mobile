import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/models/store_submission.dart';
import 'package:pondrop/store_submission/store_submission.dart';

class MockStoreVisitDto extends Mock implements StoreVisitDto {}
class MockStoreSubmission extends Mock implements StoreSubmission {}

void main() {

  setUp(() {
  });

  group('Store Submission Page', () {
    test('is routable', () {
      expect(StoreSubmissionPage.route(MockStoreVisitDto(), MockStoreSubmission()), isA<MaterialPageRoute>());
    });
  });
}
