import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/api/submissions/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

import '../bloc/task_templates_bloc.dart';
import 'task_templates.dart';

class TaskTemplatesPage extends StatelessWidget {
  const TaskTemplatesPage({Key? key, required this.visit}) : super(key: key);

  static Route route(StoreVisitDto visit) {
    return PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => TaskTemplatesPage(visit: visit),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, 1);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),        
        reverseTransitionDuration: Duration.zero);
  }

  final StoreVisitDto visit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => TaskTemplatesBloc(
        submissionRepository:
            RepositoryProvider.of<SubmissionRepository>(context),
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
            return TaskTemplates(visit: visit,);
          })),
    );
  }
}
