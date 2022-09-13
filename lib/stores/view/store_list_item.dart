import 'package:flutter/material.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/store.dart';
import 'package:pondrop/store_report/store_report.dart';
import 'package:pondrop/styles/dims.dart';

class StoreListItem extends StatelessWidget {
  const StoreListItem({super.key, required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final distanceString = store.getDistanceDisplayString();

    return InkWell(
        onTap: () async {
          await Navigator.of(context).push(StoreReportPage.route(store));
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(Dims.large, Dims.medium, 0, Dims.xSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(store.displayName,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium),
              const SizedBox(height: Dims.small),
              Text(
                distanceString.isNotEmpty
                    ? l10n.itemHyphenItem(distanceString, store.address)
                    : store.address,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.caption,
              ),
              const SizedBox(height: Dims.small),
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
