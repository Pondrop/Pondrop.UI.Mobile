import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pondrop/store_report/store_report.dart';
import 'package:pondrop/task_templates/bloc/task_templates_bloc.dart';
import 'package:pondrop/task_templates/view/task_templates.dart';

import '../../helpers/helpers.dart';
import '../../fake_data/fake_data.dart';

class MockTaskTemplatesBloc extends MockBloc<TaskTemplatesEvent, TaskTemplatesState> implements TaskTemplatesBloc {}

void main() {
  late TaskTemplatesBloc taskTemplatesBloc;

  setUp(() {
    taskTemplatesBloc = MockTaskTemplatesBloc();
  });

  group('Task Templates', () {
        testWidgets('renders a Task Templates list', (tester) async {
      final templates = FakeStoreSubmissionTemplates.fakeTemplates();

      when(() => taskTemplatesBloc.state).thenReturn(const TaskTemplatesState());
      whenListen(
        taskTemplatesBloc,
        Stream.fromIterable([
          const TaskTemplatesState(status: TaskTemplateStatus.refreshing),
          TaskTemplatesState(status: TaskTemplateStatus.success, templates: templates),
        ]),
      );

      await tester.pumpApp(
        BlocProvider.value(
          value: taskTemplatesBloc,
          child: Scaffold(body: TaskTemplates(visit: FakeStoreVisits.fakeVist())),
        ),
      );

      await tester.pump();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(StoreReportListItem), findsOneWidget);
      expect(find.text(templates.first.title), findsOneWidget);
    });
  });
}