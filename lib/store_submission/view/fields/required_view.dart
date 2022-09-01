import 'package:flutter/material.dart';
import 'package:pondrop/l10n/l10n.dart';

class RequiredView extends StatelessWidget {
  const RequiredView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 12, 0),
          child: Text(l10n.fieldRequired,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontStyle: FontStyle.italic)),
        ),
      ],
    );
  }
}
