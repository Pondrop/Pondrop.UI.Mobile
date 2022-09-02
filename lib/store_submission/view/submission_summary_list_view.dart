import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/api/submission_api.dart';

import '../bloc/store_submission_bloc.dart';

class SubmissionSummaryListView extends StatelessWidget {
  const SubmissionSummaryListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<StoreSubmissionBloc>().state;
    return ListView.separated(
        padding: const EdgeInsets.fromLTRB(0, 15, 5, 10),
        controller: ModalScrollController.of(context),
        itemBuilder: (BuildContext context, int index) {
          final step = state.submission.steps[index];

          final photoWidgets = <Widget>[];
          final textWidgets = <Widget>[];

          for (final i in step.fields.where((e) => !e.result.isEmpty)) {
            if (i.fieldType == SubmissionFieldType.photo) {
              photoWidgets.add(Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.file(
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

          return Padding(
            padding: const EdgeInsets.all(16),
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
        },
        separatorBuilder: (context, index) {
          return Divider(
              indent: 16, height: 1, thickness: 1, color: Colors.grey[400]);
        },
        itemCount: state.submission.steps.length);
  }
}
