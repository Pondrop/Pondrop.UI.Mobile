import 'package:flutter/material.dart';
import 'package:pondrop/models/store.dart';
import 'package:pondrop/store_report/store_report.dart';

class StoreListItem extends StatelessWidget {
  const StoreListItem({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final distanceString = store.getDistanceDisplayString();

    return InkWell(
        onTap: () async {
          await Navigator.of(context).push(StoreReportPage.route(store));
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 0, 2),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(store.name,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText1!
                      .copyWith(
                          fontSize: 16, fontWeight: FontWeight.w400)),
              const SizedBox(height: 8),
              Text(
                distanceString.isNotEmpty
                    ? '$distanceString - ${store.address}'
                    : store.address,
                overflow: TextOverflow.ellipsis,
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
        ));
  }
}
