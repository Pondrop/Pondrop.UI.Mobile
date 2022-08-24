part of 'store_task_bloc.dart';

abstract class StoreTaskState extends Equatable {
  const StoreTaskState();
  
  @override
  List<Object> get props => [];
}

class StoreTaskInitial extends StoreTaskState {}
