import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/models/store_submission.dart';

import '../bloc/store_submission_bloc.dart';
import 'submission_field_view.dart';

class SubmissionSummaryListView extends StatelessWidget {
  const SubmissionSummaryListView({super.key, required this.step});

  final StoreSubmissionStep step;

  @override
  Widget build(BuildContext context) {
    assert(step.isSummary,
        '"SubmissionSummaryListView" invalid state, current step must be summary');
    final state = context.read<StoreSubmissionBloc>().state;
    final currentStepIdx = max(0, state.currentStepIdx);

    return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        controller: ModalScrollController.of(context),
        itemBuilder: (BuildContext context, int index) {
          if (index < currentStepIdx) {
            return _stepItem(context, state.submission.steps[index]);
          }

          final field = step.fields[index - currentStepIdx];
          return _summaryFieldItem(context, field);
        },
        separatorBuilder: (context, index) {
          return _itemSeparator(index, currentStepIdx, step.fields.length);
        },
        itemCount: currentStepIdx + step.fields.length);
  }

  Widget _stepItem(BuildContext context, StoreSubmissionStep step) {
    final photoWidgets = <Widget>[];
    final textWidgets = <Widget>[];

    for (final i in step.fields.where((e) => !e.result.isEmpty)) {
      if (i.fieldType == SubmissionFieldType.photo) {
        photoWidgets.add(_photoCard(Image.file(
          File(i.result.photoPathValue!),
          fit: BoxFit.cover,
          width: 72,
          height: 72,
        )));
      } else {
        textWidgets.add(Text(
          i.label,
          style: Theme.of(context)
              .textTheme
              .bodyText1!
              .copyWith(color: Colors.grey, fontWeight: FontWeight.w400),
        ));
        textWidgets.add(const SizedBox(
          height: 2,
        ));
        textWidgets.add(Text(i.resultString,
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w400)));
        textWidgets.add(const SizedBox(
          height: 8,
        ));
      }
    }

    if (photoWidgets.isEmpty) {
      photoWidgets.add(_photoCard(const SizedBox(
        width: 72,
        height: 72,
        child: Center(child: Icon(Icons.no_photography_outlined)),
      )));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step.title.toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .bodyText1!
                .copyWith(fontWeight: FontWeight.w400),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: photoWidgets,
              ),
              const SizedBox(
                width: 8,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: textWidgets,
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _photoCard(Widget child) {
    return Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: child);
  }

  Widget _summaryFieldItem(BuildContext context, StoreSubmissionField field) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: SubmissionFieldView(
          field: field,
        ));
  }

  Widget _itemSeparator(int idx, int stepsLength, int summaryFieldsLength) {
    return idx > stepsLength
        ? const SizedBox.shrink()
        : Padding(
            padding: EdgeInsets.only(bottom: idx == stepsLength - 1 ? 24 : 8),
            child: Divider(
                indent: 16, height: 1, thickness: 1, color: Colors.grey[400]),
          );
  }
}