import 'package:flutter/material.dart';

import '../models/store.dart';

class StoreListItem extends StatelessWidget {
  const StoreListItem({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: ListTile(
        title:  Text(store.name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        isThreeLine: true,
        subtitle: Text('150m - ${store.address}', style: TextStyle(fontSize: 15, color: Colors.grey[600])),
        dense: true,
      ),
    );
  }
}
