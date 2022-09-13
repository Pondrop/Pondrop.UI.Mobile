import 'package:flutter/material.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/styles/pondrop_styles.dart';
import 'package:pondrop/styles/route_transitions.dart';

import 'submission_summary_list_view.dart';

class StoreSubmissionSummaryPage extends StatelessWidget {
  const StoreSubmissionSummaryPage({Key? key, required this.submission})
      : super(key: key);

  static Route route(StoreSubmission submission) {
    return RouteTransitions.modalSlideRoute(
        pageBuilder: (_) => StoreSubmissionSummaryPage(submission: submission));
  }

  final StoreSubmission submission;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: Text(
              submission.title,
              style: PondropStyles.appBarTitleTextStyle),
            centerTitle: true,
            leading: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                })),
        body: SubmissionSummaryListView(
          submission: submission,
          stepIdx: submission.steps.length - 1,
          readOnly: true,
        ));
  }
}
