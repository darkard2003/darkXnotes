import 'package:awesome_notes/models/note_model.dart';

class NoteState {
  final Note note;
  final bool selected;

  const NoteState(this.note, {this.selected = false});

  NoteState copyWith({Note? note, bool? selected}) {
    return NoteState(
      note ?? this.note,
      selected: selected ?? this.selected,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteState &&
        other.note == note &&
        other.selected == selected;
  }

  @override
  int get hashCode => note.hashCode ^ selected.hashCode;
}
