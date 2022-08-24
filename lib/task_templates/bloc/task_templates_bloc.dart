import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'task_templates_event.dart';
part 'task_templates_state.dart';

class TaskTemplatesBloc extends Bloc<TaskTemplatesEvent, TaskTemplatesState> {
  TaskTemplatesBloc():  super(const TaskTemplatesState());
}
