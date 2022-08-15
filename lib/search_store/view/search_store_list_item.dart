import 'package:flutter/material.dart';

import '../../stores/models/store.dart';


class SearchStoreListItem extends StatelessWidget {
  const SearchStoreListItem({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    
    return Material(
        child: Column(children: [
      ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        leading: const Icon(Icons.search),
        title: Padding(
          child: Text(store.name,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          padding: const EdgeInsets.only(bottom: 3.0),
        ),
        isThreeLine: false,
        subtitle: Text(
          '150m - ${store.address}',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          softWrap: false,
        ),
        dense: true,
      ),
      Container(
        padding: const EdgeInsets.only(left: 15.0),
        child: Divider(thickness: 0.5, color: Colors.grey[400]),
      )
    ]));
  }
}
