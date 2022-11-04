import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/store_submission/screens/store_submission_summary_page.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:pondrop/features/task_templates/task_templates.dart';

import '../bloc/store_report_bloc.dart';
import '../widgets/store_report_list_item.dart';

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
              locationRepository:
                  RepositoryProvider.of<LocationRepository>(context),
              submissionRepository:
                  RepositoryProvider.of<SubmissionRepository>(context),
            ),
        child: BlocListener<StoreReportBloc, StoreReportState>(
          listener: (context, state) {
            if (state.visitStatus == StoreReportVisitStatus.failed) {
              showDialog(
                context: context,
                builder: (_) => _storeVisitFailed(context),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                title: Text(
                  l10n.storeActivity,
                  style: PondropStyles.appBarTitleTextStyle,
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: Dims.small),
                        itemBuilder: (BuildContext context, int index) {
                          return Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                title: Text(
                                  (state.submissions.length > 1
                                          ? l10n.itemSpaceItem(
                                              state.submissions.length
                                                  .toString(),
                                              l10n.completed)
                                          : l10n.completed)
                                      .toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption!
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                children: [
                                  for (final i in state.submissions)
                                    StoreReportListItem(
                                        submissionTemplate: state.templates
                                            .firstWhere(
                                                (e) => e.id == i.templateId),
                                        submissionResult: i,
                                        onTap: () => Navigator.of(context).push(
                                            StoreSubmissionSummaryPage.route(
                                                i)))
                                ],
                              ));
                        },
                        itemCount: state.submissions.isNotEmpty ? 1 : 0,
                      );
                    }),
                  )
                ]),
            floatingActionButton:
                BlocBuilder<StoreReportBloc, StoreReportState>(
              builder: (context, state) {
                switch (state.visitStatus) {
                  case StoreReportVisitStatus.starting:
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: PondropColors.primaryLightColor,
                            foregroundColor: Colors.black),
                        onPressed: () {},
                        child: const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        ));
                  case StoreReportVisitStatus.started:
                    return ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addItem(l10n.task.toLowerCase())),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: PondropColors.primaryLightColor,
                          foregroundColor: Colors.black),
                      onPressed: () async {
                        await Navigator.of(context)
                            .push(TaskTemplatesPage.route(state.visit!));
                      },
                    );
                  default:
                    return const SizedBox.shrink();
                }
              },
            ),
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
              padding: const EdgeInsets.fromLTRB(0, Dims.small, 0, Dims.large),
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

  AlertDialog _storeVisitFailed(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Text(l10n.somethingWentWrong),
      content: Text(l10n.pleaseTryAgain),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          child: Text(l10n.ok),
        ),
      ],
    );
  }
}
