import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pondrop/api/submissions/models/submission_template_dto.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

part 'store_report_event.dart';
part 'store_report_state.dart';

class StoreReportBloc extends Bloc<StoreReportEvent, StoreReportState> {
  StoreReportBloc(
      {required Store store,
      required SubmissionRepository submissionRepository})
      : _submissionRepository = submissionRepository,
        super(StoreReportState(store: store)) {
    on<StoreReportSubmitted>(_onStoreReportSubmitted);
    _storeSubmissionSubscription = _submissionRepository.submissions.listen(
      (submission) => add(StoreReportSubmitted(submission: submission)),
    );
  }

  final SubmissionRepository _submissionRepository;

  late StreamSubscription<StoreSubmission> _storeSubmissionSubscription;

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
  Future<void> close() {
    _storeSubmissionSubscription.cancel();
    return super.close();
  }
}
