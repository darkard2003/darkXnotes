import 'package:awesome_notes/models/note_model.dart';

class EditNoteState {
  final Note note;
  final Type type;
  final bool loading;

  const EditNoteState(this.note, {this.loading = false, this.type = Type.text});

  EditNoteState copyWith({Note? note, bool? loading}) {
    return EditNoteState(
      note ?? this.note,
      loading: loading ?? this.loading,
    );
  }
}
