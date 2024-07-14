import 'package:awesome_notes/bloc/auth_bloc/auth_bloc.dart';
import 'package:awesome_notes/models/user_data_model.dart';
import 'package:awesome_notes/screens/note_screen/note_screen_view.dart';
import 'package:flutter/material.dart';

import 'note_screen_vm.dart';

class NotesScreen extends StatelessWidget {
  final UserData user;

  const NotesScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NoteScreenVm(
        user: user,
        context: context,
      ),
      child: const NotesScreenView(),
    );
  }
}
