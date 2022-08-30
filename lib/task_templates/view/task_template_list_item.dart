import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/api/submissions/models/submission_template_dto.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/store_submission/store_submission.dart';
import 'package:pondrop/style/app_colors.dart';

class TaskTemplateListItem extends StatelessWidget {
  const TaskTemplateListItem({super.key, required this.submissionTemplate});

  final SubmissionTemplateDto submissionTemplate;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          showCupertinoModalBottomSheet(
              context: context,
              builder: (context) => StoreSubmissionPage(
                submission: submissionTemplate.toStoreSubmission()
              ),
          );
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 2),
            child: Row(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(submissionTemplate.title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Text(
                        submissionTemplate.description,
                        style: Theme.of(context).textTheme.caption,
                      ),
                      const SizedBox(height: 10),
                      Divider(
                        thickness: 1,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                ),
              ],
            )));
  }
}
