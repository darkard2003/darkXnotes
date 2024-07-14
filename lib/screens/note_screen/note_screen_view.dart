import 'package:awesome_notes/bloc/auth_bloc/auth_bloc.dart';
import 'package:awesome_notes/screens/note_screen/components/sliver_grid_note.dart';
import 'package:flutter/material.dart';
import 'package:avatars/avatars.dart';

import 'note_screen_vm.dart';

class NotesScreenView extends StatelessWidget {
  const NotesScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NoteScreenVm>();
    final state = vm.state;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              snap: true,
              elevation: 8,
              title: Text(state.hidden ? 'Hidden notes' : 'Notes'),
              actions: [
                Avatar(
                  shape: AvatarShape.circle(18),
                  border: Border.all(
                    color: const Color.fromRGBO(245, 245, 245, 1),
                    width: 2,
                  ),
                  margin: const EdgeInsets.all(10),
                  name: vm.user.name,
                  onTap: vm.openSettingsDialog,
                  placeholderColors: [
                    Theme.of(context).colorScheme.primary,
                  ],
                  textStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              sliver: Builder(
                builder: (context) {
                  if (state.loading) {
                    return const SliverToBoxAdapter(
                      child: LinearProgressIndicator(),
                    );
                  }
                  return SliverNoteGrid(
                      notes: state.notes,
                      onPress: vm.openEditNote,
                      onDismiss: (index) =>
                          vm.deleteNote(state.notes[index].note));
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onDoubleTap: vm.toggleHidden,
        child: FloatingActionButton(
          shape: const CircleBorder(),
          onPressed: vm.createNote,
          child: const Icon(Icons.edit_outlined),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
