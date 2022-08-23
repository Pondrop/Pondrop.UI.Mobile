import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

part 'task_templates_event.dart';
part 'task_templates_state.dart';

class TaskTemplatesBloc extends Bloc<TaskTemplatesEvent, TaskTemplatesState> {
  TaskTemplatesBloc({
    required Store store,
    required StoreRepository storeRepository
  })
      : _storeService = storeRepository,
        super(TaskTemplatesState()) {
  }

  final StoreRepository _storeService;
}
