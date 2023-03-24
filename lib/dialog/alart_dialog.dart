import 'package:flutter/widgets.dart';
import 'generic_dialog.dart';

Future<void> showAlartDialog({
  required String title,
  required String content,
  required BuildContext context,
}) {
  return showGenericDialog<void>(
      context: context,
      title: title,
      content: content,
      builder: () => {
            'Ok': null,
          });
}
