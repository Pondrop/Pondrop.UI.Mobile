import 'package:flutter/material.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/features/styles/styles.dart';

class StoreReportListItem extends StatelessWidget {
  const StoreReportListItem(
      {super.key,
      required this.submissionTemplate,
      this.submissionResult,
      this.onTap});

  final SubmissionTemplateDto submissionTemplate;
  final StoreSubmission? submissionResult;
  final GestureTapCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var photoCount = 0;
    var focusName = '';

    if (submissionResult?.steps.isNotEmpty == true) {
      photoCount = submissionResult!.steps
          .expand((e) => e.fields
              .where((e) => e.results.first.photoPathValue?.isNotEmpty == true))
          .length;
      focusName = submissionResult!.steps
          .expand((e) => e.fields
              .where((e) => e.fieldType == SubmissionFieldType.focus)
              .map((e) => e.toResultString()))
          .where((e) => e.isNotEmpty)
          .join(', ');
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Dims.xLarge, Dims.xSmall, Dims.xLarge, Dims.small),
      child: Material(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(
              color: Color.fromARGB(153, 114, 120, 126), width: 1),
        ),
        elevation: 2,
        color: const Color.fromARGB(255, 250, 252, 255),
        child: InkWell(
            onTap: () {
              onTap?.call();
            },
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Dims.medium),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: Dims.large),
                        child: Container(
                          padding: Dims.mediumEdgeInsets,
                          decoration: BoxDecoration(
                              color: PondropColors.primaryLightColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: Icon(
                            IconData(submissionTemplate.iconCodePoint,
                                fontFamily: submissionTemplate.iconFontFamily),
                            color: Colors.black,
                          ),
                        )),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(submissionTemplate.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600)),
                          const SizedBox(height: Dims.small),
                          Text(
                            focusName.isEmpty
                                ? submissionTemplate.description
                                : focusName,
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    if (photoCount > 0)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Dims.small, 0, Dims.medium, 0),
                        child: Row(
                          children: [
                            const Icon(Icons.photo_library_outlined),
                            const SizedBox(
                              width: 2,
                            ),
                            Text('$photoCount'),
                          ],
                        ),
                      )
                  ],
                ))),
      ),
    );
  }
}
