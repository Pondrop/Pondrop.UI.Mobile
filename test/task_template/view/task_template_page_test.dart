import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/task_templates/task_templates.dart';
import 'package:pondrop/task_templates/view/task_template_list_item.dart';

import '../../helpers/helpers.dart';
void main() {

late TaskTemplateListItem _lowStockedItemTitle;

  group('Task Template', () {
    test('is routable', () {
      expect(TaskTemplatesPage.route(), isA<MaterialPageRoute>());
    });

    testWidgets('renders a Task Template page', (tester) async {
      await tester.pumpAppWithRoute((settings) {
        return MaterialPageRoute(
          settings: RouteSettings(),
          builder: (context) {
            return const TaskTemplatesPage();
          });
      });
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(TaskTemplateListItem), findsOneWidget);
    });
  });
}
