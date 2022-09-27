import 'package:flutter/material.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/features/styles/styles.dart';

class SearchProductListItem extends StatelessWidget {
  const SearchProductListItem({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          Navigator.of(context).pop([product]);
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              Dims.xLarge, Dims.medium, 0, Dims.xSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(product.name,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: Dims.small),
              Text(
                product.barcode,
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
