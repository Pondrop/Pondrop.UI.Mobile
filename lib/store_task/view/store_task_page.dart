import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/store_task/view/camera_access_view.dart';
import 'package:pondrop/style/style.dart';

import '../bloc/store_task_bloc.dart';

class StoreTaskPage extends StatelessWidget {
  const StoreTaskPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const StoreTaskPage());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider.value(
      value: StoreTaskBloc()..add(const StoreTaskCheckCamera()),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton(
                      child: Text(
                        l10n.cancel,
                        style: AppStyles.linkTextStyle,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    const Expanded(
                        child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Low stock',
                        style: AppStyles.popupTitleTextStyle,
                      ),
                    )),
                    TextButton(
                      child: Text(
                        l10n.next,
                        style: AppStyles.linkTextStyle,
                      ),
                      onPressed: () {},
                    ),
                  ]),
              const Expanded(
                child: CameraAccessView(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
