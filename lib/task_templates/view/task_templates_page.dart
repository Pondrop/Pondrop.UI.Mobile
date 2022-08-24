import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pondrop/task_templates/view/task_template_list_item.dart';

import '../bloc/task_templates_bloc.dart';

class TaskTemplatesPage extends StatelessWidget {
  const TaskTemplatesPage({Key? key}) : super(key: key);

  static Route route() {
    return MaterialWithModalsPageRoute<void>(
        builder: (_) => const TaskTemplatesPage(), settings: const RouteSettings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => TaskTemplatesBloc(
            ),
        child: Scaffold(
            appBar: AppBar(
                elevation: 0,
                title: const Text(
                  'Select a task',
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
                ),
                centerTitle: true,
                leading: IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })),
            body: _taskTemplates(context)));
  }

  Widget _taskTemplates(BuildContext context) {
    return Builder(builder: (context) {
      return Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ListView(
            children: const <Widget>[
              TaskTemplateListItem(
                icon: Icons.production_quantity_limits,
                title: "Low stocked item",
                subtitle: "Report low or empty stock levels",
              ),
              // TaskTemplateListItem(
              //   icon: Icons.receipt_long_outlined,
              //   title: "Receipts",
              //   subtitle: "Confirm product pricing at the checkout",
              // ),
              // TaskTemplateListItem(
              //   icon: Icons.inventory_2_outlined,
              //   title: "Product information",
              //   subtitle: "Validate product pricing and locate items in store",
              // )
            ],
          ));
    });
  }
}
