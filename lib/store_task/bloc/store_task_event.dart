part of 'store_task_bloc.dart';

abstract class StoreTaskEvent extends Equatable {
  const StoreTaskEvent();

  @override
  List<Object> get props => [];
}

class StoreTaskCheckCamera extends StoreTaskEvent {
  const StoreTaskCheckCamera();
}
