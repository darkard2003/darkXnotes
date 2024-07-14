import 'package:awesome_notes/screens/note_screen/note_state.dart';

class NoteScreenState {
  final List<NoteState> notes;
  final bool hidden;
  final bool loading;
  final String? error;

  const NoteScreenState({
    required this.notes,
    this.hidden = false,
    this.loading = false,
    this.error,
  });

  NoteScreenState copyWith({
    List<NoteState>? notes,
    bool? hidden,
    bool? loading,
    String? error,
  }) {
    return NoteScreenState(
      notes: notes ?? this.notes,
      hidden: hidden ?? this.hidden,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }

  bool get selectionMode => notes.any((element) => element.selected);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NoteScreenState &&
        other.notes == notes &&
        other.hidden == hidden &&
        other.loading == loading &&
        other.error == error;
  }

  @override
  int get hashCode =>
      notes.hashCode ^ loading.hashCode ^ error.hashCode ^ hidden.hashCode;
}
