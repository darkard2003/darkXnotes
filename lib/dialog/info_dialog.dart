import 'package:awesome_notes/models/text_note_model.dart';
import 'package:flutter/widgets.dart';
import 'generic_dialog.dart';

Future<void> showInfoDialog({
  required BuildContext context,
  required TextNote note,
}) async {
  final title = note.title;
  final createdAt = note.createdAt;
  final updatedAt = note.updatedAt;
  final info =
      'Created at: ${createdAt.day}-${createdAt.month}-${createdAt.year}\nUpdated at: ${updatedAt.day}-${updatedAt.month}-${updatedAt.year}';
  await showGenericDialog(
    context: context,
    title: title,
    content: info,
    builder: () => {
      'Ok': Null,
    },
  );
}
