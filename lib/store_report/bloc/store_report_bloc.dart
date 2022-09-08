import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/api/submissions/models/submission_template_dto.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

part 'store_report_event.dart';
part 'store_report_state.dart';

class StoreReportBloc extends Bloc<StoreReportEvent, StoreReportState> {
  StoreReportBloc(
      {required Store store,
      required SubmissionRepository submissionRepository,
      required LocationRepository locationRepository})
      : _submissionRepository = submissionRepository,
        _locationRepository = locationRepository,
        super(StoreReportState(store: store)) {
    on<StoreVisitCreated>(_onStoreVisitCreated);
    on<StoreVisitFailed>(_onStoreVisitFailed);
    on<StoreReportSubmitted>(_onStoreReportSubmitted);

    _storeSubmissionSubscription = _submissionRepository.submissions.listen(
      (submission) => add(StoreReportSubmitted(submission: submission)),
    );

    _locationRepository.getLastKnownPosition().then((value) =>
        _submissionRepository
            .startStoreVisit(
                store.id, LatLng(value?.latitude ?? 0, value?.longitude ?? 0))
            .then((value) => add(value != null
                ? StoreVisitCreated(visit: value)
                : const StoreVisitFailed())));
  }

  final SubmissionRepository _submissionRepository;
  final LocationRepository _locationRepository;

  late StreamSubscription<StoreSubmission> _storeSubmissionSubscription;

  void _onStoreVisitCreated(
    StoreVisitCreated event,
    Emitter<StoreReportState> emit,
  ) {
    emit(state.copyWith(
        visitStatus: StoreReportVisitStatus.started, visit: event.visit));
  }

  void _onStoreVisitFailed(
    StoreVisitFailed event,
    Emitter<StoreReportState> emit,
  ) {
    emit(state.copyWith(visitStatus: StoreReportVisitStatus.failed));
  }

  Future<void> _onStoreReportSubmitted(
    StoreReportSubmitted event,
    Emitter<StoreReportState> emit,
  ) async {
    final templates = List<SubmissionTemplateDto>.from(state.templates);
    if (templates.isEmpty) {
      try {
        templates.addAll(await _submissionRepository.fetchTemplates());
      } catch (e) {
        log(e.toString());
      }
    }

    if (templates.any((e) => e.id == event.submission.templateId)) {
      emit(state.copyWith(
          templates: templates,
          submissions: List<StoreSubmission>.from(state.submissions)
            ..add(event.submission)));
    }
  }

  @override
  Future<void> close() async {
    _storeSubmissionSubscription.cancel();

    try {
      if (state.visit != null) {
        final position = await _locationRepository.getLastKnownPosition();
        await _submissionRepository.endStoreVisit(state.visit!.id,
            LatLng(position?.latitude ?? 0, position?.longitude ?? 0));
      }
    } catch (e) {
      log(e.toString());
    }

    await super.close();
  }
}
