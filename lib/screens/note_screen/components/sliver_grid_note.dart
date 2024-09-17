import 'package:awesome_notes/models/note_model.dart';
import 'package:awesome_notes/screens/note_screen/note_state.dart';
import 'package:flutter/material.dart';

typedef OnPress = void Function(Note note);
typedef OnDismiss = void Function(int index);

class SliverNoteGrid extends StatelessWidget {
  final List<NoteState> notes;
  final OnPress onPress;
  final OnDismiss onDismiss;

  const SliverNoteGrid(
      {super.key,
      required this.notes,
      required this.onPress,
      required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Dismissible(
          key: Key(notes[index].note.id),
          onDismissed: (direction) {
            onDismiss(index);
          },
          child: Card(
            child: NoteTile(
              note: notes[index].note,
              onPress: onPress,
            ),
          ),
        ),
        childCount: notes.length,
      ),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 1 / 1.2,
      ),
    );
  }
}

class NoteTile extends StatelessWidget {
  final Note note;
  final OnPress onPress;

  const NoteTile({super.key, required this.note, required this.onPress});

  @override
  Widget build(BuildContext context) {
    if (note is TextNote) {
      final tNote = note as TextNote;
      return InkResponse(
        radius: 50,
        child: GridTile(
          header: tNote.title.isEmpty
              ? null
              : Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    tNote.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
          child: Padding(
            padding: tNote.title.isEmpty
                ? const EdgeInsets.all(15)
                : const EdgeInsets.fromLTRB(15, 42, 15, 15),
            child: Text(
              tNote.content,
            ),
          ),
        ),
        onTap: () {
          onPress(tNote);
        },
      );
    }
    return ListTile(
      title: Text('Some note with id ${note.id}'),
    );
  }
}
