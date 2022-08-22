import 'package:flutter/material.dart';
import 'package:pondrop/models/models.dart';

class SearchStoreListItem extends StatelessWidget {
  const SearchStoreListItem({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final distanceString = store.getDistanceDisplayString();

    return Material(
        child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      iconSize: 22.0,
                      onPressed: () => {},
                    )),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.only(left: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(store.displayName,
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
