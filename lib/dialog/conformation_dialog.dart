import 'package:flutter/widgets.dart';
import 'generic_dialog.dart';

Future<bool?> showConformationDialog({
  required BuildContext context,
  required String title,
  required String content,
}) async {
  return await showGenericDialog(
      context: context,
      title: title,
      content: content,
      builder: () {
        return {
          'Yes': true,
          'No': false,
        };
      });
}
