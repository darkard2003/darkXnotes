import 'package:flutter/material.dart';

typedef GenericOptionBuilder<T> = Map<String, T> Function();

Future<T?> showGenericDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  required GenericOptionBuilder builder,
}) async {
  final actions = builder();
  return await showDialog(
    context: context,
    builder: ((context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: actions.keys.map((e) {
          return TextButton(
              onPressed: () {
                Navigator.of(context).pop(actions[e]);
              },
              child: Text(e));
        }).toList(),
      );
    }),
  );
}
