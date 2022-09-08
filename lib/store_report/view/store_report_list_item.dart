import 'package:flutter/material.dart';
import 'package:pondrop/api/submission_api.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/style/app_colors.dart';

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
    final photoCount = submissionResult?.steps
            .expand((e) => e.fields
                .where((e) => e.result.photoPathValue?.isNotEmpty == true))
            .length ??
        0;

    return InkWell(
        onTap: () {
          onTap?.call();
        },
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: AppColors.primaryLightColor,
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
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                          const SizedBox(height: 8),
                          Text(
                            submissionTemplate.description,
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ],
                      ),
                    ),
                    if (photoCount > 0)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(6, 0, 12, 0),
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
                ),
                const SizedBox(height: 8),
                Divider(
                  indent: 72,
                  thickness: 1,
                  height: 1,
                  color: Colors.grey[300],
                ),
              ],
            )));
  }
}
