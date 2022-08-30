import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/repositories/repositories.dart';

import '../bloc/task_templates_bloc.dart';
import 'task_templates.dart';

class TaskTemplatesPage extends StatelessWidget {
  const TaskTemplatesPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialWithModalsPageRoute<void>(
        builder: (_) => const TaskTemplatesPage());
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
            body: Builder(builder: (context) {
              return const TaskTemplates();
            })));
  }
}
