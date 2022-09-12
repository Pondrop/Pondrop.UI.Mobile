import 'package:flutter/material.dart';
import 'package:pondrop/models/models.dart';

import 'submission_summary_list_view.dart';

class StoreSubmissionSummaryPage extends StatelessWidget {
  const StoreSubmissionSummaryPage({Key? key, required this.submission})
      : super(key: key);

  static Route route(StoreSubmission submission) {
    return PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => StoreSubmissionSummaryPage(submission: submission),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(0, 1);
          const end = Offset.zero;
          final tween = Tween(begin: begin, end: end);
          final offsetAnimation = animation.drive(tween);
          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),        
        reverseTransitionDuration: Duration.zero);
  }

  final StoreSubmission submission;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: Text(
              submission.title,
              style:
                  const TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
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
            submission: submission, stepIdx: submission.steps.length - 1, readOnly: true,));
  }
}
