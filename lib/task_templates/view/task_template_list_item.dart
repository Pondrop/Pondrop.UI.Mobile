import 'package:flutter/material.dart';

class TaskTemplateListItem extends StatelessWidget {
  const TaskTemplateListItem(
      {super.key,
      required this.icon,
      required this.title,
      required this.subtitle});

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.of(context).pop();
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
                          color: const Color.fromARGB(255, 201, 230, 255),
                          borderRadius: BorderRadius.circular(100)),
                      child: Icon(
                        icon,
                        color: Colors.black,
                      ),
                    )),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
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
