import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

part 'store_task_event.dart';
part 'store_task_state.dart';

class StoreTaskBloc extends Bloc<StoreTaskEvent, StoreTaskState> {
  StoreTaskBloc() : super(StoreTaskInitial()) {
    on<StoreTaskCheckCamera>(_onCheckAndRequestCameraPermission);
  }

  Future<void> _onCheckAndRequestCameraPermission(
    StoreTaskCheckCamera event, Emitter<StoreTaskState> emit
  ) async {
    var status = await Permission.camera.request();
    if (status.isDenied) {
      // We didn't ask for permission yet or the permission has been denied before but not permanently.
    }
  }
}
