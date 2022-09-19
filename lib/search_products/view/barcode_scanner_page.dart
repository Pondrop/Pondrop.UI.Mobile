import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:pondrop/l10n/l10n.dart';
import 'package:pondrop/styles/styles.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key, this.automaticallyReturnResult = true})
      : super(key: key);

  final bool automaticallyReturnResult;

  @override
  _BarcodeScannerPageState createState() => _BarcodeScannerPageState();

  static Route<String> route([bool automaticallyReturnResult = true]) {
    return MaterialPageRoute<String>(
        builder: (_) => BarcodeScannerPage(
            automaticallyReturnResult: automaticallyReturnResult));
  }
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage>
    with SingleTickerProviderStateMixin {
  String? barcode;

  MobileScannerController controller = MobileScannerController(
    torchEnabled: false,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final overlayHeight = MediaQuery.of(context).size.height * 0.2;
    final overlayColor = Colors.black.withOpacity(0.5);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: Center(
            child: Text(
          l10n.barcodeScan,
          style: const TextStyle(color: Colors.white),
        )),
        actions: [
          IconButton(
            color: Colors.white,
            icon: ValueListenableBuilder(
              valueListenable: controller.torchState,
              builder: (context, state, child) {
                if (state == null) {
                  return const Icon(
                    Icons.flash_off,
                    color: Colors.white,
                  );
                }
                switch (state as TorchState) {
                  case TorchState.off:
                    return const Icon(
                      Icons.flash_off,
                      color: Colors.white,
                    );
                  case TorchState.on:
                    return const Icon(
                      Icons.flash_on,
                      color: Colors.yellow,
                    );
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => controller.toggleTorch(),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              MobileScanner(
                controller: controller,
                fit: BoxFit.cover,
                onDetect: (barcode, args) {
                  setState(() {
                    this.barcode = barcode.rawValue;
                  });

                  if (widget.automaticallyReturnResult &&
                      this.barcode?.isNotEmpty == true) {
                    Navigator.pop(context, this.barcode);
                  }
                },
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: overlayHeight,
                    color: overlayColor,
                  )),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  alignment: Alignment.bottomCenter,
                  height: overlayHeight,
                  color: overlayColor,
                  child: !widget.automaticallyReturnResult
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: Dims.smallBottomEdgeInsets,
                              child: Text(
                                barcode ?? 'Scanning...',
                                overflow: TextOverflow.fade,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                            Padding(
                                padding: Dims.xxLargeBottomEdgeInsets,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: Icon(
                                          Icons.check,
                                          color: barcode?.isNotEmpty == true
                                              ? Colors.green
                                              : Colors.grey,
                                        ),
                                        iconSize: 32.0,
                                        onPressed: barcode?.isNotEmpty == true
                                            ? () =>
                                                Navigator.pop(context, barcode)
                                            : null),
                                    const SizedBox(
                                      width: Dims.large,
                                    ),
                                    IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: barcode?.isNotEmpty == true
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        iconSize: 32.0,
                                        onPressed: barcode?.isNotEmpty == true
                                            ? () => setState(() {
                                                  barcode = null;
                                                })
                                            : null),
                                  ],
                                ))
                          ],
                        )
                      : const SizedBox.shrink(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
