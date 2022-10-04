import 'package:flutter/material.dart';
import 'package:pondrop/features/styles/styles.dart';

class FocusHeaderView extends StatelessWidget {
  const FocusHeaderView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: Dims.mediumEdgeInsets,
          decoration: BoxDecoration(
              color: PondropColors.primaryLightColor,
              borderRadius: BorderRadius.circular(100)),
          child: const Icon(
            Icons.category_outlined,
            color: Colors.black,
            size: Dims.xxLarge * 1.25,
          ),
        ),
        const SizedBox(
          height: Dims.small,
        ),
        Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        const SizedBox(
          height: Dims.medium,
        )
      ],
    );
  }
}
