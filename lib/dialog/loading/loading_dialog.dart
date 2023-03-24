import 'dart:async';

import 'package:awesome_notes/dialog/loading/loading_dialog_controller.dart';
import 'package:flutter/material.dart';

class LoadingDialog {
  // make it singleton
  LoadingDialog._();
  static final LoadingDialog _instance = LoadingDialog._();
  factory LoadingDialog() => _instance;

  LoadingDialogController? _controller;

  void show({
    required BuildContext context,
    required String text,
  }) {
    if (_controller?.update(text) ?? false) return;
    _controller = showOverlay(context: context, text: text);
  }

  void hide() {
    if (_controller == null) return;
    _controller!.close();
    _controller = null;
  }

  LoadingDialogController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final textController = StreamController<String>();
    textController.add(text);

    final state = Overlay.of(context);

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withOpacity(0.5),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                minWidth: MediaQuery.of(context).size.width * 0.8,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 30,
                      ),
                      const CircularProgressIndicator(),
                      const SizedBox(height: 40),
                      StreamBuilder<String>(
                          stream: textController.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!,
                                textAlign: TextAlign.center,
                              );
                            } else {
                              return const Text('');
                            }
                          }),
                      const SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    state.insert(overlay);

    return LoadingDialogController(
      close: () {
        overlay.remove();
        textController.close();
        return true;
      },
      update: (text) {
        textController.add(text);
        return true;
      },
    );
  }
}
