import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/task_templates/view/task_template_list_item.dart';

import '../bloc/task_templates_bloc.dart';

class TaskTemplatesPage extends StatelessWidget {
  const TaskTemplatesPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialWithModalsPageRoute<void>(
        builder: (_) => const TaskTemplatesPage(),
        settings: const RouteSettings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => TaskTemplatesBloc(
              submissionRepository: SubmissionRepository(),
              userRepository: context.read<UserRepository>(),
            )..add(const TaskTemplatesFetched()),
        child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                title: const Text(
                  'Select a task',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                centerTitle: true,
                leading: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })),
            body: Builder(
              builder: (context) {
                return _taskTemplates(context);
              }
            )));
  }

  Widget _taskTemplates(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).primaryColor,
      onRefresh: () {
        final bloc = context.read<TaskTemplatesBloc>()
          ..add(const TaskTemplatesRefreshed());
        return bloc.stream
            .firstWhere((e) => e.status != TaskTemplateStatus.refreshing);
      },
      child: BlocBuilder<TaskTemplatesBloc, TaskTemplatesState>(
        buildWhen: (previous, current) =>
            current.status != TaskTemplateStatus.refreshing,
        builder: (context, state) {
          if (state.status == TaskTemplateStatus.initial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == TaskTemplateStatus.failure ||
              state.templates.isEmpty) {
            return const Center(child: Text('No tasks found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 15, 5, 10),
            itemBuilder: (BuildContext context, int index) {
              final item = state.templates[index];
              return TaskTemplateListItem(submissionTemplate: item);
            },
            itemCount: state.templates.length,
          );
        },
      ),
    );
  }
}
