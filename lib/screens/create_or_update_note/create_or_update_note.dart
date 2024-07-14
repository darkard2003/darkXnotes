import 'package:awesome_notes/bloc/auth_bloc/auth_bloc.dart';
import 'package:awesome_notes/models/note_model.dart';
import 'package:awesome_notes/screens/create_or_update_note/create_update_note_view.dart';
import 'package:awesome_notes/screens/create_or_update_note/create_update_note_vm.dart';
import 'package:awesome_notes/services/cloud_database/cloud_database.dart';
import 'package:flutter/material.dart';

class CreateOrUpdateNote extends StatelessWidget {
  const CreateOrUpdateNote({super.key});

  @override
  Widget build(BuildContext context) {
    var args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    var note = args['note'] as Note;
    var uid = args['uid'] as String;
    var db = args['db'] as CloudDatabase;
    var isUpdate = args['isUpdate'] as bool;

    return BlocProvider(
      create: (context) => CreateUpdateNoteVM(
        context: context,
        uid: uid,
        note: note,
        cloud: db,
        isUpdate: isUpdate,
      ),
      child: const CreateUpdateNoteView(),
    );
  }
}
