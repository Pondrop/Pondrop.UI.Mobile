import 'package:advance_expansion_tile/advance_expansion_tile.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/features/store_submission/screens/store_submission_page.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/models/models.dart';
import 'package:pondrop/repositories/repositories.dart';
import 'package:pondrop/features/store_submission/screens/store_submission_summary_page.dart';
import 'package:pondrop/features/styles/styles.dart';
import 'package:pondrop/features/task_templates/task_templates.dart';

import '../bloc/store_report_bloc.dart';
import '../widgets/store_report_list_item.dart';

enum StoreReportGroups {
  newSubmissions,
  acceptedSubmissions,
  completedSubmissions
}

class StoreReportPage extends StatelessWidget {
  static const List<StoreReportGroups> _groups = [
    StoreReportGroups.newSubmissions,
    StoreReportGroups.acceptedSubmissions,
    StoreReportGroups.completedSubmissions
  ];

  const StoreReportPage({Key? key}) : super(key: key);

  static const routeName = '/stores/report';
  static Route<List<TaskIdentifier>> route(Store store) {
    return MaterialWithModalsPageRoute<List<TaskIdentifier>>(
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
            if (state.status == StoreReportStatus.failed) {
              showDialog(
                context: context,
                builder: (_) => _storeVisitFailed(context),
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                leading: Builder(builder: (context) {
                  return BackButton(
                    onPressed: () {
                      final bloc = context.read<StoreReportBloc>();
                      Navigator.pop(
                          context,
                          bloc.state.submissions
                              .map((e) =>
                                  e.toTaskIdentifier(bloc.state.store.id))
                              .toList());
                    },
                  );
                }),
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
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: Expanded(
                      child: BlocBuilder<StoreReportBloc, StoreReportState>(
                          builder: (context, state) {
                        return RefreshIndicator(
                          onRefresh: () {
                            final bloc = context.read<StoreReportBloc>()
                              ..add(const StoreReportRefreshed());
                            return bloc.stream.firstWhere(
                                (e) => e.status != StoreReportStatus.loading);
                          },
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: Dims.small),
                            itemBuilder: (BuildContext context, int index) {
                              switch (_groups[index]) {
                                case StoreReportGroups.newSubmissions:
                                  return _newSubmissionsTile(context, state);
                                case StoreReportGroups.completedSubmissions:
                                  return _completedSubmissionsTile(
                                      context, state);
                                default:
                                  return const SizedBox.shrink();
                              }
                            },
                            itemCount: _groups.length,
                          ),
                        );
                      }),
                    ),
                  )
                ]),
            floatingActionButton:
                BlocBuilder<StoreReportBloc, StoreReportState>(
              builder: (context, state) {
                switch (state.status) {
                  case StoreReportStatus.loading:
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
                  case StoreReportStatus.loaded:
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

  Widget _newSubmissionsTile(BuildContext context, StoreReportState state) {
    if (state.campaigns.isEmpty) return const SizedBox.shrink();

    final l10n = context.l10n;
    final items = <Widget>{};

    for (final i in state.campaigns) {
      final template = state.templates
          .where((e) => e.id == i.submissionTemplateId)
          .firstOrNull;
      if (template != null) {
        items.add(StoreReportListItem(
            iconData: IconData(template.iconCodePoint,
                fontFamily: template.iconFontFamily),
            title: template.title,
            subTitle: i.focusName,
            onTap: () {
              showCupertinoModalBottomSheet(
                context: context,
                builder: (context) => StoreSubmissionPage(
                  visit: state.visit!,
                  submission: template.toStoreSubmission(campaignId: i.id),
                  campaign: i,
                ),
                enableDrag: false,
              );
            }));
      }
    }

    return AdvanceExpansionTile(
      key: const Key('StoreReportGroups_New'),
      initiallyExpanded: true,
      hideIcon: true,
      disabled: true,
      title: Text(
        l10n.newSolo.toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .caption!
            .copyWith(fontWeight: FontWeight.w600),
      ),
      children: [...items],
    );
  }

  Widget _completedSubmissionsTile(
      BuildContext context, StoreReportState state) {
    if (state.submissions.isEmpty) return const SizedBox.shrink();

    final l10n = context.l10n;

    final items = <Widget>{};

    for (final i in state.submissions) {
      final template =
          state.templates.where((e) => e.id == i.templateId).firstOrNull;
      if (template != null) {
        final focus = i.toFocusString();

        items.add(StoreReportListItem(
            iconData: IconData(template.iconCodePoint,
                fontFamily: template.iconFontFamily),
            title: template.title,
            subTitle: focus.isNotEmpty ? focus : template.description,
            photoCount: i.photoCount(),
            onTap: () => Navigator.of(context)
                .push(StoreSubmissionSummaryPage.route(i))));
      }
    }

    return AdvanceExpansionTile(
      key: const Key('StoreReportGroups_Completed'),
      initiallyExpanded: true,
      iconColor: Colors.black87,
      collapsedIconColor: Colors.black87,
      title: Text(
        (state.submissions.length > 1
                ? l10n.itemSpaceItem(
                    state.submissions.length.toString(), l10n.completed)
                : l10n.completed)
            .toUpperCase(),
        style: Theme.of(context)
            .textTheme
            .caption!
            .copyWith(fontWeight: FontWeight.w600),
      ),
      children: [...items],
    );
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
