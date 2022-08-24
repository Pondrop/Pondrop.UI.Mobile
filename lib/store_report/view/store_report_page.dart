import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';

import '../../task_templates/view/task_templates_page.dart';
import '../bloc/store_report_bloc.dart';

class StoreReportPage extends StatelessWidget {
  const StoreReportPage({Key? key}) : super(key: key);

  static Route route(Store store) {
    store = store;
    return MaterialPageRoute<void>(
        builder: (_) => const StoreReportPage(),
        settings: RouteSettings(arguments: store));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StoreReportBloc(
        store: ModalRoute.of(context)!.settings.arguments as Store,
        storeRepository: RepositoryProvider.of<StoreRepository>(context),
      ),
      child: Scaffold(
        appBar: AppBar(
            elevation: 0,
            title: const Text(
              'Store activity',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
            ),
            centerTitle: true),
        body: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          Material(
            color: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 4,
            child: _storeHeader(context),
          )
        ]),
        floatingActionButton: ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Add task'),
          style: ElevatedButton.styleFrom(
              primary: const Color(0xFFC8E1FD), onPrimary: Colors.black),
          onPressed:  () async {
          await Navigator.of(context).push(TaskTemplatesPage.route());
        },
      ),
    ));
  }

  Widget _storeHeader(BuildContext context) {
    return Builder(builder: (context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(
              Icons.location_on_outlined,
              size: 22,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 0, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(context.read<StoreReportBloc>().state.store.displayName,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1!
                          .copyWith(fontSize: 14, fontWeight: FontWeight.w400)),
                  const SizedBox(height: 4),
                  Text(
                    context.read<StoreReportBloc>().state.store.address,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          fontSize: 12,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }
}
