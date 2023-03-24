import 'package:awesome_notes/models/note_model.dart';
import 'package:flutter/material.dart';

typedef OnPress = void Function(Note note);
typedef OnDismiss = void Function(int index);

class SliverNoteGrid extends StatelessWidget {
  final List<Note> notes;
  final OnPress onPress;
  final OnDismiss onDismiss;

  const SliverNoteGrid(
      {Key? key,
      required this.notes,
      required this.onPress,
      required this.onDismiss})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      delegate: SliverChildBuilderDelegate(
        (context, index) => Dismissible(
          key: Key(notes[index].id),
          onDismissed: (direction) {
            onDismiss(index);
          },
          child: Card(
            child: NoteTile(
              note: notes[index],
              onPress: onPress,
            ),
          ),
        ),
        childCount: notes.length,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        mainAxisSpacing: 1,
        crossAxisSpacing: 1,
      ),
    );
  }
}

class NoteTile extends StatelessWidget {
  final Note note;
  final OnPress onPress;
  const NoteTile({Key? key, required this.note, required this.onPress})
      : super(key: key);

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
                        fontWeight: FontWeight.bold, fontSize: 17),
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
              overflow: TextOverflow.ellipsis,
              maxLines: 7,
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
