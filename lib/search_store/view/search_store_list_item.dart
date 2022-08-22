import 'package:flutter/material.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/store_report/store_report.dart';

class SearchStoreListItem extends StatelessWidget {
  const SearchStoreListItem({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final distanceString = store.getDistanceDisplayString();

    return InkWell(
        onTap: () async {
          await Navigator.of(context).push(StoreReportPage.route(store));
        },
        child: Padding(
            padding: const EdgeInsets.fromLTRB(6, 10, 0, 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(
                    Icons.search,
                    size: 22,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(store.displayName,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(
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
                ),
              ],
            )));
  }
}
