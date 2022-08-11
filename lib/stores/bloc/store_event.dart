part of 'store_bloc.dart';

abstract class storeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class storeFetched extends storeEvent {}