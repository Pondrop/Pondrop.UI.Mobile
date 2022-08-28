import 'dart:ui';

import 'package:flutter/material.dart';

class DialogConfig {
  const DialogConfig({
    this.title = '',
    this.iconData,
    this.header = '',
    this.body = '',
    required this.okayButtonText,
    this.cancelButtonText = '',
  });

  final String title;
  final IconData? iconData;
  final String header;
  final String body;
  final String okayButtonText;
  final String cancelButtonText;
}

class DialogPage extends StatelessWidget {
  const DialogPage({super.key});

  static Route<bool> route(DialogConfig config) {
    return PageRouteBuilder(
        opaque: false,
        pageBuilder: (_, __, ___) => const DialogPage(),
        settings: RouteSettings(arguments: config));
  }

  @override
  Widget build(BuildContext context) {
    final config = ModalRoute.of(context)!.settings.arguments as DialogConfig;

    final children = <Widget>[];
    const separator = SizedBox(
      height: 12,
    );

    if (config.title.isNotEmpty) {
      children.add(Text(
        config.title,
        style: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Colors.white, fontWeight: FontWeight.w500),
      ));
      children.add(separator);
    }

    if (config.iconData != null) {
      children.add(Padding(
        padding: const EdgeInsets.all(6),
        child: Icon(
          config.iconData,
          color: Colors.white,
          size: 96,
        ),
      ));
      children.add(separator);
    }

    if (config.header.isNotEmpty) {
      children.add(Text(config.header,
          style: Theme.of(context)
              .textTheme
              .headline6!
              .copyWith(color: Colors.white, fontWeight: FontWeight.w600)));
      children.add(const SizedBox(
        height: 8,
      ));
    }

    if (config.body.isNotEmpty) {
      children.add(Text(config.body,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(
                color: Colors.white,
              )));
      children.add(separator);
    }

    children.add(const SizedBox(
      height: 24,
    ));
    children.add(ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop(true);
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.white, onPrimary: Colors.black),
      child: Text(config.okayButtonText,
          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 18)),
    ));
    children.add(separator);

    if (config.cancelButtonText.isNotEmpty) {
      TextButton(
          onPressed: () {
            Navigator.of(context).pop(false);
          },
          child: Text(config.cancelButtonText,
              style: Theme.of(context).textTheme.bodyText1!.copyWith(
                    color: Colors.white,
                  )));
      children.add(separator);
    }

    return Container(
      color: Colors.black.withOpacity(0.5),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2,
          sigmaY: 2,
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 10),
          child: Center(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24.0),
              ),
              color: Colors.black.withOpacity(0.75),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: children),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
