import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

part 'store_report_event.dart';
part 'store_report_state.dart';

class StoreReportBloc extends Bloc<StoreReportEvent, StoreReportState> {
  StoreReportBloc({
    required Store store,
    required StoreRepository storeRepository
  })
      : _storeService = storeRepository,
        super(StoreReportState(store: store)) {
  }

  final StoreRepository _storeService;
}
