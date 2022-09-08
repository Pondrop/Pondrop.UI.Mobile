import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pondrop/task_templates/task_templates.dart';

import '../../fake_data/fake_data.dart';

void main() {

  setUp(() {
  });

  group('Task Templates Page', () {
    test('is routable', () {
      expect(TaskTemplatesPage.route(FakeStoreVisits.fakeVist()), isA<PageRoute>());
    });
  });
}