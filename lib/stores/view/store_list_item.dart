import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/store.dart';

class StoreListItem extends StatelessWidget {
  const StoreListItem({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final distanceString = store.getDistanceDisplayString();

    return Material(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(store.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1!
                                .copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w400)),
                        const SizedBox(height: 5),
                        Text(
                          distanceString.isNotEmpty
                              ? '$distanceString - ${store.address}'
                              : store.address,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption,
                        ),
                        const SizedBox(height: 4),
                        Divider(thickness: 0.5, color: Colors.grey[300])
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}
