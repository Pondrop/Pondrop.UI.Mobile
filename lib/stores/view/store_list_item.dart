import 'package:flutter/material.dart';

import '../models/store.dart';

class StoreListItem extends StatelessWidget {
  const StoreListItem({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    String distanceInString = store.distanceFromLocation >= 1000 ? '${convertMetersInKM(store.distanceFromLocation)}KM' : '${store.distanceFromLocation}M';
    return Material(
        child: Column(children: [
      ListTile(
        visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
        title: Padding(
          child: Text(store.name,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          padding: const EdgeInsets.only(bottom: 3.0),
        ),
        isThreeLine: false,
        subtitle: Text(
          '$distanceInString - ${store.address}',
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

    double convertMetersInKM(distanceInMeters){
      return double.parse((distanceInMeters / 1000).toStringAsFixed(2));
    }
}
