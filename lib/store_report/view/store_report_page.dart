import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/style/style.dart';
import 'package:pondrop/task_templates/task_templates.dart';

import '../bloc/store_report_bloc.dart';
import 'store_report_list_item.dart';

class StoreReportPage extends StatelessWidget {
  const StoreReportPage({Key? key}) : super(key: key);

  static const routeName = '/stores/report';
  static Route route(Store store) {
    return MaterialWithModalsPageRoute<void>(
        builder: (_) => const StoreReportPage(),
        settings: RouteSettings(name: routeName, arguments: store));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocProvider(
        create: (_) => StoreReportBloc(
              store: ModalRoute.of(context)!.settings.arguments as Store,
              submissionRepository:
                  RepositoryProvider.of<SubmissionRepository>(context),
            ),
        child: Scaffold(
          appBar: AppBar(
              elevation: 0,
              title: Text(
                l10n.storeActivity,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.w500),
              ),
              centerTitle: true),
          body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Material(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  elevation: 4,
                  child: _storeHeader(context),
                ),
                Expanded(
                  child: BlocBuilder<StoreReportBloc, StoreReportState>(
                      builder: (context, state) {
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) =>
                          StoreReportListItem(
                        submissionTemplate: state.templates.firstWhere(
                            (e) => e.id == state.submissions[index].templateId),
                        submissionResult: state.submissions[index],
                      ),
                      itemCount: state.submissions.length,
                    );
                  }),
                )
              ]),
          floatingActionButton: ElevatedButton.icon(
            icon: const Icon(Icons.add),
            label: Text(l10n.addItem(l10n.task.toLowerCase())),
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLightColor,
                foregroundColor: Colors.black),
            onPressed: () async {
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
