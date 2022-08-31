import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/models/store_submission.dart';
import 'package:pondrop/store_submission/store_submission.dart';

class MockStoreSubmission extends Mock implements StoreSubmission {}

void main() {

  setUp(() {
  });

  group('Store Submission Page', () {
    test('is routable', () {
      expect(StoreSubmissionPage.route(MockStoreSubmission()), isA<MaterialPageRoute>());
    });
  });
}
