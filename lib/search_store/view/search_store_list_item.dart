import 'package:flutter/material.dart';

import '../../stores/models/store.dart';

class SearchStoreListItem extends StatelessWidget {
  const SearchStoreListItem({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    String distanceInString = store.distanceFromLocation >= 1000
        ? '${(store.convertDistanceToKM())}KM'
        : '${store.distanceFromLocation}M';
    return Material(
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
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
                        Padding(
                          child: Text(store.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500)),
                          padding: const EdgeInsets.only(bottom: 3.0),
                        ),
                        Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              '$distanceInString - ${store.address}',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 14, color: Colors.grey[500]),
                              softWrap: false,
                            )),
                        Divider(thickness: 0.5, color: Colors.grey[300])
                      ],
                    ),
                  ),
                )
              ],
            )));
  }
}
