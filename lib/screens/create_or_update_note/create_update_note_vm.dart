import 'package:awesome_notes/bloc/auth_bloc/auth_bloc.dart';
import 'package:awesome_notes/models/note_model.dart';
import 'package:awesome_notes/screens/create_or_update_note/note_state.dart';
import 'package:awesome_notes/services/cloud_database/cloud_database.dart';
import 'package:detectable_text_field/detector/sample_regular_expressions.dart';
import 'package:detectable_text_field/widgets/detectable_text_editing_controller.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteVM extends Cubit<EditNoteState> {
  final BuildContext context;
  final String uid;
  final Note note;
  final CloudDatabase cloud;
  final bool isUpdate;

  late final TextEditingController titleController;
  late final DetectableTextEditingController contentController;

  CreateUpdateNoteVM({
    required this.context,
    required this.uid,
    required this.note,
    required this.cloud,
    required this.isUpdate,
  }) : super(
          EditNoteState(note, loading: true),
        ) {
    titleController = TextEditingController(
      text: note.title,
    );
    contentController = DetectableTextEditingController(
      regExp: urlRegex,
      text: (note is TextNote) ? (note as TextNote).content : '',
      detectedStyle: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
      ),
    );

    titleController.addListener(() async {
      if (state.loading) return;
      var text = titleController.text;
      if (text.length >= 1000) {
        titleController.text = titleController.text.substring(0, 1000);
        return;
      }
      updateNote();
    });

    contentController.addListener(() async {
      var text = contentController.text;
      if (text.length >= 10000) {
        contentController.text = contentController.text.substring(0, 10000);
        return;
      }
      updateNote();
    });

    init();
  }

  void init() async {
    if (!isUpdate) {
      await createNote();
    }
    emit(state.copyWith(loading: false));
  }

  Future<void> createNote() async {
    try {
      await cloud.createNote(state.note, uid);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void updateNote() async {
    if (state.loading) return;
    if (state.type == Type.text) {
      var note = (state.note as TextNote).copyWith(
        title: titleController.text,
        content: contentController.text,
      );
      emit(state.copyWith(note: note));
    } else {
      return;
    }
    updateNote();
  }

  void toggleHidden() async {
    var note = state.note.copyWith(isHidden: !state.note.isHidden);
    emit(state.copyWith(note: note));
    updateNote();
  }

  void deleteNote() async {
    try {
      await cloud.deleteNote(state.note, uid);
      if (!context.mounted) return;
      Navigator.of(context).pop();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }

  void share() async {
    if (state.note.noteContent.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note is empty'),
        ),
      );
      return;
    }
    await Share.share(
      state.note.noteContent,
      subject: state.note.title,
    );
  }

  void updateCurrentNote() async {
    try {
      await cloud.updateNote(state.note, uid);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
    }
  }
}
